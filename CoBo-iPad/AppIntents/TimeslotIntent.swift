//
//  TimeslotIntent.swift
//  CoBo-iPad
//
//  Created by Amanda on 18/05/25.
//

import AppIntents
import CloudKit
import SwiftData
struct TimeslotEntity: AppEntity {
    typealias DefaultQuery = TimeslotQuery
    
    var id: String
    var startHour: Double
    var endHour: Double

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(doubleToTime(startHour)) - \(doubleToTime(endHour))")
    }
    var content:String{
        "\(doubleToTime(startHour)) - \(doubleToTime(endHour))"
    }

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Timeslot"
    
    static var defaultQuery = TimeslotQuery()

    private func doubleToTime(_ number: Double) -> String {
        let hour = Int(number.rounded(.towardZero))
        let minute = Int(number.truncatingRemainder(dividingBy: 1) * 60)

        let stringHour = hour < 10 ? "0\(hour)" : String(hour)
        let stringMinute = minute < 10 ? "0\(minute)" : String(minute)

        return "\(stringHour):\(stringMinute)"
    }
}

struct TimeslotQuery: EntityQuery {
    typealias EntityType = TimeslotEntity

    func entities(for identifiers: [TimeslotEntity.ID]) async throws -> [TimeslotEntity] {
        let allTimeslots = try await TimeslotService.fetchTimeslots()
        return allTimeslots.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [TimeslotEntity] {
        try await TimeslotService.fetchTimeslots()
    }
    
    func entities(matching string: String) async throws -> [TimeslotEntity] {
        let allTimeslots = try await TimeslotService.fetchTimeslots()
        return allTimeslots.filter { timeslot in
            let titleString = String(localized: timeslot.displayRepresentation.title)
            return titleString.localizedCaseInsensitiveContains(string)
        }
    }
}

struct SelectTimeslotIntent: AppIntent {
    static var title: LocalizedStringResource = "Select Timeslot"
    static var description = IntentDescription("Select a timeslot from available options")

    @Parameter(title: "Timeslot")
    var timeslot: TimeslotEntity?

    func perform() async throws -> some IntentResult {
        if let timeslot = timeslot {
            print("Selected timeslot: \(timeslot.displayRepresentation.title)")
            return .result(dialog: "Selected timeslot: \(timeslot.displayRepresentation.title)")
        } else {
            print("No timeslot selected")
            return .result(dialog: "No timeslot selected")
        }
    }
}

// MARK: - CloudKit Fetch Service

class TimeslotService {
    static func fetchTimeslots() async throws -> [TimeslotEntity] {
        let container = CKContainer(identifier: "iCloud.CoBoCloud")
        let database = container.publicCloudDatabase
        let query = CKQuery(recordType: "TimeslotRecords", predicate: NSPredicate(value: true))

        return try await withCheckedThrowingContinuation { continuation in
            database.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                var timeslots = records?.compactMap { record -> TimeslotEntity? in
                    guard
                        let startHour = record["startHour"] as? Double,
                        let endHour = record["endHour"] as? Double
                    else {
                        return nil
                    }
                    return TimeslotEntity(id: record.recordID.recordName, startHour: startHour, endHour: endHour)
                } ?? []
                
                timeslots = self.sortTimeslot(timeslots: timeslots.map(\.self))
                

                continuation.resume(returning: timeslots)
            }
        }
    }
    
    static func sortTimeslot(timeslots:[TimeslotEntity]) -> [TimeslotEntity]{
        let sortedTimeslots = timeslots.sorted { $0.startHour < $1.startHour }
        return sortedTimeslots
    }
}
