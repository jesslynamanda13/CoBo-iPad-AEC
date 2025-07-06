//
//  BookingSuccessView.swift
//  CoBo-iPad
//
//  Created by Amanda on 16/05/25.
//

import SwiftUI


struct BookingSuccessView: View {
    @Binding var path: [BookSpaceNavigation]
    @State private var animate = false
    @State private var repeatCount = 0
    let maxRepeats = 3
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
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.green)
                                .scaleEffect(animate ? 1 : 0.5)
                                .rotationEffect(.degrees(animate ? 0 : -180))
                                .opacity(animate ? 1 : 0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6)
                                           , value: animate)
                                .onAppear {
                                    startRepeatingAnimation()
                                        }
                            Text("Your Booking is Placed!")
                                .font(.title)
                                .fontWeight(.bold)

                        }

                        VStack(spacing: 12) {
                            Text("This is your booking PIN")
                                .font(.title3)
                                .fontWeight(.bold)
                            CodeDisplayComponent(code: booking.checkInCode ?? "XXXXXX")
                            (
                                Text("Remember and save this PIN if you wish to reschedule or cancel your booking").bold()
                            )
                            .multilineTextAlignment(.center)
                            .font(.body)
                            .frame(maxWidth: 390)

                           
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
    func startRepeatingAnimation() {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                animate.toggle()
                repeatCount += 1
                if repeatCount >= maxRepeats * 2 {
                    timer.invalidate()
                    animate = true // set final state
                }
            }
        }
    
}
