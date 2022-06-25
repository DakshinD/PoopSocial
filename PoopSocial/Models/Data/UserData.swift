//
//  UserData.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI

class UserData: ObservableObject {
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        profileImageUrl = user.profileImageUrl
    }
    
    @Published var uid: String
    
    @Published var email: String
    
    @Published var profileImageUrl: String
    
}

