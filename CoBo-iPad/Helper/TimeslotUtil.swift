//
//  TimeslotUtil.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import Foundation

public struct TimeslotUtil {
    static func doubleToTimeString(_ number: Double) -> String {
        let hour = Int(number.rounded(.towardZero))
        let minute = Int(number.truncatingRemainder(dividingBy: 1) * 60)
        
        let stringHour = hour < 10 ? "0\(hour)" : String(hour)
        let stringMinute = minute < 10 ? "0\(minute)" : String(minute)
        
        return "\(stringHour):\(stringMinute)"
    }
    
    static func getStartCheckInTime(timeslot: Timeslot, tolerance: Int) -> String{
        return doubleToTimeString(timeslot.startHour - (Double(tolerance) / 60.0))
    }
    
    static func getEndCheckInTime(timeslot: Timeslot, tolerance: Int) -> String{
        return doubleToTimeString(timeslot.startHour + (Double(tolerance) / 60.0))
    }
}
