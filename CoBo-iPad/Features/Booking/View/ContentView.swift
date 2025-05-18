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
    @EnvironmentObject var dataViewModel: DataViewModel
    
    var body: some View {
        BookSpaceView(bookSpaceViewModel: BookSpaceViewModel(), collabSpaceViewModel: CollabSpaceViewModel(selectedDate: Date(), database: dataViewModel.database),
                      userViewModel: UserViewModel(database: dataViewModel.database))
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    ContentView()
}
