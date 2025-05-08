//
//  HolidayDate.swift
//  CoBo-iPad
//
//  Created by Amanda on 06/05/25.
//

import SwiftUI

struct HolidayDate: Identifiable, Decodable {
    let id = UUID()
    let holiday_date: String
    let holiday_name: String
    let is_national_holiday: Bool
}

extension HolidayDate {
    var formattedDate: String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: holiday_date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM"
            return outputFormatter.string(from: date)
        }
        return nil
    }
}
