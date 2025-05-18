//
//  ThreeStepProgressBar.swift
//  CoBo-iPad
//
//  Created by Amanda on 15/05/25.
//

import SwiftUI

struct ThreeStepProgressBar: View {
    var currentStep: Int
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...3, id: \.self) { step in
                Rectangle()
                    .foregroundColor(step <= currentStep ? .yellow : Color.gray.opacity(0.1))
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 8)
        .cornerRadius(4)
        .animation(.easeInOut, value: currentStep)
    }
}
