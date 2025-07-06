////
////  BookingConfirmationView.swift
////  CoBo-iPad
////
////  Created by Amanda on 02/07/25.
////
//
//import SwiftUI
//import CoreImage.CIFilterBuiltins
//
//struct BookingConfirmationView: View {
//    @State private var bookingPIN = String(format: "%04d", Int.random(in: 0...9999))
//    @State private var showQRSheet = false
//    @State private var animate = false
//    @State private var repeatCount = 0
//    let maxRepeats = 3
//    
//    
//    var body: some View {
//        VStack(spacing: 24) {
//            Spacer()
//            
//            Image(systemName: "checkmark.circle.fill")
//                .resizable()
//                .frame(width: 100, height: 100)
//                .foregroundColor(.green)
//                .scaleEffect(animate ? 1 : 0.5)
//                .rotationEffect(.degrees(animate ? 0 : -180))
//                .opacity(animate ? 1 : 0)
//                .animation(.spring(response: 0.6, dampingFraction: 0.6)
//                           , value: animate)
//                .onAppear {
//                    startRepeatingAnimation()
//                        }
//            
//            
//            Text("Your booking is placed!")
//                .font(.title2)
//                .fontWeight(.semibold)
//            
//            VStack {
//                Text("This is your booking PIN")
//                    .font(.subheadline)
//                
//                HStack(spacing: 12) {
//                    ForEach(Array(bookingPIN), id: \.self) { char in
//                        Text(String(char))
//                            .font(.title2)
//                            .frame(width: 40, height: 50)
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                    }
//                }
//            }
//            
//            VStack(spacing: 8) {
//                Text("Remember and save this PIN if you wish to reschedule or cancel your booking").bold().font(.footnote)
//                
////                Text("Late check-in will cause your booking to be canceled.")
////                    .font(.footnote)
////                    .foregroundColor(.gray)
//            }
//            .multilineTextAlignment(.center)
//            
//            Spacer()
//            
//            HStack(spacing: 16) {
//                Button {
//                    showQRSheet = true // langsung arahkan ke QRSheetView
//                } label: {
//                    Text("See booking information")
//                        .font(.subheadline)
//                        .foregroundColor(.purple)
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(12)
//                        .overlay(RoundedRectangle(cornerRadius: 12)
//                            .stroke(Color.purple, lineWidth: 1))
//                }
//                
//                Button(action: {
//                    // Dummy action
//                }) {
//                    Text("Back to homepage")
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.purple)
//                        .cornerRadius(12)
//                }
//            }
//            
//            .padding(.horizontal)
//        }
//        .padding()
//        .sheet(isPresented: $showQRSheet) {
//            QRSheetView()
//                .presentationDetents([.large]) // Optional, bisa diatur sesuai tinggi
//        }
//    }
//    
//    func startRepeatingAnimation() {
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//                animate.toggle()
//                repeatCount += 1
//                if repeatCount >= maxRepeats * 2 {
//                    timer.invalidate()
//                    animate = true // set final state
//                }
//            }
//        }
//        
//}
//
//struct QRSheetView: View {
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            // Header
//            ZStack {
//                    Text("Booking Information")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity)
//                    
//                    HStack {
//                        Spacer()
//                        Button("Done") {
//                            dismiss()
//                        }
//                        .foregroundColor(.blue)
//                    }
//                }
//            
//            Spacer()
//            VStack(spacing: 24) {
//                InfoRow(label: "Date", value: "Today, 22 May 2025")
//                InfoRow(label: "Time", value: "09:25 - 10:35")
//                InfoRow(label: "Space", value: "Collab - 02")
//                InfoRow(label: "Coordinator", value: "Jesslyn Amanda Mulyawan")
//                InfoRow(label: "Meeting Name", value: "Jesslyn Amanda Mulyawan’s Group Meeting")
//                InfoRow(label: "Purpose", value: "Personal Mentoring")
//                InfoRow(label: "Participants", value: "Wiwi Oktriani")
//            }
//            
//            
//            VStack(){
//                Text("Add this booking to iCal")
//                    .font(.headline)
//                    .multilineTextAlignment(.center)
//                
//                Text("Scan this QR code to automatically create event in your iCal and get reminders.")
//                    .font(.footnote)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//                
//                Image("QR-contoh") // Replace with your asset name
//                    .resizable()
//                    .interpolation(.none)
//                    .scaledToFit()
//                    .frame(width: 150, height: 150)
//                    .padding()
//            }
//            
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//
//
//#Preview {
//    BookingConfirmationView()
//}
