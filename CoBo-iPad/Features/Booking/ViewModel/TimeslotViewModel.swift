//
//  TimeslotViewModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 08/05/25.
//

import CloudKit
import Foundation
import SwiftUI
import Combine
enum TimeslotManagerState{
    case loading
    case loaded([Timeslot], [Timeslot:Bool])
    case error(NetworkError)
}


class TimeslotViewModel : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var id = UUID()
    @Published private(set) var managerState: TimeslotManagerState = .loading
    @Published var timeSlotAvailable: [Timeslot: Bool] = [:]
    @Published var allTimeslot: [Timeslot] = []
    @Published var displayedTimeslots: [DisplayedTimeslot] = []
    private var database: CKDatabase
    private var selectedCollabSpace:CollabSpace
    
    @Published var selectedDate:Date
    
    init(selectedCollabSpace: CollabSpace, database: CKDatabase, selectedDatePublisher: Published<Date>.Publisher) {
            self.selectedCollabSpace = selectedCollabSpace
            self.database = database
            self.selectedDate = Date()

            selectedDatePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] newDate in
                    guard let self = self else { return }
                    self.selectedDate = newDate
                    self.fetchTimeSlot()
                }
                .store(in: &cancellables)
        }
    
//    init(
//         selectedCollabSpace: CollabSpace,
//         database: CKDatabase,
//         selectedDate: Binding<Date>
//    ) {
//        self.id = UUID()
//        self.selectedCollabSpace = selectedCollabSpace
//        self.database = database
//        self.selectedDate = selectedDate
//    }
    
    public func fetchTimeSlot(){
        self.updateState(.loading)
        let query = CKQuery(recordType: "TimeslotRecords", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { results, error in
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
                    self.computeTimeSlotAvailability(timeslots: self.allTimeslot) { availability in
                        self.timeSlotAvailable = availability
                        self.updateState(.loaded(self.allTimeslot, self.timeSlotAvailable))
                    }
                    
                    self.displayedTimeslots = timeslots.map { ts in
                        DisplayedTimeslot(
                            timeslot: ts,
                            isAvailable: self.timeSlotAvailable[ts] ?? false
                        )
                    }
                }
            }
        }
        
    }
    
    private func fetchCollabSpaceRecord(record: CollabSpace, completion: @escaping (CKRecord?) -> Void) {
        let recordID = CKRecord.ID(recordName: record.id)
        database.fetch(withRecordID: recordID) { fetchedRecord, error in
            if let error = error {
                completion(nil)
            } else if let fetchedRecord = fetchedRecord, fetchedRecord.recordType == "CollabSpaceRecords" {
                completion(fetchedRecord)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    private func computeTimeSlotAvailability(
        timeslots: [Timeslot],
        completion: @escaping ([Timeslot: Bool]) -> Void
    ) {
        let now = selectedDate
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: now)
        let isWeekend = (weekday == 1 || weekday == 7)

        if isWeekend {
            var availability: [Timeslot: Bool] = [:]
               for timeslot in timeslots {
                   availability[timeslot] = false
               }
               completion(availability)
            return
        }
        
        let currentHour = Double(calendar.component(.hour, from: now))
        let currentMinute = Double(calendar.component(.minute, from: now))
        let currentTimeAsDouble = currentHour + (currentMinute / 60.0)
        
        let startOfDay = calendar.startOfDay(for: selectedDate)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }
        
        fetchCollabSpaceRecord(record: selectedCollabSpace) { collabSpaceRecord in
            guard let collabSpaceRecord = collabSpaceRecord else {
                return
            }
            
            let reference = CKRecord.Reference(record: collabSpaceRecord, action: .none)
            let predicate = NSPredicate(
                format: "CollabSpaceRecordID == %@ AND Date >= %@ AND Date < %@",
                reference,
                startOfDay as CVarArg,
                endOfDay as CVarArg
            )
            
            let query = CKQuery(recordType: "BookingRecords", predicate: predicate)
            self.database.perform(query, inZoneWith: nil) { records, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("CloudKit query error: \(error.localizedDescription)")
                        return
                    }
                    
                    let bookedTimeslotIDs: Set<String> = Set(records?.compactMap {
                        ($0["TimeSlotID"] as? CKRecord.Reference)?.recordID.recordName
                    } ?? [])
                    
                    var availability: [Timeslot: Bool] = [:]
                    for timeslot in timeslots {
                        let isAfterNow = timeslot.endHour > currentTimeAsDouble
                        let isBooked = bookedTimeslotIDs.contains(timeslot.recordName)
                        availability[timeslot] = isAfterNow && !isBooked
                    }
                    completion(availability)
                }
            }
            
        }
    }
    
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


struct DisplayedTimeslot: Identifiable, Hashable {
    let id = UUID()
    let timeslot: Timeslot
    let isAvailable: Bool
}
