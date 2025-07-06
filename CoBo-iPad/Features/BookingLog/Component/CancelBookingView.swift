//
//  CancelBookingView.swift
//  CoBo-iPad
//
//  Created by Amanda on 02/07/25.
//
import SwiftUI
import CloudKit

struct CancelBookingView: View {
    // These are provided by the parent view
    let booking: Booking
    let bookingController: BookingController
    var onCancellationSuccess: () -> Void
    
    @State private var enteredCode: String = ""
    @State private var isCancelling = false
    @State private var errorMessage: String?
    @State private var showAlert = false
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Confirm Cancellation")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("To cancel this meeting, please enter the 4-digit check-in code provided during booking.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            TextField("4-Digit Check-In Code", text: $enteredCode)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 250)
                .disabled(isCancelling)

            HStack(spacing: 16) {
                Button("Go Back") { dismiss() }
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                    .disabled(isCancelling)

                Button(action: handleCancellation) {
                    if isCancelling {
                        ProgressView()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    } else {
                        Text("Confirm Cancellation")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .disabled(isCancelling || enteredCode.count != 4)
            }
        }
        // The .onAppear block is no longer needed here
        .padding(32)
        .presentationDetents([.height(350)])
        .alert("Cancellation Failed", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(errorMessage ?? "An unexpected error occurred.")
        }
    }
    
    private func handleCancellation() {
        isCancelling = true
        bookingController.cancelBooking(booking: booking, enteredCode: enteredCode) { result in
            isCancelling = false
            switch result {
            case .success:
                onCancellationSuccess()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
}
