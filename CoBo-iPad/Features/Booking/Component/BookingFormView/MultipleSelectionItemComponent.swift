////
////  MultipleSelectionItemComponent.swift
////  CoBo-iPad
////
////  Created by Amanda on 29/06/25.
////
//import SwiftUI
//
//struct MultipleSelectionItemComponent<T: DropdownProtocol>: View {
//    let item: T
//    let color: Color
//    let onRemove: () -> Void
//    
//    var body: some View {
//        HStack(spacing: 4) {
//            Text(item.dropdownLabel)
//                .font(.body)
//                .foregroundColor(.white)
//            
//            Button(action: onRemove) {
//                Image(systemName: "xmark")
//                    .font(.system(size: 12, weight: .bold))
//                    .foregroundColor(.white)
//            }
//        }
//        .padding(.vertical, 6)
//        .padding(.horizontal, 10)
//        .background(color)
//        .cornerRadius(16)
//    }
//}
//
//struct TagPlacer: Layout {
//    var spacing: CGFloat
//    
//    init(spacing: CGFloat = 8) {
//        self.spacing = spacing
//    }
//    
//    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
//        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
//        
//        var position = CGPoint.zero
//        var maxHeight: CGFloat = 0
//        var rowMaxHeight: CGFloat = 0
//        
//        for (i, size) in sizes.enumerated() {
//            // Check if we need to move to a new row
//            if i > 0 && position.x + size.width > proposal.width ?? .infinity {
//                position.x = 0
//                position.y += rowMaxHeight + spacing
//                rowMaxHeight = 0
//            }
//            
//            // Update position for next item
//            position.x += size.width + spacing
//            rowMaxHeight = max(rowMaxHeight, size.height)
//            maxHeight = max(maxHeight, position.y + size.height)
//        }
//        
//        return CGSize(width: proposal.width ?? .infinity, height: maxHeight)
//    }
//    
//    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
//        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
//        
//        var position = bounds.origin
//        var rowMaxHeight: CGFloat = 0
//        
//        for (i, subview) in subviews.enumerated() {
//            let size = sizes[i]
//            
//            // Check if we need to move to a new row
//            if i > 0 && position.x + size.width > bounds.maxX {
//                position.x = bounds.origin.x
//                position.y += rowMaxHeight + spacing
//                rowMaxHeight = 0
//            }
//            
//            // Place the subview
//            subview.place(at: position, proposal: .unspecified)
//            
//            // Update position for next item
//            position.x += size.width + spacing
//            rowMaxHeight = max(rowMaxHeight, size.height)
//        }
//    }
//}
//
//
//
