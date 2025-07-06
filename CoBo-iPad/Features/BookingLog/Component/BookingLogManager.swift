//
//  BookingLogManager.swift
//  CoBo-iPad
//
//  Created by Amanda on 30/06/25.
//
import SwiftUI

struct BookingLogManager: View {
    @ObservedObject var bookingLogVM: BookingLogViewModel
    @State private var searchText = ""
    
    @State private var selectedBooking: Booking?
    
    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]
    
    private var filteredBookings: [Booking] {
        guard case .loaded(let bookings) = bookingLogVM.managerState else { return [] }
        if searchText.isEmpty {
            return bookings
        } else {
            let lowercasedQuery = searchText.lowercased()
            return bookings.filter { booking in
                booking.meetingName.lowercased().contains(lowercasedQuery) ||
                booking.collabSpace.name.lowercased().contains(lowercasedQuery) ||
                booking.coordinator.name.lowercased().contains(lowercasedQuery) ||
                booking.timeslot.name.lowercased().contains(lowercasedQuery)
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search by Meeting, Place, or Coordinator...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
            
            switch bookingLogVM.managerState {
            case .loading:
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(0..<4) { _ in BookingViewSkeletonCard() }
                    }
                    .padding(24)
                }
            
            case .loaded:
                if filteredBookings.isEmpty {
                    if searchText.isEmpty {
                        VStack(spacing: 16) {
                            Image("no-booking-found")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200)
                            Text("No Booking Found")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            Text("There are no scheduled meetings for this date.")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxHeight: .infinity)
        
                    } else {
                        ContentUnavailableView.search(text: searchText)
                            .frame(maxHeight: .infinity)
                    }
                }else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 24) {
                            ForEach(filteredBookings) { booking in
                                Button(action: {
                                    selectedBooking = booking
                                }) {
                                    BookingLogCard(booking: booking)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(24)
                }

            case .error:
                Text("Failed to load bookings. Please try again.")
                    .frame(maxHeight: .infinity)
            }
        }
        .sheet(item: $selectedBooking) { booking in
            BookingLogDetailView(booking: booking, onDismissRefresh: {
                bookingLogVM.fetchBookingRecords()
            })
        }
        .onAppear {
            bookingLogVM.fetchBookingRecords()
        }
        .onChange(of: bookingLogVM.selectedDate) {
            bookingLogVM.fetchBookingRecords()
        }
    }
}
