//
//  TimeslotViewModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 08/05/25.
//

import CloudKit
import Foundation
import SwiftUI

enum TimeslotManagerState{
    case loading
    case loaded([Timeslot], [Timeslot:Bool])
    case error(NetworkError)
}


class TimeslotViewModel : ObservableObject {
    @Published private(set) var managerState: TimeslotManagerState = .loading
    @Published var timeSlotAvailable: [Timeslot: Bool] = [:]
    @Published var allTimeslot: [Timeslot] = []
    
    private var database: CKDatabase?
    private var selectedCollabSpace:CollabSpace?
    private var selectedDate:Date?
    
    init(){}
    
    static func stub() -> TimeslotViewModel {
        TimeslotViewModel()
    }
    
    
    func configure(
        database: CKDatabase,
        selectedDate: Date,
        selectedCollabSpace: CollabSpace
    ) {
        self.database = database
        self.selectedDate = selectedDate
        self.selectedCollabSpace = selectedCollabSpace
    }
    
    public func fetchTimeSlot(){
        // fetch all timeslot data
        let query = CKQuery(recordType: "TimeslotRecords", predicate: NSPredicate(value: true))
        database!.perform(query, inZoneWith: nil) { results, error in
            guard let records = results else { return }
            do{
                DispatchQueue.main.async {
                    let timeslots = records.compactMap { record -> Timeslot? in
                        guard
                            
                            let startHour = record["startHour"] as? Double,
                            let endHour = record["endHour"] as? Double
                                
                        else {
                            return nil
                        }
                        let recordName = record.recordID.recordName
                        let timeslot = Timeslot(recordName: recordName, startHour: startHour, endHour: endHour)
                        return timeslot
                    }
                    
                    self.allTimeslot = self.sortTimeslot(timeslots: timeslots)
                    self.computeTimeSlotAvailability(timeslots: self.allTimeslot)
                    
                    // testing first!
                    self.updateState(.loaded(self.allTimeslot, self.timeSlotAvailable))
                    // for each time slot, find in booking records if there is a booking with the selected date, collabspace, and timeslot
                    
                }
            }
        }
        
    }
    private func computeTimeSlotAvailability(timeslots: [Timeslot]){
        let now = Date()
        let calendar = Calendar.current
        let currentHour = Double(calendar.component(.hour, from: now))
        let currentMinute = Double(calendar.component(.minute, from: now))
        let currentTimeAsDouble = currentHour + (currentMinute / 60.0)
        
        for timeslot in timeslots {
            let isAvailable = timeslot.endHour > currentTimeAsDouble
            self.timeSlotAvailable[timeslot] = isAvailable
        }
        
        // test with space and time
        // search for booking records
    }
    //
    //    private func searchForBookingRecords(timeslot: Timeslot, collabSpace: CollabSpace, date: Date, completion: @escaping (Bool) -> Void) {
    //        let timeslotRef = CKRecord.Reference(recordID: CKRecord.ID(recordName: timeslot.id.uuidString), action: .none)
    //        let collabSpaceRef = CKRecord.Reference(recordID: CKRecord.ID(recordName: collabSpace.id.uuidString), action: .none)
    //
    //        let startOfDay = Calendar.current.startOfDay(for: date)
    //        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    //
    //        let datePredicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as CVarArg, endOfDay as CVarArg)
    //        let timeslotPredicate = NSPredicate(format: "timeslot == %@", timeslotRef)
    //        let collabSpacePredicate = NSPredicate(format: "collabSpace == %@", collabSpaceRef)
    //
    //        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timeslotPredicate, collabSpacePredicate, datePredicate])
    //
    //        let query = CKQuery(recordType: "BookingRecord", predicate: predicate)
    //
    //        database.perform(query, inZoneWith: nil) { records, error in
    //            if let error = error {
    //                print("Booking fetch error: \(error.localizedDescription)")
    //                DispatchQueue.main.async {
    //                    completion(false)
    //                }
    //                return
    //            }
    //
    //            let hasBooking = (records?.isEmpty == false)
    //            DispatchQueue.main.async {
    //                completion(!hasBooking)
    //            }
    //        }
    //    }
    //
    
    private func sortTimeslot(timeslots:[Timeslot]) -> [Timeslot]{
        let sortedTimeslots = timeslots.sorted { $0.startHour < $1.startHour }
        return sortedTimeslots
    }
}

extension TimeslotViewModel{
    private func updateState(_ state: TimeslotManagerState){
        DispatchQueue.main.async {
            self.managerState = state
        }
    }
}

