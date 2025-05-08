//
//  Date+Extension.swift
//  CoBo-iPad
//
//  Created by Amanda on 06/05/25.
//

import Foundation

extension Date{
    static var capitalizedFirstLettersOfWeekdays:[String]{
        let calendar = Calendar.current
        let weekdays = calendar.shortWeekdaySymbols
        
        return weekdays.map{
            weekday in
            guard let firstLetter = weekday.first else {
                return ""
            }
            return String(firstLetter).capitalized
        }
    }
    
    static var fullMonthNames:[String]{
        let dateFormattter = DateFormatter()
        dateFormattter.locale = Locale.current
        
        return (1...12).compactMap{
            month in
            dateFormattter.setLocalizedDateFormatFromTemplate("MMM")
            let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
            return date.map{
                dateFormattter.string(from: $0)
            }
        }
    }
    var startOfMonth:Date{
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var endOfMonth:Date{
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }
    
    var startOfPreviousMonth:Date{
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value:-1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }
    
    var numberOfDaysInMonth : Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
    var sundayBeforeStart:Date{
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        let numberFromPreviousMonth = startOfMonthWeekday - 1
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }
    
    var calendarDisplayDays:[Date]{
        var days:[Date] = []
        // current month days
        for dayOffset in 0..<numberOfDaysInMonth{
            let newDay = Calendar.current.date(byAdding:.day, value: dayOffset, to: startOfMonth)
            days.append(newDay!)
        }
        
        //previous month days
        for dayOffset in 0..<startOfPreviousMonth.numberOfDaysInMonth{
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfPreviousMonth)
            days.append(newDay!)
        }
        return days.filter{
            $0 >= sundayBeforeStart && $0 <= endOfMonth
        }.sorted(by: <)
    }
    var monthInt:Int{
        Calendar.current.component(.month, from: self)
    }
    
    var startOfDay:Date{
        Calendar.current.startOfDay(for: self)
    }
    func isSameDay(as otherDate: Date) -> Bool {
           let calendar = Calendar.current
           return calendar.isDate(self, inSameDayAs: otherDate)
    }
    
    func nextSevenWeekdays() -> [Date] {
            var weekdays: [Date] = []
            var date = self
            let calendar = Calendar.current

            while weekdays.count < 7 {
                let weekday = calendar.component(.weekday, from: date)
                if weekday != 1 && weekday != 7 { // Not Sunday (1) or Saturday (7)
                    weekdays.append(date)
                }
                date = calendar.date(byAdding: .day, value: 1, to: date)!
            }
            return weekdays
        }

}

