//
//  CollabSpaceLocationSheet.swift
//  CoBo-iPad
//
//  Created by Amanda on 18/05/25.
//

import SwiftUI
struct CollabSpaceLocationSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var locationImage: UIImage
    var collabSpaceName: String
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: locationImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 550)
            }
            .navigationBarTitle("\(collabSpaceName) Location", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
//        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
    }
}
