//
//  Friendship.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI

struct Friendship: Identifiable {
    
    let id = UUID()
    
    let userA: String // uid - from user A
    let userB: String // uid - to user B
    let status: String // pending, accepted | rejected --> delete document and doc not existing means no status
    
    init(data: [String : Any]) {
        self.userA = data["userA"] as? String ?? ""
        self.userB = data["userB"] as? String ?? ""
        self.status = data["status"] as? String ?? ""
    }
}
