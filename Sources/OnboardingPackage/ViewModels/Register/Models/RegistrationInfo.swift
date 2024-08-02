//
//  RegistrationInfo.swift
//  
//
//  Created by Div Khare on 8/1/24.
//

import Foundation

public struct RegistrationInfo {
    public let name: String
    public let email: String
    public let password: String
    
    public init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
