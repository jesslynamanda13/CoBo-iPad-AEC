//
//  TimeslotModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import Foundation
import SwiftData

@Model
class Timeslot: Hashable {
    var name: String{
        get {
            return "\(doubleToTime(startHour)) - \(doubleToTime(endHour))"
        }
    }
    
    var startCheckIn: String {
        get {
            return doubleToTime(self.startHour - 0.25)
        }
    }
    
    var endCheckIn: String {
        get {
            return doubleToTime(self.startHour + 0.25)
        }
    }
    
    var startHour: Double
    var endHour: Double
    
    init(startHour: Double, endHour: Double) {
        self.startHour = startHour
        self.endHour = endHour
    }
    
    func doubleToTime(_ number: Double) -> String {
        let hour = Int(number.rounded(.towardZero))
        let minute = Int(number.truncatingRemainder(dividingBy: 1) * 60)
        
        let stringHour = hour < 10 ? "0\(hour)" : String(hour)
        let stringMinute = minute < 10 ? "0\(minute)" : String(minute)
        
        return "\(stringHour):\(stringMinute)"
    }
    
}
