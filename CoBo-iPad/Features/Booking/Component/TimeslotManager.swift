//
//  TimeslotManager.swift
//  CoBo-iPad
//
//  Created by Amanda on 08/05/25.
//


import SwiftUI
struct TimeslotManager : View{
    @ObservedObject var timeslotVM: TimeslotViewModel
    @EnvironmentObject var databaseVM: DataViewModel
    var collabSpace: CollabSpace
    @Binding var selectedCollabSpace : CollabSpace?
    @Binding var selectedTimeslot : Timeslot?

    let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]
    
    var body: some View {
        VStack{
            switch timeslotVM.managerState{
            case .loading:
                Text("Loading...").padding(.top, 12)
                
            case .loaded(let timeslots, let timeSlotsAvailability):
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(timeslots, id: \.self) { timeslot in
                        TimeslotComponent(
                            timeslot: timeslot,
                            isAvailable: true,
//                            isAvailable: timeSlotsAvailability[timeslot] ?? false,
                            isSelected: selectedTimeslot == timeslot,
                            collabSpace: collabSpace,
                            selectedCollabSpace: selectedCollabSpace
                        ).onTapGesture {
                            if(selectedTimeslot == timeslot && selectedCollabSpace == collabSpace){
                                selectedTimeslot = nil
                                selectedCollabSpace = nil
                            }
                            selectedTimeslot = timeslot
                            selectedCollabSpace = collabSpace
                            
                        }
                    }
                }
                
            case .error(let error):
                Text("Error: \(error)")
            }
        }
        .onAppear{
            timeslotVM.fetchTimeSlot()
        }
        .onChange(of: timeslotVM.id) { _ in
            timeslotVM.fetchTimeSlot()
        }

        
    }
}
