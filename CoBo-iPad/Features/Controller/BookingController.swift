//
//  BookingController.swift
//  CoBo-iPad
//
//  Created by Amanda on 16/05/25.
//

import CloudKit

class BookingController {
    private let database: CKDatabase
    init(database: CKDatabase) {
           self.database = database
       }
    func insertBookingWithReferences(booking: Booking) {
        print("Meeting name: ", booking.meetingName)
        print("Name: ", booking.coordinator.name)
        print("Using database: \(database)")

        print("Timeslot: ", booking.timeslot)
        print("Collabspace: ", booking.collabSpace.recordName)
        
        let timeslotRecordName = booking.timeslot.recordName
        let collabSpaceRecordName = booking.collabSpace.recordName
        print("Insert booking with references", booking)
        
        fetchTimeslotAndCollabSpace(timeslotRecordName: timeslotRecordName, collabSpaceRecordName: collabSpaceRecordName) { timeslotRecord, collabSpaceRecord in
            
            guard let timeslotRecord = timeslotRecord,
                  let collabSpaceRecord = collabSpaceRecord else {
                print("Failed to fetch Timeslot or CollabSpace record.")
                return
            }
            
            print("fetched timeslot and collabSpace")
            self.fetchUserRecord(named: booking.coordinator.name) { userRecord in
                guard let userRecord = userRecord else {
                    print("Coordinator user not found in CloudKit.")
                    return
                }
                
                
                print("fetched user")
                
                let bookingRecord = CKRecord(recordType: "BookingRecords")
                bookingRecord["Name"] = booking.meetingName
                bookingRecord["UserID"] = CKRecord.Reference(record: userRecord, action: .none)
                bookingRecord["Purpose"] = booking.purpose.displayName
                bookingRecord["Date"] = booking.date
                bookingRecord["CheckInCode"] = booking.checkInCode ?? ""
                bookingRecord["Status"] = booking.status.rawValue
                
                bookingRecord["TimeSlotID"] = CKRecord.Reference(record: timeslotRecord, action: .none)
                bookingRecord["CollabSpaceRecordID"] = CKRecord.Reference(record: collabSpaceRecord, action: .none)
                
                
                CKContainer.default().publicCloudDatabase.save(bookingRecord) { record, error in
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

    func fetchTimeslotAndCollabSpace(timeslotRecordName: String, collabSpaceRecordName: String, completion: @escaping (CKRecord?, CKRecord?) -> Void) {
        let group = DispatchGroup()
        
        var fetchedTimeslot: CKRecord?
        var fetchedCollabSpace: CKRecord?
        
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
        
        group.notify(queue: .main) {
            completion(fetchedTimeslot, fetchedCollabSpace)
        }
//        print("Timeslot: ", fetchedTimeslot ?? <#default value#>)
//        print("Collabspace: ", fetchedCollabSpace ?? <#default value#>)
    }

    func fetchUserRecord(named name: String, completion: @escaping (CKRecord?) -> Void) {
        print("Fetching for user with ", name)
        
        let predicate = NSPredicate(format: "Name == %@", name)
        let query = CKQuery(recordType: "UserRecords", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error fetching user: \(error)")
                completion(nil)
                return
            }
            completion(records?.first)
        }
    }

}

