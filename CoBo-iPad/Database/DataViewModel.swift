//
//  DataViewModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 08/05/25.
//

import CloudKit
import SwiftUI

class DataViewModel: ObservableObject {
    let container: CKContainer
    let database: CKDatabase

    init() {
        self.container = CKContainer(identifier: "iCloud.CoBoCloud")
        self.database = container.publicCloudDatabase
    }
}
