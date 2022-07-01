//
//  UserData.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class UserData: ObservableObject {
    
    static let shared: UserData = UserData()
    
    @Published var uid: String = ""
    
    @Published var email: String = ""
    
    @Published var profileImageUrl: String = ""
    
    @Published var username: String = ""
    
    @Published var fcmToken: String = ""
    
    @Published var isNotLoggedIn: Bool = false
    
    
    
    init() {
        
        DispatchQueue.main.async {
            self.isNotLoggedIn = (FirebaseManager.shared.auth.currentUser?.uid == nil)
        }
        
        fetchCurrentUser()
    }
    
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        profileImageUrl = user.profileImageUrl
        username = user.username
        fcmToken = user.FCMToken
    }

    // Only call right after login is confirmed so uid can be fetched correctly
    public func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("couldnt find user")
            return
        }
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user: \(error.localizedDescription)")
                return
            }
            // snapshot has user data
            guard let data = snapshot?.data() else { return }
            
            let user = User(data: data)
            self.uid = user.uid
            self.email = user.email
            self.profileImageUrl = user.profileImageUrl
            self.username = user.username
            self.fcmToken = user.FCMToken
        }
    }
    
    func handleSignOut() {
        isNotLoggedIn = true
        try? FirebaseManager.shared.auth.signOut()
    }
    
}

