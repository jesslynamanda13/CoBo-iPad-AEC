//
//  QRCode.swift
//  Project 1 Apple
//
//  Created by Rieno on 25/03/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

func generateQRCodeFromBooking(_ booking: Booking) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    let calendar = Calendar.current
    
    let startOfDay = calendar.startOfDay(for: booking.date)
    guard let startDate = calendar.date(byAdding: .minute, value: Int(booking.timeslot.startHour * 60), to: startOfDay),
          let endDate = calendar.date(byAdding: .minute, value: Int(booking.timeslot.endHour * 60), to: startOfDay) else {
        return ""
    }

    let startDateStr = dateFormatter.string(from: startDate)
    let endDateStr = dateFormatter.string(from: endDate)

    let meetingName = booking.meetingName
    let meetingDescription = "Code to cancel meeting: \(booking.checkInCode ?? "N/A"). Be present at \(booking.collabSpace.name)."
    let organizerName = booking.coordinator.name
    let organizerEmail = booking.coordinator.email

    let attendees = booking.participants.map { participant in
        "ATTENDEE;CN=\(participant.name):mailto:\(participant.email)"
    }.joined(separator: "\n")

    return """
    BEGIN:VCALENDAR
    VERSION:2.0
    PRODID:-//CoBo//Booking App//EN
    BEGIN:VEVENT
    UID:\(UUID().uuidString)
    DTSTAMP:\(startDateStr)
    DTSTART:\(startDateStr)
    DTEND:\(endDateStr)
    SUMMARY:\(meetingName)
    DESCRIPTION:\(meetingDescription)
    ORGANIZER;CN=\(organizerName):mailto:\(organizerEmail)
    \(attendees)
    LOCATION:\(booking.collabSpace.name)
    BEGIN:VALARM
    ACTION:DISPLAY
    DESCRIPTION:Reminder for \(meetingName)
    DESCRIPTION:Reminder for \(meetingName)
    TRIGGER:-PT15M
    END:VALARM
    END:VEVENT
    END:VCALENDAR
    """
}

func generateQRCode(from string: String) -> Image? {
    let data = string.data(using: .utf8)
    let filter = CIFilter.qrCodeGenerator()
    filter.setValue(data, forKey: "inputMessage")
    filter.setValue("M", forKey: "inputCorrectionLevel")
    
    let context = CIContext()
    
    if let outputImage = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 10, y: 10)),
       let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
        return Image(decorative: cgImage, scale: 1.0)
    }
    
    print("Failed to generate QR Code")
    return nil
}
