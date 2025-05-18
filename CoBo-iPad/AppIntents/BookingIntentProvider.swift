//
//  BookingIntentProvider.swift
//  CoBo-iPad
//
//  Created by Amanda on 18/05/25.
//

import AppIntents
struct AppIntentShortcutProvider: AppShortcutsProvider {

    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: BookCollabSpaceIntent(),
            phrases: ["Book collab space in \(.applicationName)"],
            shortTitle: "Book Collab Space",
            systemImageName: "calendar.badge.plus"
        )
    }
}
