//
//  CollabSpaceModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//


import Foundation
import SwiftData
import UIKit

class CollabSpace : Hashable, Identifiable, Codable {
    var id = UUID()
    var name: String
    var images: [URL]
    var capacity: Int
    var whiteboardAmount: Int
    var tableWhiteboardAmount: Int
    var tvAvailable: Bool
    
    init(id: UUID = UUID(), name: String, images: [URL], capacity: Int, whiteboardAmount: Int, tableWhiteboardAmount: Int, tvAvailable: Bool) {
        self.id = id
        self.name = name
        self.images = images
        self.capacity = capacity
        self.whiteboardAmount = whiteboardAmount
        self.tableWhiteboardAmount = tableWhiteboardAmount
        self.tvAvailable = tvAvailable
    }
    
    
    var uiImages: [UIImage] {
        images.compactMap { url in
            guard let data = try? Data(contentsOf: url) else { return nil }
            return UIImage(data: data)
        }
    }
    
    static func == (lhs: CollabSpace, rhs: CollabSpace) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
}
