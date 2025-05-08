//
//  Settings.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import Foundation
import SwiftData

@Model
class Settings {
    var checkInTolerance: Int
    var validBookInAdvance: Int
    var adminSecretKey: String
    
    init(checkInTolerance: Int = 15, validBookInAdvance: Int = 7) {
        self.checkInTolerance = checkInTolerance
        self.validBookInAdvance = validBookInAdvance
        self.adminSecretKey = "MYYHC33XJBLVE3RYKU4UG4LZGRZXK42M"
    }
}
