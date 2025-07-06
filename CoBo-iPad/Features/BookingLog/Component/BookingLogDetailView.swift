//
//  BookingLogDetailView.swift
//  CoBo-iPad
//
//  Created by Amanda on 02/07/25.
//

import SwiftUI

struct BookingLogDetailView: View {
    let booking: Booking
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var databaseVM: DataViewModel
    var onDismissRefresh: () -> Void

    @State private var isShowingCancelModal = false

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 24) {
                        bookingInfoSection
                        cancelButton
                    }
                    .padding(32)
                }
                .navigationTitle(booking.meetingName)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
            }

            if isShowingCancelModal {
                modalOverlay
            }
        }
        .animation(.easeInOut, value: isShowingCancelModal)
    }

    // MARK: - Components

    private var bookingInfoSection: some View {
        Group {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Date").font(.body)
                    Spacer()
                    Text(booking.date.formatted(date: .long, time: .omitted)).font(.body).fontWeight(.semibold)
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
                        Text("No participants")
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
    }


    private var cancelButton: some View {
        Button(role: .destructive) {
            isShowingCancelModal = true
        } label: {
            Text("Cancel Meeting")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.15))
                .foregroundColor(.red)
                .cornerRadius(12)
        }
    }

    private var modalOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isShowingCancelModal = false
                }

            CancelBookingView(
                booking: booking,
                bookingController: BookingController(database: databaseVM.database),
                onCancellationSuccess: {
                    isShowingCancelModal = false
                    dismiss()
                    onDismissRefresh()
                }
            )
            .padding()
            .frame(maxWidth: 400)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .zIndex(1)
        }
    }
}
