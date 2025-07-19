//
//  Profile.swift
//  PlaygroundSwiftUI
//
//  Created by 김용해 on 7/19/25.
//

import Foundation

struct Profile: Identifiable {
    let id: String = UUID().uuidString
    let name: String?
    let email: String?
    
    init(email: String? = nil, name: String? = nil) {
        self.email = email
        self.name = name
    }
}
