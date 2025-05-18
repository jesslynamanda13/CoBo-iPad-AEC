//
//  BookingSummarySheetComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 17/05/25.
//
import SwiftUI

struct BookingSummarySheetComponent: View {
    var booking: Booking
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 32) {
                    Text("Booking Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(.purple)
                        .cornerRadius(10)
                }
            }
            
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Date").font(.body)
                    Spacer()
                    Text(formatDate(booking.date)).font(.body).fontWeight(.semibold)
                }
                Divider()

                HStack {
                    Text("Time").font(.body)
                    Spacer()
                    Text("\(booking.timeslot.doubleToTime(booking.timeslot.startHour)) - \(booking.timeslot.doubleToTime(booking.timeslot.endHour))")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                Divider()

                HStack {
                    Text("Space").font(.body)
                    Spacer()
                    Text(booking.collabSpace.name).font(.body).fontWeight(.semibold)
                }
                Divider()

                HStack {
                    Text("Coordinator").font(.body)
                    Spacer()
                    Text(booking.coordinator.name).font(.body).fontWeight(.semibold)
                }
                Divider()

                HStack {
                    Text("Meeting Name").font(.body)
                    Spacer()
                    Text(booking.meetingName).font(.body).fontWeight(.semibold)
                }
                Divider()

                HStack {
                    Text("Purpose").font(.body)
                    Spacer()
                    Text(booking.purpose.displayName).font(.body).fontWeight(.semibold)
                }
                Divider()

                HStack(alignment: .center) {
                    Text("Participants").font(.body)
                    Spacer()
                    if booking.participants.isEmpty {
                        Text("No participants selected")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    } else {
                        VStack(alignment: .trailing) {
                            ForEach(booking.participants, id: \.self) { participant in
                                Text(participant.name)
                                    .font(.body)
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                Divider()
            }.padding(.top, 24).frame(maxWidth: 750)

           
        }
        .padding(.horizontal, 48)
        .padding(.vertical, 24)
    }
}
