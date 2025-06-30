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
    @State private var path = [BookSpaceNavigation]()
    
    @State private var isNavigatingToBookingForm = false
    
    var body: some View {
        NavigationStack(path: $path){
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
                        selectedTimeslot: $selectedTimeslot).frame(minHeight: 700)
                    
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
                                    selectedDate: bookSpaceViewModel.selectedDate,
                                    selectedCollabSpace: unwrappedCollabSpace,
                                    selectedTimeslot: unwrappedTimeslot,
                                    onBookNow: {
                                        // Push to the path
                                        path.append(
                                            BookSpaceNavigation.bookingForm(
                                                selectedDate: bookSpaceViewModel.selectedDate,
                                                collabSpace: unwrappedCollabSpace,
                                                timeslot: unwrappedTimeslot
                                            )
                                        )
                                    }
                                )
                            }
                        }
                    },
                    alignment: .bottom
                ).navigationDestination(for: BookSpaceNavigation.self) { destination in
                    switch destination {
                    case .bookingForm(let date, let space, let slot):
                        BookingFormView(
                            path: $path,
                            selectedDate: date,
                            selectedCollabSpace: space,
                            selectedTimeslot: slot,
                            userVM: userViewModel
                        )
                    case .bookingSummary(let date, let space, let slot, let coordinator, let name, let purpose, let participants):
                        BookingSummaryView(
                            path: $path,
                            selectedDate: date,
                            selectedCollabSpace: space,
                            selectedTimeslot: slot,
                            coordinator: coordinator,
                            meetingName: name,
                            purpose: purpose,
                            participants: participants
                        )
                    case .bookingSuccess(let booking):
                        BookingSuccessView(path: $path, booking: booking)

                    }
                }
        }.navigationBarBackButtonHidden(true)
    }
}



enum BookSpaceNavigation: Hashable {
    case bookingForm(selectedDate: Date, collabSpace: CollabSpace, timeslot: Timeslot)
    case bookingSummary(
        selectedDate: Date,
        collabSpace: CollabSpace,
        timeslot: Timeslot,
        coordinator: User,
        meetingName: String,
        purpose: BookingPurpose,
        participants: [User]
    )
    case bookingSuccess(Booking)
}
