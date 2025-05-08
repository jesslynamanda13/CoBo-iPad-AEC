//
//  CollabspaceManager.swift
//  CoBo-iPad
//
//  Created by Amanda on 06/05/25.
//
import SwiftUI
import CloudKit

struct CollabspaceManager: View {
    let container: CKContainer
    let database: CKDatabase
    
    @State var collabSpaceRecords: [CollabSpace] = []
    
    var cache: NSCache<NSString, CollabSpace> = {
        let cache = NSCache<NSString, CollabSpace>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    init() {
        let container = CKContainer(identifier: "iCloud.CoBoCloud")
        self.container = container
        self.database = container.publicCloudDatabase
    }
    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach($collabSpaceRecords, id: \.self) { space in
                    CollabspaceCard(collabSpace: space)
                }
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            if let cachedSpaces = loadFromCache() {
                collabSpaceRecords = cachedSpaces
                print("Loaded from NSCache.")
            } else {
                print("Cache is empty, fetching from iCloud.")
                fetchCollabRecords()
            }
        }
    }
    
    func cacheRecord(collabSpace: CollabSpace, name: String) {
        cache.setObject(collabSpace, forKey: name as NSString)
    }
    
    func get(name: String) -> CollabSpace? {
        return cache.object(forKey: name as NSString)
    }
    
    func loadFromCache() -> [CollabSpace]? {
        // Attempt to get all cached items by scanning known keys
        // If you don't have a list of known keys, this will only work if you've already loaded and cached them
        let knownKeys = ["A", "B", "C"] // Replace with realistic example names
        let cached = knownKeys.compactMap { key in
            get(name: key)
        }
        return cached.isEmpty ? nil : cached
    }
    
    func fetchCollabRecords() {
        let query = CKQuery(recordType: "CollabSpaceRecords", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print("Error fetching records: \(error)")
                return
            }
            
            guard let records = results else { return }
            
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
                    
                    let imageURLs: [URL] = images.compactMap { $0.fileURL }
                    
                    let space = CollabSpace(
                        name: name,
                        images: imageURLs,
                        capacity: capacity,
                        whiteboardAmount: whiteboard,
                        tableWhiteboardAmount: tableWhiteboard,
                        tvAvailable: tvInt != 0
                    )
                    
                    cacheRecord(collabSpace: space, name: name)
                    return space
                }
                
                collabSpaceRecords = spaces
                print("Fetched and cached \(spaces.count) records from iCloud.")
            }
        }
    }
}
