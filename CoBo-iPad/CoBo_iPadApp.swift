//
//  CoBo_iPadApp.swift
//  CoBo-iPad
//
//  Created by Amanda on 30/04/25.
//

import SwiftUI
import CloudKit
import SwiftData

@main
struct CoBo_iPadApp: App {
    @StateObject private var databaseVM : DataViewModel = DataViewModel()
    
    var body: some Scene {
        WindowGroup {
            IntroductionView().environmentObject(databaseVM)
        }
    }
}
