//
//  CollabspaceViewModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 08/05/25.
//

import CloudKit
import Foundation
import SwiftUI

enum CollabspaceManagerState{
    case loading
    case loaded([CollabSpace])
    case error(NetworkError)
}


class CollabSpaceViewModel : ObservableObject {
    @Published var selectedDate: Date
    private let database: CKDatabase
    var timeslotVMs: [String: TimeslotViewModel] = [:]
    
    @Published private(set) var managerState: CollabspaceManagerState = .loading
    @Published var collabSpaces: [CollabSpace] = []
    
    init(selectedDate: Date, database: CKDatabase) {
        self.selectedDate = selectedDate
        self.database = database
    }
    
    func fetchCollabRecords() {
        print("[CS VM fetch records] Date: ", selectedDate)
        let query = CKQuery(recordType: "CollabSpaceRecords", predicate: NSPredicate(value: true))
        print("about to fetch")
        database.perform(query, inZoneWith: nil) { results, error in
            if error != nil {
                self.updateState(.error(.unknown))
                return
            }
            
            guard let records = results else { return }
            do{
                DispatchQueue.main.async {
                    print("Fetching collab records")
                    let spaces = records.compactMap { record -> CollabSpace? in
                        guard
                            let name = record["Name"] as? String,
                            let capacity = record["Capacity"] as? Int,
                            let images = record["SpaceImages"] as? [CKAsset],
                            let whiteboard = record["WhiteboardAmount"] as? Int,
                            let tableWhiteboard = record["TableWhiteboardAmount"] as? Int,
                            let tvInt = record["TVAvailable"] as? Int
                        else {
                            return nil
                        }
                        let recordName = record.recordID.recordName
                        let imageURLs: [URL] = images.compactMap { $0.fileURL }
                        
                        let space = CollabSpace(
                            recordName: recordName,
                            name: name,
                            images: imageURLs,
                            capacity: capacity,
                            whiteboardAmount: whiteboard,
                            tableWhiteboardAmount: tableWhiteboard,
                            tvAvailable: tvInt != 0
                        )
                        
                        return space
                    }
                    self.collabSpaces = spaces
                    print("Fetched records from iCloud.")
                    self.updateState(.loaded(self.collabSpaces))
                    print("[fetch collab records] State updated")
                }
            }
            
        }
    }
    
    func getTimeslotVM(for space: CollabSpace, database: CKDatabase) -> TimeslotViewModel {
        print(">>> getTimeslotVM")
        if let existingVM = timeslotVMs[space.recordName] {
            return existingVM
        }

        let newVM = TimeslotViewModel(
            selectedCollabSpace: space,
            database: database,
            selectedDatePublisher: $selectedDate
        )
        timeslotVMs[space.recordName] = newVM
        return newVM
    }

    
//    func getTimeslotVM(for space: CollabSpace, database: CKDatabase) -> TimeslotViewModel {
//        print(">>> getTimeslotVM")
//        if let existingVM = timeslotVMs[space.recordName] {
//            if existingVM.selectedDate != selectedDate {
//                // correct
//                print("[getTimeslotVM] Date changed, recreating VM for \(space.name), \(selectedDate)")
//                let newVM = TimeslotViewModel(selectedCollabSpace: space, database: database, selectedDate: $selectedDate)
//                timeslotVMs[space.recordName] = newVM
//                print("Check on VM date", newVM.selectedDate)
//                return newVM
//            }
//            return existingVM
//        }
//
//        let newVM = TimeslotViewModel(selectedCollabSpace: space, database: database, selectedDate:  $selectedDate)
//        timeslotVMs[space.recordName] = newVM
//        return newVM
//    }

}

extension CollabSpaceViewModel{
    private func updateState(_ state: CollabspaceManagerState){
        DispatchQueue.main.async {
            self.managerState = state
        }
    }
}
