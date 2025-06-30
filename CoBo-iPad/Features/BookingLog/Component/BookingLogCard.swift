//
//  BookingLogCard.swift
//  CoBo-iPad
//
//  Created by Amanda on 30/06/25.
//

import SwiftUI

struct BookingLogCard: View {
    let booking: Booking

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(booking.meetingName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)
                .padding(.horizontal)

            Divider()
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Place:")
                        .foregroundColor(.gray)
                    Text(booking.collabSpace.name)
                        .fontWeight(.bold)
                }
                HStack {
                    Text("Coordinator:")
                        .foregroundColor(.gray)
                    Text(booking.coordinator.name)
                }
                HStack {
                    Text("Purpose:")
                        .foregroundColor(.gray)
                    Text(booking.purpose.displayName)
                }
                HStack {
                    Text("Timeslot:")
                        .foregroundColor(.gray)
                    Text(booking.timeslot.name)
                        .font(.footnote)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.purple.opacity(0.1))
                        )
                        .foregroundColor(.purple)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding()
    }
}

