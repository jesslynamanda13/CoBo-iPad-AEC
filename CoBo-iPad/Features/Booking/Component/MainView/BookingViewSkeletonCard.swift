//
//  BookingViewSkeletonCard.swift
//  CoBo-iPad
//
//  Created by Amanda on 08/05/25.
//

import SwiftUI

struct BookingViewSkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 14.4) {
                SkeletonView(RoundedRectangle(cornerRadius: 6))
                    .frame(width: 195.6, height: 204, alignment: .leading)
                    .clipped()
                    .clipShape(TopLeftRoundedShape())
                    .padding(.leading, -18)
                    .padding(.top, -96)

                VStack(alignment: .leading, spacing: 14.4) {
                    SkeletonView(RoundedRectangle(cornerRadius: 6))
                        .frame(width: 132, height: 24)

                    HStack(alignment: .top, spacing: 9.6) {
                        VStack(alignment: .leading, spacing: 7.2) {
                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                .frame(width: 60, height: 12)

                            HStack(spacing: 7.2) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        SkeletonView(RoundedRectangle(cornerRadius: 6))
                                            .frame(width: 26.4, height: 12)
                                        SkeletonView(RoundedRectangle(cornerRadius: 6))
                                            .frame(width: 26.4, height: 12)
                                    }

                                    HStack {
                                        SkeletonView(RoundedRectangle(cornerRadius: 6))
                                            .frame(width: 26.4, height: 12)
                                            .offset(y: -12)

                                        VStack {
                                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                                .frame(width: 26.4, height: 12)
                                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                                .frame(width: 26.4, height: 12)
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 7.2) {
                            SkeletonView(RoundedRectangle(cornerRadius: 6))
                                .frame(width: 60, height: 12)

                            HStack(spacing: 7.2) {
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 26.4, height: 12)
                                SkeletonView(RoundedRectangle(cornerRadius: 6))
                                    .frame(width: 26.4, height: 12)
                            }
                        }
                    }
                }
            }

            Divider()
                .offset(y: -9.6)

            VStack(alignment: .leading, spacing: 14.4) {
                SkeletonView(RoundedRectangle(cornerRadius: 12))
                    .frame(width: 144, height: 18)

                HStack {
                    ForEach(0..<3) { _ in
                        SkeletonView(RoundedRectangle(cornerRadius: 12))
                            .frame(width: 111.6, height: 43.2)
                    }
                }

                HStack {
                    ForEach(0..<3) { _ in
                        SkeletonView(RoundedRectangle(cornerRadius: 12))
                            .frame(width: 111.6, height: 43.2)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
        .redacted(reason: .placeholder)
    }
}


struct SkeletonView<S: Shape>: View {
    var shape: S
    var color: Color
    init(_ shape: S, _ color: Color = .gray.opacity(0.3)){
        self.shape = shape
        self.color = color
    }
    @State private var isAnimating: Bool = false
    var body: some View {
        shape
            .fill(color)
            .overlay{
                GeometryReader{
                    let size = $0.size
                    let skeletonWidth = size.width / 2
                    let blurRadius = max(skeletonWidth / 2, 30)
                    let blurDiameter = blurRadius * 2
                    let minX = -(skeletonWidth + blurDiameter)
                    let maxX = size.width + skeletonWidth + blurDiameter
                    
                    Rectangle()
                        .frame(width: skeletonWidth, height: size.height * 2)
                        .frame(height: size.height)
                        .blur(radius: blurRadius)
                        .rotationEffect(.init(degrees: rotation))
                        .blendMode(.softLight)
                        .offset(x: isAnimating  ? maxX: minX)
                }
            }
            .clipShape(shape)
            .compositingGroup()
            .onAppear {
                guard !isAnimating else { return }
                withAnimation(animation){
                    isAnimating = true
                }
            }
            .onDisappear {
                isAnimating = false
            }
            .transaction{
                if $0.animation != animation {
                    $0.animation = .none
                }
            }
    }
  
    var rotation: Double{
        return 5
    }
    var animation: Animation{
        .easeInOut(duration: 0.5
        ) .repeatForever(autoreverses: false)
    }
}


