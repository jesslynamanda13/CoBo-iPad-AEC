////
////  SiriIntent.swift
////  CoBo-iPad
////
////  Created by Amanda on 22/05/25.
////
//
//import AppIntents
//
//struct SiriIntent: AppIntent {
//    static var title: LocalizedStringResource = "Book a Collaboration Space"
//    
//    @Parameter(title: "Feature")
//    var feature: Feature
//
//    @Parameter(title: "Date")
//    var date: Date
//
//    @Parameter(title: "Time")
//    var time: Date
//
//    static var parameterSummary: some ParameterSummary {
//        Summary("Book a space with \(\.$feature) on \(\.$date) at \(\.$time)")
//    }
//
//    func perform() async throws -> some IntentResult {
//        BookingDataStore.shared.feature = feature
//        BookingDataStore.shared.date = date
//        BookingDataStore.shared.time = time
//        return .result()
//    }
//}
//
//enum Feature: String, AppEnum {
//    case tv
//    case tableWhiteboard
//    case whiteboard
//
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Feature"
//
//    static var caseDisplayRepresentations: [Feature: DisplayRepresentation] = [
//        .tv: "TV",
//        .whiteboard: "Whiteboard",
//        .tableWhiteboard: "Table Whiteboard"
//    ]
//}
