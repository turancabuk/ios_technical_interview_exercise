//
//  Post.swift
//  Pollexa
//
//  Created by Emirhan Erdogan on 13/05/2024.
//

import UIKit

struct Post: Decodable {
    
    // MARK: - Properties
    let id: String
    let createdAt: Date
    let content: String
    let options: [Option]
    let user: User
    
    init(id: String, createdAt: Date, content: String, options: [Option], user: User) {
        self.id = id
        self.createdAt = createdAt
        self.content = content
        self.options = options
        self.user = user
    }
}
