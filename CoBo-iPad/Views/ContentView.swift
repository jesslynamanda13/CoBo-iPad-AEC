//
//  ContentView.swift
//  CoBo-iPad
//
//  Created by Amanda on 30/04/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var databaseVM : DataViewModel
    var body: some View {
        TabView {
            BookSpaceView()
                .environmentObject(databaseVM)
                .tabItem {
                    Label("Book Space", systemImage: "calendar.badge.plus")
                }

            CheckInView()
                .tabItem {
                    Label("Check-In", systemImage: "person.crop.circle.badge.checkmark")
                }

            BookingLogView()
                .tabItem {
                    Label("Booking Log", systemImage: "doc.text.magnifyingglass")
                }
        }
        .accentColor(.purple)
        .tabViewStyle(DefaultTabViewStyle())
    }
}

#Preview {
    ContentView()
}

