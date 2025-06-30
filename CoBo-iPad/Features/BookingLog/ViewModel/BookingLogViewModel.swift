////
////  BookingLogViewModel.swift
////  CoBo-iPad
////
////  Created by Amanda on 30/06/25.
////
//
//import CloudKit
//import Foundation
//import SwiftUI
//
//
//enum BookingLogManagerState{
//    case loading
//    case loaded([Booking])
//    case error(NetworkError)
//}
//
//
//
//class BookingLogViewModel : ObservableObject {
//    @Published var selectedDate: Date
//    private let database: CKDatabase
//    @Published private(set) var managerState: BookingLogManagerState = .loading
//    @Published var bookingLogs: [Booking] = []
//
//    init(selectedDate: Date, database: CKDatabase) {
//        self.selectedDate = selectedDate
//        self.database = database
//    }
//
//    func fetchBookingRecords(){
//        let predicate = NSPredicate(format: "Date >= %@ AND Date < %@", selectedDate as CVarArg, Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)! as CVarArg)
//        let query = CKQuery(recordType: "BookingRecords", predicate: predicate)
//        
//        database.perform(query, inZoneWith: nil) { [weak self] (records, error) in
//            guard let self = self else { return }
//            
//            if let error = error {
//                DispatchQueue.main.async {
//                    print("Error fetching booking records: \(error.localizedDescription)")
//                    self.updateState(.error(.unknown))
//                }
//                return
//            }
//            
//            guard let bookingRecords = records, !bookingRecords.isEmpty else {
//                DispatchQueue.main.async {
//                    self.updateState(.loaded([]))
//                }
//                return
//            }
//            
//            // Collect all unique record IDs from the references to be fetched
//            var recordIDsToFetch = Set<CKRecord.ID>()
//            
//            for record in bookingRecords {
//                if let userIDRef = record["UserID"] as? CKRecord.Reference,
//                   let timeslotIDRef = record["TimeSlotID"] as? CKRecord.Reference,
//                   let collabSpaceIDRef = record["CollabSpaceRecordID"] as? CKRecord.Reference {
//                    
//                    recordIDsToFetch.insert(userIDRef.recordID)
//                    recordIDsToFetch.insert(timeslotIDRef.recordID)
//                    recordIDsToFetch.insert(collabSpaceIDRef.recordID)
//                }
//            }
//            
//            guard !recordIDsToFetch.isEmpty else {
//                DispatchQueue.main.async {
//                    self.updateState(.loaded([]))
//                }
//                return
//            }
//            
//            // Fetch all the referenced records in a single batch operation for efficiency
//            let fetchRecordsOperation = CKFetchRecordsOperation(recordIDs: Array(recordIDsToFetch))
//            fetchRecordsOperation.database = self.database
//            
//            var fetchedRecordsById: [CKRecord.ID: CKRecord] = [:]
//            
//            fetchRecordsOperation.perRecordCompletionBlock = { (recordID, record, error) in
//                if let record = record {
//                    fetchedRecordsById[recordID] = record
//                } else {
//                    print("Error fetching referenced record \(recordID.recordName): \(error?.localizedDescription ?? "unknown error")")
//                }
//            }
//            fetchRecordsOperation.perRecordCompletionBlock = { (record, recordID, error) in
//                if let record = record {
//                    fetchedRecordsById[recordID] = record
//                } else {
//                    print("Error fetching referenced record \(recordID.recordName): \(error?.localizedDescription ?? "unknown error")")
//                }
//            }
//
//            fetchRecordsOperation.fetchRecordsCompletionBlock = { [weak self] (recordsByRecordID, error) in
//                guard let self = self else { return }
//                DispatchQueue.main.async {
//                    if let error = error {
//                        print("Error fetching all referenced records: \(error.localizedDescription)")
//                        self.updateState(.error(.unknown))
//                        return
//                    }
//                    
//                    var finalBookings: [Booking] = []
//                    // Now, iterate through the booking records and map them to the models
//                    for bookingRecord in bookingRecords {
//                        // 1. Parse fields from the BookingRecords record
//                        guard let meetingName = bookingRecord["Name"] as? String,
//                              let purposeRaw = bookingRecord["Purpose"] as? String,
//                              let purpose = BookingPurpose(rawValue: purposeRaw),
//                              let date = bookingRecord["Date"] as? Date,
//                              let statusRaw = bookingRecord["Status"] as? String,
//                              let status = BookingStatus(rawValue: statusRaw),
//                              let checkInCode = bookingRecord["CheckInCode"] as? String else {
//                            print("Failed to parse main booking record fields.")
//                            continue
//                        }
//                        
//                        // 2. Get the references and fetch referenced records from the fetched map
//                        guard let userIDRef = bookingRecord["UserID"] as? CKRecord.Reference,
//                              let timeslotIDRef = bookingRecord["TimeSlotID"] as? CKRecord.Reference,
//                              let collabSpaceIDRef = bookingRecord["CollabSpaceRecordID"] as? CKRecord.Reference,
//                              let userRecord = fetchedRecordsById[userIDRef.recordID],
//                              let timeslotRecord = fetchedRecordsById[timeslotIDRef.recordID],
//                              let collabSpaceRecord = fetchedRecordsById[collabSpaceIDRef.recordID] else {
//                            print("Failed to find all referenced records in the fetched map.")
//                            continue
//                        }
//                        
//                        // 3. Parse the referenced records into their respective models
//                        // --- Map UserRecords to User Model (Coordinator) ---
//                        guard let userName = userRecord["name"] as? String,
//                              let userEmail = userRecord["email"] as? String else { continue }
//                        let coordinator = User(name: userName, email: userEmail)
//                        
//                        // --- Map TimeslotRecords to Timeslot Model ---
//                        guard let timeslotStartTime = timeslotRecord["startTime"] as? Date,
//                              let timeslotEndTime = timeslotRecord["endTime"] as? Date else { continue }
//                        let timeslot = Timeslot(startTime: timeslotStartTime, endTime: timeslotEndTime)
//                        
//                        // --- Map CollabSpaceRecords to CollabSpace Model ---
//                        guard let collabSpaceName = collabSpaceRecord["name"] as? String else { continue }
//                        let collabSpace = CollabSpace(name: collabSpaceName)
//                        
//                        // 4. Create the final Booking model
//                        let booking = Booking(
//                            meetingName: meetingName,
//                            coordinator: coordinator,
//                            purpose: purpose,
//                            date: date,
//                            timeslot: timeslot,
//                            collabSpace: collabSpace,
//                            status: status,
//                            checkInCode: checkInCode
//                        )
//                        finalBookings.append(booking)
//                    }
//                    
//                    // 5. Update the state on the main thread
//                    self.bookingLogs = finalBookings
//                    self.updateState(.loaded(finalBookings))
//                }
//            }
//            
//            // Add the operation to the database to start fetching
//            self.database.add(fetchRecordsOperation)
//        }
//    }
//
//    private func updateState(_ newState: BookingLogManagerState) {
//        managerState = newState
//    }
//}
//
