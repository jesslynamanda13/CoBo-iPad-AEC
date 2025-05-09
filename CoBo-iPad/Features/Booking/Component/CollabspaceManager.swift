//
//  CollabspaceManager.swift
//  CoBo-iPad
//
//  Created by Amanda on 06/05/25.
//

import SwiftUI
import CloudKit

struct CollabSpaceManager: View {
    @Binding var selectedDate: Date
    @EnvironmentObject var databaseVM: DataViewModel
    @StateObject private var collabSpaceVM: CollabSpaceViewModel
    
    init(selectedDate: Binding<Date>, databaseVM: DataViewModel) {
        _selectedDate = selectedDate 
        _collabSpaceVM = StateObject(wrappedValue: CollabSpaceViewModel(database: databaseVM.database))
    }
    
    @State var collabSpaceRecords: [CollabSpace] = []
    
    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]
    
    var body: some View {
        VStack{
            switch collabSpaceVM.managerState{
            case .loading:
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(0..<4) { _ in
                            BookingViewSkeletonCard()
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                }
                
            case .loaded(let collabSpaces):
                ScrollView{
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(collabSpaces, id: \.self) { space in
                            CollabspaceCard(selectedDate: $selectedDate, collabSpace: space).environmentObject(databaseVM)
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                }
                
            case .error(let error):
                Text("Error")
                
            }
            
        }
        .onAppear {
            collabSpaceVM.fetchCollabRecords()
        }
        
        
    }
}

