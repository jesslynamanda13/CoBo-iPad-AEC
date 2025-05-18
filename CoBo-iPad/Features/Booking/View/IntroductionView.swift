//
//  IntroductionView.swift
//  CoBo-iPad
//
//  Created by Amanda on 18/05/25.
//
import SwiftUI

struct IntroductionView: View {
    @State var navigateToBooking: Bool = false
    @EnvironmentObject var dataViewModel: DataViewModel

    var body: some View {
        ZStack {
            // Main background color
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Image("bg-asset-lines")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 650)
                        .padding(.bottom, 16)
                    Spacer()
                }
            }
            .ignoresSafeArea()
            Circle()
                           .fill(Color.purple.opacity(0.15))
                           .frame(width: 400, height: 400)
                           .blur(radius: 120)

            VStack(spacing: 8) {
                Text("Hello pal! 👋🏻 Welcome to")
                    .font(.headline).fontWeight(.regular)
                Text("CoBo — Collab Space Booking")
                    .font(.title)
                    .fontWeight(.bold)
                Text("CoBo is your go-to solution for reserving Collab Spaces at Apple Developer Academy @ BINUS. It’s time to focus on what truly matters—creating, brainstorming, and meeting with ease.")
                    .font(.subheadline)
                    .frame(maxWidth: 380)
                    .multilineTextAlignment(.center)

                Button(action: {
                    navigateToBooking = true
                }) {
                    Text("Let's get started")
                        .font(.system(.body))
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(24)
                }
                .padding(.top, 24)
                .frame(maxWidth: 380)
                .fullScreenCover(isPresented: $navigateToBooking) {
                    ContentView().environmentObject(dataViewModel)
                }
            }
            .padding()
            .frame(maxWidth: 600, maxHeight: 350)
            .background(Color.white.opacity(0.5))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    IntroductionView()
}
