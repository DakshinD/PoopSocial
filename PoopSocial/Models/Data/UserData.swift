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
    
    @Published var recieveNotifications: Bool = true
    
    @Published var isNotLoggedIn: Bool = false
    
    @Published var allUsers: [User] = [User]()
    
    
    
    init() {
        
        DispatchQueue.main.async {
            self.isNotLoggedIn = (FirebaseManager.shared.auth.currentUser?.uid == nil)
        }
        
        
    }
    
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        profileImageUrl = user.profileImageUrl
        username = user.username
        fcmToken = user.FCMToken
    }
    
    public func getUserFromUID(uid: String) -> User? {
        for user in allUsers {
            if user.uid == uid {
                return user
            }
        }
        return nil
    }
    
    public func fetchAllUsers(completion: @escaping () -> Void) {
        
        if self.isNotLoggedIn {
            return
        }
        
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documents, error in
                // Error
                if let error = error {
                    //self.errorMessage = "Failed to retrieve user documents: \(error.localizedDescription)"
                    print("Failed to retrieve user documents: \(error.localizedDescription)")
                    return
                }
                //Success
                var tempAllUsers: [User] = [User]()
                documents?.documents.forEach({ document in
                    let data = document.data()
                    let user = User(data: data)
                    //if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        // if the user retrieved is not the current user on the phone
                        tempAllUsers.append(.init(data: data))
                        //print(data)
                    //}
                })
                self.allUsers = tempAllUsers
                print("Successfully retrieved all users")
                completion()
            }
    }

    // Only call right after login is confirmed so uid can be fetched correctly
    public func fetchCurrentUser() {
        
        if self.isNotLoggedIn {
            return
        }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("couldnt find user")
            return
        }
        
        let currentUser = self.getUserFromUID(uid: uid)

        self.uid = currentUser!.uid
        self.email = currentUser!.email
        self.profileImageUrl = currentUser!.profileImageUrl
        self.username = currentUser!.username
        self.fcmToken = currentUser!.FCMToken

    }
    
    public func fetchCurrentUserFromFirebase() {
        
        if self.isNotLoggedIn {
            return
        }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("couldnt find user")
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user doc: \(error.localizedDescription)")
                return
            }
            
            let data = snapshot?.data()
            
            let currentUser = User(data: data!)
            
            self.uid = currentUser.uid
            self.email = currentUser.email
            self.profileImageUrl = currentUser.profileImageUrl
            self.username = currentUser.username
            self.fcmToken = currentUser.FCMToken
   
        }
        
    }
    
    func handleSignOut() {
        isNotLoggedIn = true
        try? FirebaseManager.shared.auth.signOut()
    }
    
    //LEADERBOARD FUNCTIONS
    
    public func fetchGlobalTopUsers(completion: @escaping ([(Int, User)]) -> ()) {
        
        FirebaseManager.shared.firestore.collection("leaderboards").document("global-leaderboard").getDocument { snapshot, error in
             
            if let error = error {
                print("Error getting global leaderboard doc: \(error.localizedDescription)")
                return
            }
            
            let data = snapshot?.data()
            if let data = data {
                let uidArray = data["users"] as? [String] ?? []
                let scoreArray = data["userPoops"] as? [Int] ?? []
                
                if uidArray.count != scoreArray.count {
                    print("Something went wrong with global leaderboard cloud function")
                }
                
                var globalLeaders: [(Int, User)] = []
                
                for i in 0...uidArray.count-1 {
                    globalLeaders.append((scoreArray[i], self.getUserFromUID(uid: uidArray[i]) ?? User(data: [:])))
                }
                
                print("GLOBAL LEADERS: \(globalLeaders)")
                completion(globalLeaders)
            }
        }
        
        
    }
    
}

