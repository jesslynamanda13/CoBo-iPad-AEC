//
//  BookingController.swift
//  CoBo-iPad
//
//  Created by Amanda on 16/05/25.
//

import CloudKit
import EventKit
import MessageUI

class BookingController {
    private let database: CKDatabase
    init(database: CKDatabase) {
           self.database = database
       }
    
    func insertBookingWithReferences(booking: Booking) {
        
        let timeslotRecordName = booking.timeslot.recordName
        let collabSpaceRecordName = booking.collabSpace.recordName
        let coordinatorRecordName = booking.coordinator.recordName
        let participantRecordNames = booking.participants.map { $0.recordName }
        
        fetchExistingCheckInCodes { existingCodes in
            let uniqueCode = self.generateUniqueCheckInCode(existingCodes: existingCodes)
            booking.checkInCode = uniqueCode
            
            self.fetchRecordDatas(timeslotRecordName: timeslotRecordName, collabSpaceRecordName: collabSpaceRecordName, coordinatorRecordName: coordinatorRecordName, participantRecordNames: participantRecordNames) {
                timeslotRecord, collabSpaceRecord, coordinatorRecord, participantRecords in
                
                guard let timeslotRecord = timeslotRecord,
                      let collabSpaceRecord = collabSpaceRecord,
                      let coordinatorRecord = coordinatorRecord
                else {
                    print("Failed to fetch Timeslot, CollabSpace record, User Record.")
                    return
                }
                
                let bookingRecord = CKRecord(recordType: "BookingRecords")
                
                bookingRecord["Name"] = booking.meetingName
                bookingRecord["UserID"] = CKRecord.Reference(record: coordinatorRecord, action: .none)
                bookingRecord["Purpose"] = booking.purpose.displayName
                bookingRecord["BookingStatus"] = "Not Checked In"
                bookingRecord["CheckInCode"] = booking.checkInCode ?? ""
                bookingRecord["Date"] = booking.date
                bookingRecord["Status"] = booking.status.rawValue
                bookingRecord["TimeSlotID"] = CKRecord.Reference(record: timeslotRecord, action: .none)
                bookingRecord["CollabSpaceRecordID"] = CKRecord.Reference(record: collabSpaceRecord, action: .none)
                let participantReferences = participantRecords.map {
                    CKRecord.Reference(record: $0, action: .none)
                }
                bookingRecord["ParticipantsID"] = participantReferences
                
                self.database.save(bookingRecord) { record, error in
                    if let error = error {
                        print("Error saving booking: \(error)")
                    } else {
                        print("Booking saved successfully.")
                       
                    }
                }
            }
        }
    }


    func fetchRecord(recordType: String, recordName: String, completion: @escaping (CKRecord?) -> Void) {
        let recordID = CKRecord.ID(recordName: recordName)
        database.fetch(withRecordID: recordID) { record, error in
            if let error = error {
                print("Error fetching \(recordType) record with recordName \(recordName): \(error)")
                completion(nil)
                return
            }
            completion(record)
        }
    }

    func fetchRecordDatas(timeslotRecordName: String, collabSpaceRecordName: String, coordinatorRecordName:String, participantRecordNames: [String], completion: @escaping (CKRecord?, CKRecord?, CKRecord?, [CKRecord]) -> Void) {
        let group = DispatchGroup()
        
        var fetchedTimeslot: CKRecord?
        var fetchedCollabSpace: CKRecord?
        var fetchedCoordinator : CKRecord?
        var fetchedParticipants: [CKRecord] = []
        
        group.enter()
        fetchRecord(recordType: "TimeSlotRecords", recordName: timeslotRecordName) { record in
            fetchedTimeslot = record
            group.leave()
        }
        
        group.enter()
        fetchRecord(recordType: "CollabSpaceRecords", recordName: collabSpaceRecordName) { record in
            fetchedCollabSpace = record
            group.leave()
        }
        
        group.enter()
        fetchRecord(recordType: "UserRecords", recordName: coordinatorRecordName) { record in
            fetchedCoordinator = record
            group.leave()
        }
        
        for name in participantRecordNames {
               group.enter()
               fetchRecord(recordType: "UserRecords", recordName: name) { record in
                   if let record = record {
                       fetchedParticipants.append(record)
                   }
                   group.leave()
               }
           }
        
        group.notify(queue: .main) {
            completion(fetchedTimeslot, fetchedCollabSpace, fetchedCoordinator, fetchedParticipants)
        }
    }
    
    func fetchExistingCheckInCodes(completion: @escaping (Set<String>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "BookingRecords", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error fetching existing check-in codes: \(error)")
                completion([])
                return
            }
            
            let codes = records?.compactMap { $0["CheckInCode"] as? String }.filter { !$0.isEmpty } ?? []
            completion(Set(codes))
        }
    }

    
    func generateUniqueCheckInCode(existingCodes: Set<String>) -> String {
        var code: String
        repeat {
            code = String(format: "%06d", Int.random(in: 0...999999))
        } while existingCodes.contains(code)
        return code
    }
    
    

}
extension BookingController {
    func insertBookingAsync(
        meetingName: String,
        coordinator: String,
        purpose: String,
        date: Date,
        timeslotID: String,
        collabSpaceID: String,
        completion: @escaping (String?) -> Void
    ) {
        
        let database = CKContainer(identifier: "iCloud.CoBoCloud").publicCloudDatabase
        let timeslotRefID = CKRecord.ID(recordName: timeslotID)
        let collabSpaceRefID = CKRecord.ID(recordName: collabSpaceID)

        let fetchOperation = CKFetchRecordsOperation(recordIDs: [timeslotRefID, collabSpaceRefID])
        fetchOperation.fetchRecordsCompletionBlock = { recordsByID, error in
            if let error = error {
                print("❌ Error fetching references: \(error)")
                completion(nil)
                return
            }

            guard let timeslotRecord = recordsByID?[timeslotRefID],
                  let collabSpaceRecord = recordsByID?[collabSpaceRefID] else {
                print("❌ Missing one or more reference records.")
                completion(nil)
                return
            }

            let bookingRecord = CKRecord(recordType: "BookingRecords")
            bookingRecord["Name"] = meetingName
            bookingRecord["Coordinator"] = coordinator
            bookingRecord["Purpose"] = purpose
            bookingRecord["Date"] = date
            bookingRecord["BookingStatus"] = "Not Checked In"
            bookingRecord["Status"] = "Pending"
            bookingRecord["CheckInCode"] = self.generateUniqueCheckInCode(existingCodes: [])
            bookingRecord["TimeSlotID"] = CKRecord.Reference(record: timeslotRecord, action: .none)
            bookingRecord["CollabSpaceRecordID"] = CKRecord.Reference(record: collabSpaceRecord, action: .none)
            
            database.save(bookingRecord) { savedRecord, saveError in
                if let saveError = saveError {
                    completion(nil)
                } else {
                    print("✅ Booking saved!")
                    completion(bookingRecord["CheckInCode"] as? String)
                }
            }
        }

        database.add(fetchOperation)
    }
}
