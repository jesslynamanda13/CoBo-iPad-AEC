//
//  BookingStatusEnum.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//


import Foundation

enum BookingStatus: String, Codable, Equatable, CaseIterable, Identifiable, Hashable{
    case checkedIn = "Checked In"
    case notCheckedIn = "Not Checked In"
    case closed = "Closed"
    case canceled = "Canceled"
    
    var id: String { self.rawValue }
}

