//
//  FriendsViewModel.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/26/22.
//

import SwiftUI

class FriendsViewModel: ObservableObject {
    
    @Published var allUsers: [User] = [User]()
    
    @Published var friends: [User] = [User]()
    
    @Published var allFriendships: [Friendship] = [Friendship]()
    
    @Published var allFriendRequests: [Friendship] = [Friendship]()
    
    @Published var friendRequestCount: Int = 0
    
    @Published var errorMessage: String = ""
    
    init() {
        
        fetchAllUsers() {
            
            self.fetchAllFriendships() {
                
                self.fetchAllFriends()
                
            }
            
        }
    }
    
    public func refreshAllData() {
        fetchAllUsers() {
            
            self.fetchAllFriendships() {
                
                self.fetchAllFriends()
                
            }
            
        }
    }
    
    public func refreshData() {
        fetchAllUsers(completion: {})
        fetchAllFriendships(completion: {})
    }
    
    public func getUserFromUID(uid: String) -> User? {
        for user in allUsers {
            if user.uid == uid {
                return user
            }
        }
        return nil
    }
    
    private func fetchAllUsers(completion: @escaping () -> Void) {
        
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documents, error in
                // Error
                if let error = error {
                    self.errorMessage = "Failed to retrieve user documents: \(error.localizedDescription)"
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
    
    // has to be called after fetchAllFriendships
    public func fetchAllFriends() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        print("fetching all friends")
        var tempFriends: [User] = [User]()
        for friendship in self.allFriendships {
            if friendship.status == "accepted" {
                var tempFriend: User
                if friendship.userA != uid {
                    tempFriend = self.getUserFromUID(uid: friendship.userA)!
                } else { // watch these force unwraps
                    tempFriend = self.getUserFromUID(uid: friendship.userB)!
                }
                tempFriends.append(tempFriend)
            }
        }
        self.friends = tempFriends
    }
    
    public func fetchNewFriends() { // fetch if follow requests THIS user sent has been accepted
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        FirebaseManager.shared.firestore
            .collection("friendships")
            .whereField("userA", isEqualTo: uid)
            .addSnapshotListener { documents, error in
                
                if let error = error {
                    print("Error fetching friends: \(error.localizedDescription)")
                    return
                }
                
                documents?.documentChanges.forEach({ change in
                    if change.type == .modified  { // new friend request was made
                        print("SNAPSHOT FOUND CHANGE")
                        let data = change.document.data()
                        let friendRequest = Friendship(data: data)
                        if friendRequest.status == "accepted" {
                            if !self.friends.contains(where: {$0.uid == friendRequest.userB}) {
                                print("a friend request was accepted")
                                // add friend to the array
                                self.friends.append(self.getUserFromUID(uid: friendRequest.userB)!)
                                self.fetchAllFriendships() {
                                    //friendVM.fetchAllFriends()
                                }
                            }
                        }
                    }
                })
            }
    }
    
    public func fetchAllFriendships(completion: @escaping () -> Void) { // friendships of current user - WILL HAVE TO BE CHANGED - CALLS TOO MANY DOCS AT LARGE SCALE
        allFriendships = []
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("User is not logged in")
            return
        }
        
        // call for when userA is current user
        FirebaseManager.shared.firestore.collection("friendships")
            .whereField("userA", isEqualTo: uid)
            .getDocuments { documents, error in
                // Error
                if let error = error {
                    self.errorMessage = "Failed to retrieve friendship documents: \(error.localizedDescription)"
                    print("Failed to retrieve friendship documents: \(error.localizedDescription)")
                    return
                }
                
                //Success
                //var tempFriendships: [Friendship] = [Friendship]()
                documents?.documents.forEach({ document in
                    let data = document.data()
                    let friendship = Friendship(data: data)
                    //if friendship.userA == FirebaseManager.shared.auth.currentUser?.uid || friendship.userB == FirebaseManager.shared.auth.currentUser?.uid {
                        // if the user retrieved is not the current user on the phone
                    self.allFriendships.append(.init(data: data))
                    //}
                })
                //self.allFriendships = tempFriendships
                print("Successfully rsetrieved all friendships")
                completion()
            }
        
        // call for when userB is current user
        FirebaseManager.shared.firestore.collection("friendships")
            .whereField("userB", isEqualTo: uid)
            .getDocuments { documents, error in
                // Error
                if let error = error {
                    self.errorMessage = "Failed to retrieve friendship documents: \(error.localizedDescription)"
                    print("Failed to retrieve friendship documents: \(error.localizedDescription)")
                    return
                }
                
                //Success
                //var tempFriendships: [Friendship] = [Friendship]()
                documents?.documents.forEach({ document in
                    let data = document.data()
                    let friendship = Friendship(data: data)
                    //if friendship.userA == FirebaseManager.shared.auth.currentUser?.uid || friendship.userB == FirebaseManager.shared.auth.currentUser?.uid {
                        // if the user retrieved is not the current user on the phone
                    self.allFriendships.append(.init(data: data))
                    //}
                })
                //self.allFriendships = tempFriendships
                print("Successfully retrieved all friendships")
                completion()
            }
    }
    
    public func addFriendship(userA: String, userB: String, completion: @escaping () -> Void) {
        // pending, accepted, "" - doesn't exist
        let documentID = userA + userB // friendship document ID
        
        let userObjectA: User = self.getUserFromUID(uid: userA) ?? User(data: [:])
        let userObjectB: User = self.getUserFromUID(uid: userB) ?? User(data: [:])

        
        FirebaseManager.shared.firestore.collection("friendships").document(documentID)
            .setData([
                "userA": userA,
                "fcmTokenA": userObjectA.FCMToken,
                "userB": userB,
                "fcmTokenB": userObjectB.FCMToken,
                "status": "pending" // when making friendship - default to pending
            ]) { error in
                if let error = error {
                    self.errorMessage = "Failed to upload friendship document: \(error.localizedDescription)"
                    print("Failed to upload friendship document: \(error.localizedDescription)")
                    return
                } else {
                    print("Successfully uploaded friendship document")
                    //self.fetchAllFriendships()
                    completion()
                }
            }
    }
    
    // have to refresh allFriendships to use this, if changes to status
    public func checkCurrentFriendshipStatus(userA: String, userB: String) -> String {
        
        for friendship in allFriendships {
            
            if friendship.userA == userA && friendship.userB == userB || friendship.userA == userB && friendship.userB == userA {
                return friendship.status
            }
            
        }
        
        return "Add" // default friendship status
        
    }
    
    // idk if this is still needed
    public func checkFriendshipStatus(userA: String, userB: String) -> String {
        // pending, accepted, "" - doesn't exist
        //let documentID = userA + userB // friendship document ID
        var status: String = ""
        
        FirebaseManager.shared.firestore.collection("friendships")
            .whereField("userA", in: [userA, userB])
            //.whereField("userB", in: [userA, userB])
            .getDocuments { documents, error in
            
                if let error = error {
                    self.errorMessage = "Failed to retrieve friendship document: \(error.localizedDescription)"
                    print("Failed to retrieve friendship document: \(error.localizedDescription)")
                    return
                } else {
                    for document in documents!.documents {
                       // print("\(document.documentID) => \(document.data())")

                        let data = document.data()
                        let friendship = Friendship(data: data)
                        
                        if friendship.userA == userA && friendship.userB == userB {
                            // matching document
                            status = friendship.status
                        }
                        else if friendship.userA == userB && friendship.userB == userA {
                            // matching document
                            status = friendship.status
                        }
                        else {
                            print("friendship document doesn't exist")
                            return
                        }
                    }
                }
        }
        return status // friendship status
    }
}
