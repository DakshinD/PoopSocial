//
//  FriendsView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI

class FriendsViewModel: ObservableObject {
    
    @Published var allUsers: [User] = [User]()
    
    @Published var friends: [User] = [User]()
    
    @Published var allFriendships: [Friendship] = [Friendship]()
    
    @Published var allFriendRequests: [Friendship] = [Friendship]()
    
    @Published var errorMessage: String = ""
    
    init() {
        
        fetchAllUsers()
        
        fetchAllFriendships() {
            // do nothing
        }
        
    }
    
    public func getUserFromUID(uid: String) -> User? {
        for user in allUsers {
            if user.uid == uid {
                return user
            }
        }
        return nil
    }
    
    private func fetchAllUsers() {
        
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documents, error in
                // Error
                if let error = error {
                    self.errorMessage = "Failed to retrieve user documents: \(error.localizedDescription)"
                    print("Failed to retrieve user documents: \(error.localizedDescription)")
                    return
                }
                //Success
                documents?.documents.forEach({ document in
                    let data = document.data()
                    let user = User(data: data)
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        // if the user retrieved is not the current user on the phone
                        self.allUsers.append(.init(data: data))
                        print(data)
                    }
                })
                print("Successfully retrieved all users")
            }
    }
    
    public func fetchAllFriendships(completion: @escaping () -> Void) { // friendships of current user
        
        FirebaseManager.shared.firestore.collection("friendships")
            .getDocuments { documents, error in
                // Error
                if let error = error {
                    self.errorMessage = "Failed to retrieve friendship documents: \(error.localizedDescription)"
                    print("Failed to retrieve friendship documents: \(error.localizedDescription)")
                    return
                }
                
                //Success
                documents?.documents.forEach({ document in
                    let data = document.data()
                    let friendship = Friendship(data: data)
                    if friendship.userA == FirebaseManager.shared.auth.currentUser?.uid || friendship.userB == FirebaseManager.shared.auth.currentUser?.uid {
                        // if the user retrieved is not the current user on the phone
                        self.allFriendships.append(.init(data: data))
                    }
                })
                print("Successfully retrieved all friendships")
                completion()
            }
    }
    
    public func addFriendship(userA: String, userB: String, completion: @escaping () -> Void) {
        // pending, accepted, "" - doesn't exist
        let documentID = userA + userB // friendship document ID
        
        FirebaseManager.shared.firestore.collection("friendships").document(documentID)
            .setData([
                "userA": userA,
                "userB": userB,
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
    
    public func checkCurrentFriendshipStatus(userA: String, userB: String) -> String {
        
        for friendship in allFriendships {
            
            if friendship.userA == userA && friendship.userB == userB || friendship.userA == userB && friendship.userB == userA {
                return friendship.status
            }
            
        }
        
        return "Add" // default friendship status
        
    }
    
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
                
                
                
            /*if let documents = document, document.exists {
                // Friendship Exists
                let data = document.data()
                
                if let data = data {
                    let friendship = Friendship(data: data)
                    status = friendship.status
                }
            } else {
                // Friendship DOESNT Exist
                self.errorMessage = "Failed to retrieve friendship document: \(error?.localizedDescription ?? "")"
                print("Failed to retrieve friendship document: \(error?.localizedDescription ?? "")")
            }*/
        }
        return status // friendship status
    }
}

struct FriendsView: View {
    
    @State private var addFriendButtonPressed: Bool = false
    @State private var showFollowRequestView: Bool  =  false
    
    @ObservedObject var friendVM: FriendsViewModel = FriendsViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    Text("Test")
                        .sheet(isPresented: $showFollowRequestView) {
                            FollowRequestView(friendVM: friendVM)
                                .navigationTitle("Friend Requests")
                        }
                }
                .sheet(isPresented: $addFriendButtonPressed) {
                    AddFriendView(friendVM: friendVM)
                        .navigationTitle("Add Friends")
                }
                
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("add friend button pressed")
                        addFriendButtonPressed.toggle()
                    }) {
                        Image(systemName: "person.badge.plus")
                    }
                    
                    Button(action: {
                        print("follow request button pressed")
                        showFollowRequestView.toggle()
                    }) {
                        Image(systemName: "heart.fill")
                    }
                }
            }
            
        }
        
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
