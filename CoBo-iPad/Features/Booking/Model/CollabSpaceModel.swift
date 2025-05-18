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
    @Attribute(.unique) var recordName: String
    var name: String
    var images: [URL]
    var locationImage:URL?
    var capacity: Int
    var whiteboardAmount: Int
    var tableWhiteboardAmount: Int
    var tvAvailable: Bool
    
    var id: String { recordName }
    
    init(recordName: String, name: String, images: [URL], locationImage: URL?, capacity: Int, whiteboardAmount: Int, tableWhiteboardAmount: Int, tvAvailable: Bool) {
        self.recordName = recordName
        self.name = name
        self.images = images
        self.locationImage = locationImage
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
    
    var locationUIImage: UIImage? {
        guard
            let url = locationImage,
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
        else {
            return nil
        }
        return image
    }

    
    static func == (lhs: CollabSpace, rhs: CollabSpace) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
}
