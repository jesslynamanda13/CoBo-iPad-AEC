////
////  BookingLogViewModel.swift
////  CoBo-iPad
////
////  Created by Amanda on 30/06/25.
////
//

import CloudKit
import Foundation
import SwiftUI

enum BookingLogManagerState {
    case loading
    case loaded([Booking])
    case error(Error)
}

class BookingLogViewModel: ObservableObject {
    @Published var selectedDate: Date
    @Published private(set) var managerState: BookingLogManagerState = .loading
    
    private let database: CKDatabase

    init(selectedDate: Date, database: CKDatabase = CKContainer.default().publicCloudDatabase) {
        self.selectedDate = selectedDate
        self.database = database
    }

    func fetchBookingRecords() {
        print("Fetching for date: \(selectedDate.formatted())")
        DispatchQueue.main.async {
            self.managerState = .loading
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            DispatchQueue.main.async {
                self.managerState = .error(NSError(domain: "DateError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not calculate end of day."]))
            }
            return
        }

        let predicate = NSPredicate(format: "Date >= %@ AND Date < %@ AND BookingStatus != %@", startOfDay as CVarArg, endOfDay as CVarArg, "Cancelled" as CVarArg)
        let query = CKQuery(recordType: "BookingRecords", predicate: predicate)

        database.perform(query, inZoneWith: nil) { [weak self] (records, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching booking records: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.managerState = .error(error)
                }
                return
            }

            guard let bookingRecords = records, !bookingRecords.isEmpty else {
                print("No records found for the selected date.")
                DispatchQueue.main.async {
                    self.managerState = .loaded([])
                }
                return
            }
            
            print("Found \(bookingRecords.count) booking records. Now fetching details...")
            self.fetchAllBookingDetails(from: bookingRecords)
        }
    }

    private func fetchAllBookingDetails(from records: [CKRecord]) {
        var bookings: [Booking] = []
        let group = DispatchGroup()

        for record in records {
            group.enter()
            self.convertToBooking(from: record) { result in
                switch result {
                case .success(let booking):
                    // Use a lock or serial queue if you were modifying the array from multiple threads.
                    // For DispatchGroup, appending after each completion is fine.
                    bookings.append(booking)
                case .failure(let error):
                    print("Failed to convert record \(record.recordID.recordName): \(error.localizedDescription)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            print("Finished processing all records. Final count: \(bookings.count)")
            
            let sortedBookings = bookings.sorted { b1, b2 in
                let relevance1 = b1.timeslot.getRelevance(for: b1.date)
                let relevance2 = b2.timeslot.getRelevance(for: b2.date)

                if relevance1 != relevance2 {
                    return relevance1 < relevance2
                } else {
                    return relevance1 == .past ? b1.timeslot.startHour > b2.timeslot.startHour : b1.timeslot.startHour < b2.timeslot.startHour
                }
            }
            
            self?.managerState = .loaded(sortedBookings)
        }
    }

    private func convertToBooking(from record: CKRecord, completion: @escaping (Result<Booking, Error>) -> Void) {
        guard let userRef = record["UserID"] as? CKRecord.Reference,
              let timeslotRef = record["TimeSlotID"] as? CKRecord.Reference,
              let collabSpaceRef = record["CollabSpaceRecordID"] as? CKRecord.Reference else {
            completion(.failure(NSError(domain: "MissingReference", code: 1, userInfo: [NSLocalizedDescriptionKey: "A required reference (User, Timeslot, or CollabSpace) is missing."])))
            return
        }
        
        let participantsRefs = record["ParticipantsID"] as? [CKRecord.Reference] ?? []
        
        var recordIDsToFetch = [userRef.recordID, timeslotRef.recordID, collabSpaceRef.recordID]
        recordIDsToFetch.append(contentsOf: participantsRefs.map { $0.recordID })
        let uniqueRecordIDs = Array(Set(recordIDsToFetch))

        let fetchOperation = CKFetchRecordsOperation(recordIDs: uniqueRecordIDs)

        var fetchedRecords: [CKRecord.ID: CKRecord] = [:]

        fetchOperation.perRecordResultBlock = { recordID, result in
            switch result {
            case .success(let fetchedRecord):
                fetchedRecords[recordID] = fetchedRecord
            case .failure(let error):
                print("Failed to fetch sub-record \(recordID): \(error)")
            }
        }

        fetchOperation.completionBlock = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {
                    completion(.failure(NSError(domain: "SelfDeallocated", code: 99)))
                    return
                }

                guard let coordinatorRecord = fetchedRecords[userRef.recordID],
                      let coordinator = self.convertToUser(from: coordinatorRecord),
                      let timeslotRecord = fetchedRecords[timeslotRef.recordID],
                      let timeslot = self.convertToTimeslot(from: timeslotRecord),
                      let collabSpaceRecord = fetchedRecords[collabSpaceRef.recordID],
                      let collabSpace = self.convertToCollabSpace(from: collabSpaceRecord) else {
                    completion(.failure(NSError(domain: "DataCorruption", code: 2, userInfo: [NSLocalizedDescriptionKey: "Could not construct required objects from fetched records."])))
                    return
                }

                let participantRecords = participantsRefs.compactMap { fetchedRecords[$0.recordID] }
                let participants = participantRecords.compactMap { self.convertToUser(from: $0) }

                let purposeString = record["Purpose"] as? String ?? ""
                let purpose = BookingPurpose(stringValue: purposeString)
                
                let statusString = record["BookingStatus"] as? String ?? ""
                let status = BookingStatus(rawValue: statusString) ?? .notCheckedIn
                
                let booking = Booking(
                    recordName: record.recordID.recordName,
                    meetingName: record["Name"] as? String ?? "Untitled Meeting",
                    coordinator: coordinator,
                    purpose: purpose,
                    date: record["Date"] as? Date ?? Date(),
                    participants: participants,
                    timeslot: timeslot,
                    collabSpace: collabSpace,
                    status: status,
                    checkInCode: record["CheckInCode"] ?? ""
                )

                completion(.success(booking))
            }
        }


        self.database.add(fetchOperation)
    }

    private func convertToUser(from record: CKRecord) -> User? {
        guard let name = record["Name"] as? String,
              let email = record["Email"] as? String,
              let roleRawValue = record["Role"] as? String,
              let role = UserRole(rawValue: roleRawValue) else {
            return nil
        }
        return User(recordName: record.recordID.recordName ?? "", name: name, role: role, email: email)
    }

    private func convertToTimeslot(from record: CKRecord) -> Timeslot? {
        guard let startHour = record["startHour"] as? Double,
              let endHour = record["endHour"] as? Double else {
            return nil
        }
        return Timeslot(recordName: record.recordID.recordName ?? "" ,startHour: startHour, endHour: endHour)
    }
    
    private func convertToCollabSpace(from record: CKRecord) -> CollabSpace? {
        guard let name = record["Name"] as? String,
              let capacity = record["Capacity"] as? Int,
              let whiteboardAmount = record["WhiteboardAmount"] as? Int,
              let tableWhiteboardAmount = record["TableWhiteboardAmount"] as? Int,
              let tvAvailable = record["TVAvailable"] as? Bool else {
            return nil
        }

        let imageAssets = record["SpaceImages"] as? [CKAsset] ?? []
        let images = imageAssets.compactMap { $0.fileURL }
        
        let locationImageAsset = record["LocationImage"] as? CKAsset
        let locationImage = locationImageAsset?.fileURL

        return CollabSpace(
            recordName: record.recordID.recordName ?? "",
            name: name,
            images: images,
            locationImage: locationImage,
            capacity: capacity,
            whiteboardAmount: whiteboardAmount,
            tableWhiteboardAmount: tableWhiteboardAmount,
            tvAvailable: tvAvailable
        )
    }
}
