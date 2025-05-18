//
//  CodeDisplayComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 16/05/25.
//

import SwiftUI
struct CodeDisplayComponent: View {
    var code: String

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {
                ForEach(Array(code), id: \.self) { digit in
                    Text(String(digit))
                        .frame(width: 45, height: 60)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
}
