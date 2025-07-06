//
//  TimeslotModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import Foundation
import SwiftData


enum TimeslotRelevance: Int, Comparable {
    case now = 0
    case upcoming = 1
    case past = 2
    
    static func < (lhs: TimeslotRelevance, rhs: TimeslotRelevance) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Timeslot: Hashable, Identifiable, Codable
{
    
    @Attribute(.unique) var recordName: String
    var startHour: Double
    var endHour: Double
    
    var id: String { recordName }
    
    init(recordName: String, startHour: Double, endHour: Double) {
        self.recordName = recordName
        self.startHour = startHour
        self.endHour = endHour
    }
    
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
    
    
    func doubleToTime(_ number: Double) -> String {
        let hour = Int(number.rounded(.towardZero))
        let minute = Int(number.truncatingRemainder(dividingBy: 1) * 60)
        
        let stringHour = hour < 10 ? "0\(hour)" : String(hour)
        let stringMinute = minute < 10 ? "0\(minute)" : String(minute)
        
        return "\(stringHour):\(stringMinute)"
    }
    
    func getRelevance(for bookingDate: Date) -> TimeslotRelevance {
        let calendar = Calendar.current
        let now = Date()
        
        let startOfDay = calendar.startOfDay(for: bookingDate)
        guard let startTime = calendar.date(byAdding: .minute, value: Int(self.startHour * 60), to: startOfDay),
              let endTime = calendar.date(byAdding: .minute, value: Int(self.endHour * 60), to: startOfDay) else {
            return .past
        }
        
        if now >= startTime && now <= endTime {
            return .now
        } else if now < startTime {
            return .upcoming
        } else {
            return .past
        }
    }
    static func == (lhs: Timeslot, rhs: Timeslot) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
