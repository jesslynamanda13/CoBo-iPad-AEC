//
//  BookingSuccessView.swift
//  CoBo-iPad
//
//  Created by Amanda on 16/05/25.
//

import SwiftUI


struct BookingSuccessView: View {
    @Binding var path: [BookSpaceNavigation]

    var booking: Booking
    @State private var step = 3
    @EnvironmentObject var dataViewModel: DataViewModel
    @State private var showSummarySheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                VStack {
                    VStack(alignment: .center, spacing: 32) {
                        VStack(spacing: 12) {
                            Image("book-success-icon")
                                .resizable()
                                .frame(maxWidth: 120, maxHeight: 120)
                                .padding(.bottom, 24)

                            Text("Your Booking is Placed!")
                                .font(.title)
                                .fontWeight(.bold)

                        }

                        VStack(spacing: 12) {
                            Text("Save This Check-In Code")
                                .font(.title3)
                                .fontWeight(.bold)
                            CodeDisplayComponent(code: booking.checkInCode ?? "XXXXXX")
                            (
                                Text("When approaching meeting time, check-in is ") +
                                Text("required 15 minutes ").bold() +
                                Text("before the booking starts.")
                            )
                            .multilineTextAlignment(.center)
                            .font(.body)
                            .frame(maxWidth: 390)

                            Text("Late check-in will cause your booking to be canceled.")
                                .multilineTextAlignment(.center)
                                .font(.subheadline)
                                .frame(maxWidth: 380)
                                .padding(.top, 12)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .frame(width: geometry.size.width)
                }
                .frame(maxHeight: .infinity)
                .padding(.top, -64)
            }

            VStack(spacing: 16) {
                ThreeStepProgressBar(currentStep: step)

                HStack(spacing: 32) {
                    Button(action: {
                        showSummarySheet = true
                    }) {
                        Text("See booking summary")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .font(.title3)
                            .padding(.vertical, 18)
                            .foregroundColor(Color.purple)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }.sheet(isPresented: $showSummarySheet) {
                        BookingSummarySheetComponent(booking: booking)
                    }



                    Button(action: {
                        path.removeLast(path.count)
                    }) {
                        Text("Back to home")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .font(.title3)
                            .padding(.vertical, 18)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .cornerRadius(12)
                    }
                    
                }
            }
            .padding()
            .padding(.horizontal, 16)
            .background(Color.white.ignoresSafeArea(edges: .bottom))
        }.navigationBarBackButtonHidden(true).background(DisableBackSwipeGesture())
    }
    
}
