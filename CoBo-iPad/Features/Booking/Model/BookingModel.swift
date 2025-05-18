//
//  BookingModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Booking: Hashable, Identifiable {
    var meetingName: String
    var coordinator: User
    var purpose: BookingPurpose
    var date: Date
    var participants: [User]
    var createdAt: Date
    var timeslot: Timeslot
    var collabSpace: CollabSpace
    var status: BookingStatus
    var checkInCode: String?
    
    
    func getStatus() -> String {
        switch status {
        case .notCheckedIn:
            return "Not checked in yet"
        case .checkedIn:
            return "Checked in"
        case .canceled:
            return "Canceled"
        default:
            return "Unknown"
        }
    }
    
    init(meetingName: String, coordinator: User, purpose: BookingPurpose, date: Date, participants: [User] = [], timeslot: Timeslot, collabSpace: CollabSpace, status: BookingStatus = .notCheckedIn, checkInCode: String = "") {
        self.meetingName = meetingName
        self.coordinator = coordinator
        self.purpose = purpose
        self.date = date
        self.participants = participants
        self.createdAt = .now
        self.timeslot = timeslot
        self.collabSpace = collabSpace
        self.status = status
        self.checkInCode = checkInCode
    }
    
    
}
