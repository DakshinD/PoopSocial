//
//  User.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/23/22.
//

import SwiftUI
import Foundation

struct User: Hashable {
    
    let uid: String
    let username: String
    let email: String
    let profileImageUrl: String
    let FCMToken: String
    let recieveNotifications: Bool
    
    init(data: [String : Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.FCMToken = data["FCMToken"] as? String ?? ""
        self.recieveNotifications = data["recieveNotifications"] as? Bool ?? true
    }
}
