//
//  BookSpaceView.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//
import SwiftUI
import CloudKit
struct BookSpaceView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    @EnvironmentObject var dataViewModel: DataViewModel
    @StateObject var bookSpaceViewModel: BookSpaceViewModel
    @StateObject var collabSpaceViewModel: CollabSpaceViewModel
    @StateObject var userViewModel: UserViewModel
    
    @State var selectedCollabSpace: CollabSpace?
    @State var selectedTimeslot : Timeslot?
    
    @State private var isNavigatingToBookingForm = false
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack{
                    Image("bg-bookspace")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 120)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Book Collab Space")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Find and book Collab Space that fits your needs and availability.")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .safeAreaPadding(.all)
                    .padding(.horizontal, 16)
                }
                HStack(alignment: .top, spacing: 32){
                    CalendarComponent(selectedDate: $bookSpaceViewModel.selectedDate).frame(maxWidth: 350).padding(.top, 24)
                    CollabSpaceManager(
                        collabSpaceVM: collabSpaceViewModel,
                        selectedCollabSpace: $selectedCollabSpace,
                        selectedTimeslot: $selectedTimeslot).frame(minHeight: 600)
                    
                }
                .safeAreaPadding(.all)
                .padding(.horizontal, 16)
            }
            .frame(alignment: .top)
            .onChange(of: bookSpaceViewModel.selectedDate) { newDate in
                collabSpaceViewModel.selectedDate = newDate
                selectedTimeslot = nil
                selectedCollabSpace = nil
            }
            .onDisappear(){
                selectedTimeslot = nil
                selectedCollabSpace = nil
            }
            .overlay(
                Group {
                    if let unwrappedCollabSpace = selectedCollabSpace,
                       let unwrappedTimeslot = selectedTimeslot {
                        VStack {
                            PopupComponent(
                                selectedDate: $bookSpaceViewModel.selectedDate,
                                selectedCollabSpace: Binding<CollabSpace>(
                                    get: { unwrappedCollabSpace },
                                    set: { self.selectedCollabSpace = $0 }
                                ),
                                selectedTimeslot: Binding<Timeslot>(
                                    get: { unwrappedTimeslot },
                                    set: { self.selectedTimeslot = $0 }
                                ),
                                onBookNow: {
                                    isNavigatingToBookingForm = true
                                }
                            )
                            
                            NavigationLink(
                                destination:NavigationStack {BookingFormView(
                                    selectedDate: bookSpaceViewModel.selectedDate,
                                    selectedCollabSpace: unwrappedCollabSpace,
                                    selectedTimeslot: unwrappedTimeslot,
                                    userVM: userViewModel
                                )
                                },
                                    
                                isActive: $isNavigatingToBookingForm,
                                label: { EmptyView() }
                            )
                            .hidden()
                        }
                    }
                },
                alignment: .bottom
            )
            
            
        }
        
        
    }
}

