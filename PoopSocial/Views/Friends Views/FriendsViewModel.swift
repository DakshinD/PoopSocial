//
//  FriendsViewModel.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/26/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class FriendsViewModel: ObservableObject {
    
    
    
    //@Published var allUsers: [User] = [User]() - use UserData one
    
    @Published var friends: [User] = [User]()
    
    @Published var allFriendships: [Friendship] = [Friendship]()
    
    @Published var allFriendIDs: [String] = [String]()// for leaderboard
    
    @Published var allFriendRequests: [Friendship] = [Friendship]()
    
    @Published var friendRequestCount: Int = 0
    
    @Published var errorMessage: String = ""
    
    // Leaderboard
    @Published var globalLeaders: [(Int, User)] = []
    
    @Published var friendStatsList: [String : Int] = [:] // UID : Total Poops

    
    init() {
        
        UserData.shared.fetchAllUsers() {
            
            if !UserData.shared.isNotLoggedIn {
                UserData.shared.fetchCurrentUser()
            }
            
            UserData.shared.fetchGlobalTopUsers { arr in
                self.globalLeaders = arr
            }
            
            self.fetchAllFriendships() {
                
                self.fetchAllFriends()
                
            }
            
        }
    }
    
    public func refreshAllData() {
        UserData.shared.fetchAllUsers() {
            
            self.fetchAllFriendships() {
                
                self.fetchAllFriends()
                
            }
            
        }
    }
    
    public func refreshData() {
        //fetchAllUsers(completion: {})
        fetchAllFriendships(completion: {})
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
                    tempFriend = UserData.shared.getUserFromUID(uid: friendship.userA)!
                } else { // watch these force unwraps
                    tempFriend = UserData.shared.getUserFromUID(uid: friendship.userB)!
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
                                self.friends.append(UserData.shared.getUserFromUID(uid: friendRequest.userB)!)
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
        allFriendIDs = []
        
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
                    self.allFriendIDs.append(friendship.userB)
                    self.allFriendships.append(.init(data: data))
                    //}
                })
                //self.allFriendships = tempFriendships
                print("Successfully retrieved all friendships Pt. B")
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
                    self.allFriendIDs.append(friendship.userA)
                    self.allFriendships.append(.init(data: data))
                    //}
                })
                //self.allFriendships = tempFriendships
                print("Successfully retrieved all friendships Pt. A")
                completion()
            }
    }
    
    public func addFriendship(userA: String, userB: String, completion: @escaping () -> Void) {
        // pending, accepted, "" - doesn't exist
        let documentID = userA + userB // friendship document ID
        
        let userObjectA: User = UserData.shared.getUserFromUID(uid: userA) ?? User(data: [:])
        let userObjectB: User = UserData.shared.getUserFromUID(uid: userB) ?? User(data: [:])

        
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
    
    public func deleteFriendship(userA: String, userB: String) {
        // get the id of friend
        var idOfFriend: String = ""
        if userA == UserData.shared.uid { idOfFriend = userB }
        else if userB == UserData.shared.uid { idOfFriend = userA }
        // find docId
        var docId: String = ""
        var docIdx: Int = 0
        for i in 0..<self.allFriendships.count {
            let friendship = allFriendships[i]
            if friendship.userA == userA && friendship.userB == userB {
                docId = userA + userB
                docIdx = i
                break
            }
            else if friendship.userB == userA && friendship.userA == userB {
                docId = userB + userA
                docIdx = i
                break
            }
        }
        // found doc ID
        // remove doc
        FirebaseManager.shared.firestore.collection("friendships").document(docId).delete { error in
            if let error = error {
                print("Error in deleting friendship document: \(error.localizedDescription)")
                return
            }
            // change the friendships list
            self.allFriendships.remove(at: docIdx)
            // change friends id listx for leaderboard query
            self.allFriendIDs.removeAll { id in
                return id == idOfFriend
            }
            // change friends array
            for i in 0..<self.friends.count {
                if self.friends[i].uid == idOfFriend {
                    self.friends.remove(at: i)
                    break
                }
            }
            print("Successfully removed friendship document between \(userA) and \(userB)")
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
    
    var friendLeaderboardListeners: [ListenerRegistration?] = []
    
    public func getAllFriendPoopTotals() {
        var allFriendAndUserIDs = allFriendIDs
        allFriendAndUserIDs.append(UserData.shared.uid)
        print("FRIENDID: \(allFriendAndUserIDs.count)")
        let doubleCountVal = Double(allFriendAndUserIDs.count)
        var setsOf10: Double = (doubleCountVal)/10.0
        setsOf10.round(.up) // should be ceiling
        let setsOf10Int = Int(setsOf10)
        // setsOf10 is the number of snapshot listeners to be made - in order to use the 'in' query type
        
        for i in 0..<setsOf10Int { // number of spanshot listeners
            // START math to calculate end of set of 10 indexes
            var endOfJLoop = 0;
            
            if allFriendAndUserIDs.count > ((10*i)+10) {
                endOfJLoop = ((10*i)+10)
            } else {
                endOfJLoop = (10*i) + (allFriendAndUserIDs.count%10)
            }
            // END math
            // get array of 10 docIDs/friendIDs
            var setOf10FriendIDs = [String]()
            for j in (10*i) ..< endOfJLoop {
                setOf10FriendIDs.append(allFriendAndUserIDs[j])
            }
            // check for correct batch
            if setOf10FriendIDs.count > 10 {
                print("Something went wrong getting batch of 10 friend IDs for snapshot listener")
                return
            }
            // create snapshot listener
            friendLeaderboardListeners.append(
                FirebaseManager.shared.firestore.collection("poops").whereField(FieldPath.documentID(), in: setOf10FriendIDs)
                .addSnapshotListener { snapshot, error in
                    print("MADE IT INSIDE FIREBASE CALL")
                    if let error = error {
                        print("Error in listening to friend poop documents: \(error.localizedDescription)")
                        return
                    }
                    
                    snapshot?.documentChanges.forEach({ change in
                        // friend has added a new poop, need to update leaderboard friends array
                        if change.type == .modified || change.type == .added {
                            print("got changes")
                            let data = change.document.data()
                            let poopDoc: PoopDocument = PoopDocument(data: data)
                            self.friendStatsList[change.document.documentID] = poopDoc.totalPoops
                            
                            
                        }
                        
                    })
                        
                })

            
            
        }
        
        print("LENGTH OF DICT: \(friendStatsList.count)")
    }
    
    public func removeFriendLeaderboardListeners() {
        for i in 0..<friendLeaderboardListeners.count {
            friendLeaderboardListeners[i]?.remove()
        }
    }


}
