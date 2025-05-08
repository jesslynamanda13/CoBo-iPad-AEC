////
////  BookingValidator.swift
////  CoBo-iPad
////
////  Created by Amanda on 05/05/25.
////
//
//import Foundation
//final class BookingValidator {
//    static func isBookingValid(newBooking: Booking, existingBookings: [Booking]) -> Bool {
//        guard let newCoordinator = newBooking.coordinator else {
//            return false
//        }
//        
//        let calendar = Calendar.current
//        let timeslotList = DataManager.getTimeslotsData()
//        
//        guard let newIndex = timeslotList.firstIndex(where: { ts in
//            abs(ts.startHour - newBooking.timeslot.startHour) < 0.01 &&
//            abs(ts.endHour - newBooking.timeslot.endHour) < 0.01
//        }) else {
//            return false
//        }
//        
//        for booking in existingBookings {
//            guard let existingCoordinator = booking.coordinator else { continue }
//            
//            let sameCoordinator = existingCoordinator.email == newCoordinator.email
//            let sameDay = calendar.isDate(booking.date, inSameDayAs: newBooking.date)
//            let sameSpace = booking.collabSpace.id == newBooking.collabSpace.id
//            
//            if sameCoordinator && sameDay && sameSpace {
//                guard let existingIndex = timeslotList.firsatIndex(where: { ts in
//                    abs(ts.startHour - booking.timeslot.startHour) < 0.01 &&
//                    abs(ts.endHour - booking.timeslot.endHour) < 0.01
//                }) else { continue }
//                
//                if abs(newIndex - existingIndex) == 1 {
//                    return false
//                }
//            }
//        }
//        
//        return true
//    }
//}
