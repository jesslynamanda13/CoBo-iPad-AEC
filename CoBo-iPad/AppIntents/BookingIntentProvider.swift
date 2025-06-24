//
//  BookingIntentProvider.swift
//  CoBo-iPad
//
//  Created by Amanda on 18/05/25.

import AppIntents

struct AppIntentShortcutProvider: AppShortcutsProvider {

    static var appShortcuts: [AppShortcut] {
        
            AppShortcut(
                intent: BookCollabSpaceIntent(),
                phrases: ["Book a collab space in \(.applicationName)"],
                shortTitle: "Book Collab Space",
                systemImageName: "calendar.badge.plus"
            )

//            AppShortcut(
//                intent: SiriIntent(),
//                phrases: ["Use Siri intent in \(.applicationName)"],
//                shortTitle: "Siri Action",
//                systemImageName: "waveform"
//            )
        
    }
}

