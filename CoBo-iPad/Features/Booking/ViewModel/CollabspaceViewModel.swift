//
//  CollabspaceViewModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 08/05/25.
//

import CloudKit
import Foundation

enum CollabspaceManagerState{
    case loading
    case loaded([CollabSpace])
    case error(NetworkError)
}

class CollabSpaceViewModel : ObservableObject {
    private let database: CKDatabase
    
    @Published private(set) var managerState: CollabspaceManagerState = .loading
    @Published var collabSpaces: [CollabSpace] = []
    
    init(database: CKDatabase) {
        self.database = database
    }
    
    func fetchCollabRecords() {
        let query = CKQuery(recordType: "CollabSpaceRecords", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { results, error in
            if error != nil {
                self.updateState(.error(.unknown))
                return
            }
            
            guard let records = results else { return }
            do{
                DispatchQueue.main.async {
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
                }
            }
            
        }
    }
    
}

extension CollabSpaceViewModel{
    private func updateState(_ state: CollabspaceManagerState){
        DispatchQueue.main.async {
            self.managerState = state
        }
    }
}
