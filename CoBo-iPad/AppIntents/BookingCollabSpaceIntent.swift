//
//  BookingCollabSpaceIntent.swift
//  CoBo-iPad
//
//  Created by Amanda on 18/05/25.
//

import SwiftUI
import Foundation
import AppIntents
import CloudKit
struct BookCollabSpaceIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Book Collab Space"
    static var description = IntentDescription("Book Collab Space at ADA with ease.")
    
    @Parameter(title: "Choose booking date")
    var date: Date
    
    @Parameter(title: "Choose your timeslot")
    var timeslot: TimeslotEntity
    
    @Parameter(
        title: "Choose an available collaboration space",
        description: "Only spaces available for your selected date and time will be shown"
    )
    var collabSpace: CollabSpaceEntity
    
    @Parameter(title: "Enter your name")
    var name: String
    
    @Parameter(title: "Choose your booking purpose")
    var purpose: BookingPurposeIntent
    
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let bookingController = BookingController(database: CKContainer(identifier: "iCloud.CoBoCloud").publicCloudDatabase)
        
        let dialog: IntentDialog = try await withCheckedThrowingContinuation { continuation in
            bookingController.insertBookingAsync(
                meetingName: "\(name)'s Meeting",
                coordinator: name,
                purpose: purpose.rawValue,
                date: date,
                timeslotID: timeslot.id,
                collabSpaceID: collabSpace.id
            ) { checkInCode in
                if let code = checkInCode {
                    
                    let timeString = timeslot.content
                    
                    let formattedDate = date.formatted(.dateTime.weekday(.wide).day().month().year())
                    let dialog = IntentDialog("Your booking is placed at \(collabSpace.name), \(formattedDate) at \(timeString). Your check-in code is \(code). When approaching meeting time, check-in is required 15 minutes before the booking starts. Late check-in will result in booking cancellation.")
                    
                    
                    continuation.resume(returning: dialog)
                } else {
                    continuation.resume(returning: IntentDialog("❌ Booking failed. Please try again later."))
                }
            }
        }
        
        return .result(dialog: dialog)
    }
}
