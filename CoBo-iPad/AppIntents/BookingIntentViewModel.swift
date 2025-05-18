//
//  BookingIntentViewModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 18/05/25.
//

import SwiftUI
class BookingIntentViewModel: ObservableObject {
    @Published var selectedDate: Date?
    @Published var selectedTimeslotID: String?
    @Published var selectedCollabSpaceID: String?
    @Published var name: String = ""
    @Published var purpose: String = ""
    @Published var participants: [String] = []

    func loadLastIntentSelection() {
        let defaults = UserDefaults.standard
        selectedDate = defaults.object(forKey: "lastBookingDate") as? Date
        selectedTimeslotID = defaults.string(forKey: "lastTimeslotID")
        selectedCollabSpaceID = defaults.string(forKey: "lastCollabSpaceID")
        name = defaults.string(forKey: "lastBookingName") ?? ""
        purpose = defaults.string(forKey: "lastPurpose") ?? ""
        participants = defaults.stringArray(forKey: "lastParticipants") ?? []
    }
}

