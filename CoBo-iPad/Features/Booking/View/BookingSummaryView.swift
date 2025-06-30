//
//  BookingSummaryView.swift
//  CoBo-iPad
//
//  Created by Amanda on 15/05/25.
//

import SwiftUI

struct BookingSummaryView: View {
    @Binding var path: [BookSpaceNavigation]
    var selectedDate: Date
    var selectedCollabSpace: CollabSpace
    var selectedTimeslot: Timeslot
    var coordinator: User
    var meetingName: String
    var purpose: BookingPurpose
    var participants: [User]
    @State private var booking: Booking?
    @State private var step = 2
    @EnvironmentObject var databaseVM : DataViewModel
    
    
    let darkerGrayColor = Color(red: 200/255, green: 200/255, blue: 200/255)
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 12){
                Image("book-summary-icon")
                    .resizable()
                    .frame(maxWidth: 120, maxHeight: 120)
                    .padding(.bottom, 12)
                Text("Review Your Booking").font(.title).fontWeight(.bold)
                Text("Please review your booking before confirming.")
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            VStack(alignment: .center){
                VStack(alignment: .leading, spacing: 32){
                    Text("Booking Summary").font(.title2).fontWeight(.bold)
                    VStack(alignment: .leading, spacing: 24){
                        // date
                        HStack{
                            Text("Date").font(.body)
                            Spacer()
                            Text(formatDate(selectedDate)).font(.body).fontWeight(.semibold)
                        }
                        Divider()
                        HStack{
                            Text("Time").font(.body)
                            Spacer()
                            Text("\(selectedTimeslot.doubleToTime(selectedTimeslot.startHour)) - \(selectedTimeslot.doubleToTime(selectedTimeslot.endHour))").font(.body).fontWeight(.semibold)
                        }
                        Divider()
                        HStack{
                            Text("Space").font(.body)
                            Spacer()
                            Text("\(selectedCollabSpace.name)").font(.body).fontWeight(.semibold)
                        }
                        Divider()
                        HStack{
                            Text("Coordinator").font(.body)
                            Spacer()
                            Text("\(coordinator.name)").font(.body).fontWeight(.semibold)
                        }
                        Divider()
                        HStack{
                            Text("Meeting Name").font(.body)
                            Spacer()
                            Text("\(meetingName)").font(.body).fontWeight(.semibold)
                        }
                        Divider()
                        HStack{
                            Text("Purpose").font(.body)
                            Spacer()
                            Text("\(purpose.displayName)").font(.body).fontWeight(.semibold)
                        }
                        Divider()
                        HStack(alignment: .center) {
                            Text("Participants").font(.body)
                            Spacer()
                            if participants.isEmpty {
                                Text("No participants selected").font(.body).foregroundStyle(.secondary)
                            } else {
                                VStack(alignment: .trailing) {
                                    ForEach(participants, id: \.self) { participant in
                                        Text("\(participant.name)")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        Divider()
                    }.frame(maxWidth: 650)
                    
                    
                }
            }
            
            
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay(
            Group{
                VStack(spacing: 12){
                    ThreeStepProgressBar(currentStep: step)
                    Button(
                        action:{
                            booking = Booking(
                                meetingName: meetingName,
                                coordinator: coordinator,
                                purpose: purpose,
                                date: selectedDate,
                                participants: participants,
                                timeslot: selectedTimeslot,
                                collabSpace: selectedCollabSpace
                            )
                            if let booking = booking {
                                insertBooking(booking: booking);
                                path.append(.bookingSuccess(booking))
                            }
                            
                        }
                    ){
                        Text("Confirm")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .font(.title3)
                            .padding(.vertical, 18)
                            .foregroundColor(.white).background(Color.purple)
                            .cornerRadius(12)
                        
                    }
                    
                }
                .padding()
                .background(Color.white)
                
            },
            alignment: .bottom
        )
        
        .padding(.horizontal, 16)
        .safeAreaPadding(.all)
        .navigationTitle("Booking Confirmation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                EmptyView()
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    func insertBooking(booking: Booking){
        let bookingController = BookingController(database: databaseVM.database)
        bookingController.insertBookingWithReferences(booking: booking)
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: date)
    }
    
    @ViewBuilder
    private var bookingSuccessDestination : some View {
        if let booking = booking {
            BookingSuccessView(path: $path, booking: booking)
        } else {
            EmptyView()
        }
    }

}
