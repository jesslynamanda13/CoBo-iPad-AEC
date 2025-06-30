//
//  UserModel.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import Foundation
import SwiftData
struct User: DropdownProtocol, Hashable, Identifiable, Codable{
   
    @Attribute(.unique) var recordName: String
    var name: String
    var role: UserRole
    var email: String
    
    
    var id: String { recordName }
    
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
        return "\(name)"
    }
    
   
    
    var value: Any {
        get {
            return self
        }
    }
    
    init(recordName:String, name: String, role: UserRole, email: String) {
        self.recordName = recordName
        self.name = name
        self.role = role
        self.email = email
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
