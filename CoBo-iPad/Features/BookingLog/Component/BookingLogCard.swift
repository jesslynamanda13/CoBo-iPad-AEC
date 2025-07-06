//
//  BookingLogCard.swift
//  CoBo-iPad
//
//  Created by Amanda on 30/06/25.
//

import SwiftUI

struct BookingLogCard: View {
    let booking: Booking

    private var timeslotRelevance: TimeslotRelevance {
        booking.timeslot.getRelevance(for: booking.date)
    }

    private var timeslotColor: Color {
        switch timeslotRelevance {
        case .now:      return .black
        case .upcoming: return .black
        case .past:     return .gray
        }
    }

    private var timeslotBackgroundColor: Color {
        switch timeslotRelevance {
        case .now:      return Color.yellow.opacity(0.3)
        case .upcoming: return Color.gray.opacity(0.1)
        case .past:     return Color.gray.opacity(0.1)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(booking.meetingName)
                .font(.body)
                .fontWeight(.bold)
                .padding(.bottom, 10)
                .padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) { // Increased spacing slightly
                // Other HStacks for Place, Coordinator, Purpose...
                HStack {
                    Text("Place:")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text(booking.collabSpace.name)
                        .fontWeight(.bold)
                        .font(.footnote)
                }
                HStack {
                    Text("Coordinator:")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text(booking.coordinator.name)
                        .font(.footnote)
                }
                HStack {
                    Text("Purpose:")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text(booking.purpose.displayName)
                        .font(.footnote)
                }
                
                // --- MODIFICATION START ---
                // 2. Apply the dynamic styles to the Timeslot
                HStack {
                    Text("Timeslot:")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text(booking.timeslot.name)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(timeslotColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(timeslotBackgroundColor)
                        .cornerRadius(8)
                }
                // --- MODIFICATION END ---
            }
            .padding(.top, 10)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemBackground)) // Use system background for better dark/light mode support
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
