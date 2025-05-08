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
    init() {
//        addRecords()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
//    func addRecords(){
//        let container = CKContainer(identifier: "iCloud.CoBoCloud")
//        let database = container.publicCloudDatabase
//        
//        let record = CKRecord(recordType: "UserRecords")
//        record.setValuesForKeys([
//            "Name": "Amanda 1",
//            "Email": "jm@gmail.com",
//            "Role": "learner"
//        ])
//        
//        database.save(record) { record, error in
//            if let error = error {
//                // Handle error.
//                print("Data is not saved")
//                return
//            }
//            print("Record saved")
//        }
//    }

    
}
