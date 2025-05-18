//
//  CollabspaceManager.swift
//  CoBo-iPad
//
//  Created by Amanda on 06/05/25.
//

import SwiftUI
import CloudKit

struct CollabSpaceManager: View {
    @StateObject var collabSpaceVM: CollabSpaceViewModel
    @Binding var selectedCollabSpace: CollabSpace?
    @Binding var selectedTimeslot : Timeslot?

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
                            CollabspaceCard(collabSpaceVM: collabSpaceVM, collabSpace: space, selectedCollabSpace: $selectedCollabSpace, selectedTimeslot: $selectedTimeslot, selectedDate: $collabSpaceVM.selectedDate)
                        }
                    }
                    .padding(24)
                    .padding(.bottom, 80)
                    .frame(maxWidth: .infinity)
                }
                
            case .error(let error):
                Text("Error")
                
            }
            
        }
        .onAppear {
            collabSpaceVM.fetchCollabRecords()
        }
        .onChange(of: collabSpaceVM.selectedDate) { newDate in
            collabSpaceVM.fetchCollabRecords()
        }
        
    }
}

