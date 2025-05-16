//
//  UserViewModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 15/05/25.
//

import Foundation
import CloudKit
import SwiftUI

enum UserLoadingState{
    case loading
    case loaded([User])
    case error(NetworkError)
}

class UserViewModel: ObservableObject {
    private let database : CKDatabase
    @Published var users: [User] = []
    @Published private(set) var managerState: UserLoadingState = .loading
    
    init(database: CKDatabase){
        self.database = database
    }
    
    func fetchUsers() {
        print("Database available")
        let query = CKQuery(recordType: "UserRecords", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { results, error in
            guard let records = results else { return }
            do{
                DispatchQueue.main.async {
                    print(records)
                    let usersFetched = records.compactMap { record -> User? in
                        guard
                            let name = record["Name"] as? String,
                            let email = record["Email"] as? String,
                            let roleString = record["Role"] as? String,
                            let role = UserRole(rawValue: roleString)
                        else {
                            return nil
                        }
                        let user = User(name: name, role: role, email: email)
                        print(user.name)
                        return user
                    }
                    self.users = usersFetched
                    self.updateState(.loaded(self.users))
                    print("Users", self.users)
                }
                
            }
            
        }
    }
}

extension UserViewModel{
    private func updateState(_ state: UserLoadingState){
        DispatchQueue.main.async {
            self.managerState = state
        }
    }
}
