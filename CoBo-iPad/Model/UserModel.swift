//
//  UserModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import Foundation
import SwiftData

@Model
class User: DropdownProtocol{
    var name: String
    var role: UserRole
    var email: String
    
    func getRole() -> String {
        switch role {
            case .learner:
                return "Learner"
            case .mentor:
                return "Mentor"
            case .admin:
                return "Admin"
            default:
                return "Unknown"
        }
    }
    
    var dropdownLabel: String {
        get {
            return self.name
        }
    }
    
    var value: Any {
        get {
            return self
        }
    }
    
    init(name: String, role: UserRole, email: String) {
        self.name = name
        self.role = role
        self.email = email
    }
}
