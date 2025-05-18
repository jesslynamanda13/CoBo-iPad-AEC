//
//  UserRoleEnum.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

enum UserRole: String, Codable {
    case admin = "Admin"
    case learner = "Learner"
    case mentor = "Mentor"
    
    var id: String { self.rawValue }
}
