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
    let email: String
    let profileImageUrl: String
    
    init(data: [String : Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
