//
//  FilterPredicate.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import SwiftUI
import SwiftData

struct FilterPredicate: Equatable {
    var startDate: Date? = nil
    var endDate: Date? = nil
    var timeslotsPredicate: Set<Timeslot> = []
    var collabSpacePredicate: Set<CollabSpace> = []
    var bookingStatusPredicate: Set<BookingStatus> = []
}
