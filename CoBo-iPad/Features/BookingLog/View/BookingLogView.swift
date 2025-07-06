//
//  BookingLogView.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import SwiftUI

struct BookingLogView:View{
    let screenWidth = UIScreen.main.bounds.width
    
    @EnvironmentObject var dataViewModel: DataViewModel
    @StateObject var bookingLogViewModel: BookingLogViewModel
    @StateObject var userViewModel: UserViewModel
    
    var body: some View{
        NavigationStack{
            VStack {
                ZStack{
                    Image("bg-logs")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 120)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Booking Logs")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Search and find booking logs here.")
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .safeAreaPadding(.all)
                    .padding(.horizontal, 16)
                }
                HStack(alignment: .top, spacing: 32){
                    CalendarComponent(selectedDate: $bookingLogViewModel.selectedDate).frame(maxWidth: 350).padding(.top, 24)
                    BookingLogManager(bookingLogVM: bookingLogViewModel).frame(minHeight: 700)
//                    CollabSpaceManager(
//                        collabSpaceVM: collabSpaceViewModel,
//                        selectedCollabSpace: $selectedCollabSpace,
//                        selectedTimeslot: $selectedTimeslot).frame(minHeight: 700)
                    
                }
                .safeAreaPadding(.all)
                .padding(.horizontal, 16)
            }
            .frame(alignment: .top)
            .onChange(of: bookingLogViewModel.selectedDate) { newDate in
                bookingLogViewModel.selectedDate = newDate
               
            }
            
        }.navigationBarBackButtonHidden(true)
    }
}
