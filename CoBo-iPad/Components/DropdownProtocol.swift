//
//  DropdownProtocol.swift
//  CoBo-iPad
//
//  Created by Amanda on 05/05/25.
//

import Foundation

protocol DropdownProtocol: Identifiable, Equatable {
    var dropdownLabel: String { get }
    var value: Any { get }
}
