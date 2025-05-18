//
//  CollabSpaceIntent.swift
//  CoBo-iPad
//
//  Created by Amanda on 18/05/25.
//
import AppIntents
import CloudKit
import Foundation


struct CollabSpaceEntity: AppEntity {
    typealias ID = String
    typealias DefaultQuery = CollabSpaceQuery

    var id: ID
    var name: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static let typeDisplayRepresentation = TypeDisplayRepresentation("Collaboration Space")
    
    static var defaultQuery = CollabSpaceQuery()
}

struct CollabSpaceQuery: EntityQuery {
    typealias EntityType = CollabSpaceEntity

    func entities(for identifiers: [EntityType.ID]) async throws -> [CollabSpaceEntity] {
        try await fetchAllCollabSpaces()
            .filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [CollabSpaceEntity] {
        try await fetchAllCollabSpaces()
    }

    func entities(matching string: String) async throws -> [CollabSpaceEntity] {
        try await fetchAllCollabSpaces()
            .filter { $0.name.localizedCaseInsensitiveContains(string) }
    }

    
    private func fetchAllCollabSpaces() async throws -> [CollabSpaceEntity] {
        let container = CKContainer(identifier: "iCloud.CoBoCloud")
        let database = container.publicCloudDatabase

        let query = CKQuery(recordType: "CollabSpaceRecords", predicate: NSPredicate(value: true))
        return try await withCheckedThrowingContinuation { continuation in
            database.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                let spaces : [CollabSpaceEntity] = records?.compactMap { record in
                    guard let name = record["Name"] as? String else { return nil }
                    return CollabSpaceEntity(id: record.recordID.recordName, name: name)
                } ?? []
                continuation.resume(returning: spaces)
            }
        }
    }
}
