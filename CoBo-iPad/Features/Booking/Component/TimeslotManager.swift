//
//  TimeslotManager.swift
//  CoBo-iPad
//
//  Created by Amanda on 08/05/25.
//


import SwiftUI
struct TimeslotManager : View{
    // take collab space + date
    // @binding...
    @EnvironmentObject var databaseVM: DataViewModel
    @StateObject private var timeslotVM: TimeslotViewModel = TimeslotViewModel.stub()
    @State private var isInitialized = false
    
    @Binding var selectedDate:Date
    var selectedCollabSpace:CollabSpace
    //
    //    init(selectedDate: Binding<Date>,
    //         selectedCollabSpace: CollabSpace,
    //         databaseVM: DataViewModel) {
    //        _selectedDate = selectedDate
    //        self.selectedCollabSpace = selectedCollabSpace
    //        _timeslotVM = StateObject(wrappedValue: TimeslotViewModel(database: databaseVM.database,selectedDate: $selectedDate, selectedCollabSpace: selectedCollabSpace))
    //    }
    
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
                            isAvailable: timeSlotsAvailability[timeslot] ?? false
                        )
                    }
                }
                
            case .error(let error):
                Text("Error: \(error)")
            }
        }.onAppear{
            if !isInitialized {
                timeslotVM.configure(
                    database: databaseVM.database,
                    selectedDate: selectedDate,
                    selectedCollabSpace: selectedCollabSpace
                )
                timeslotVM.fetchTimeSlot()
                isInitialized = true
            }
        }
        
    }
}
