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
    let fcmTokenA: String // fcmToken from userA
    
    let userB: String // uid - to user B
    let fcmTokenB: String // fcmToken from userB
    
    let status: String // pending, accepted | rejected --> delete document and doc not existing means no status
    
    init(data: [String : Any]) {
        self.userA = data["userA"] as? String ?? ""
        self.fcmTokenA = data["fcmTokenA"] as? String ?? ""
        
        self.userB = data["userB"] as? String ?? ""
        self.fcmTokenB = data["fcmTokenB"] as? String ?? ""
        
        self.status = data["status"] as? String ?? ""
    }
    
}
