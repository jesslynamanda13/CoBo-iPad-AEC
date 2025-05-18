//
//  BookingEnums.swift
//  CoBo-iPad
//
//  Created by Amanda on 18/05/25.
//

import AppIntents

// MARK: - Purpose
enum BookingPurposeIntent: String, AppEnum {
    case groupDiscussion = "Group Discussion"
    case personalMentoring = "Personal Mentoring"
    case meeting = "Meeting"

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Booking Purpose"
    }

    static var caseDisplayRepresentations: [BookingPurposeIntent : DisplayRepresentation] {
        [
            .groupDiscussion: "Group Discussion",
            .personalMentoring: "Personal Mentoring",
            .meeting: "Meeting"
        ]
    }
}
