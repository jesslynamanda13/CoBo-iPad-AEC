//
//  ImageCarouselComponent.swift
//  CoBo-iPad
//
//  Created by Amanda on 06/05/25.
//

import SwiftUI
import UIKit

struct ImageCarouselComponent: View {
    let screenWidth = UIScreen.main.bounds.width
    @State private var currentIndex = 0
    var images: [URL]
    var locationUIImage : UIImage
    var collabSpaceName : String
    @State private var showingSheet = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Image carousel with dots
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    ZStack(alignment: .bottom) {
                        if let data = try? Data(contentsOf: images[index]),
                           let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: screenWidth * 0.3, maxHeight: screenWidth * 0.1)
                                .clipped()
                                .clipShape(TopLeftRoundedShape())
                                .tag(index)
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(0..<images.count, id: \.self) { dot in
                                Circle()
                                    .fill(dot == currentIndex ? Color.purple : Color.gray.opacity(0.5))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.bottom, 12)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: screenWidth * 0.1)
            
            Button(action: {
                showingSheet = true
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "map")
                        .font(.caption2)
                    Text("See Location")
                        .font(.caption)
                }
                .padding(8)
                .background(Color.white)
                .foregroundColor(Color.black)
                .cornerRadius(8)
            }
            .padding([.top, .trailing], 8)
            .sheet(isPresented: $showingSheet) {
                CollabSpaceLocationSheet(locationImage: locationUIImage, collabSpaceName: collabSpaceName)
            }

        }
    }
}
