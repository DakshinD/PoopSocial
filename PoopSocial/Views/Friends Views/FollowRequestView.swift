//
//  FollowRequestView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/25/22.
//

import SwiftUI

struct FollowRequestView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var friendVM: FriendsViewModel

    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()

                    
                    List {
                        ForEach(friendVM.allFriendRequests) { request in //id is the users uid
                            FollowRequestRow(user: friendVM.getUserFromUID(uid: request.userA)!) // fix force unwrap
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .listRowBackground(Color.secondary)
                
            }
            .navigationTitle("Follow Requests")
            .onAppear {
                fetchFriendRequests()
                friendVM.fetchNewFriends()
            }
        }
    }
    
    func fetchFriendRequests() {
        
        FirebaseManager.shared.firestore
            .collection("friendships")
            .whereField("userB", isEqualTo: FirebaseManager.shared.auth.currentUser?.uid ?? "")
            .whereField("status", isEqualTo: "pending")
            .addSnapshotListener { documents, error in
                
                if let error = error {
                    print("Error fetching friend requests: \(error.localizedDescription)")
                    return
                }
                
                documents?.documentChanges.forEach({ change in
                    if change.type == .added  { // new friend request was made
                        let data = change.document.data()
                        let friendRequest = Friendship(data: data)
                        print("got friend req")
                        for request in friendVM.allFriendRequests {
                            if friendRequest.userA == request.userA && friendRequest.userB == request.userB && friendRequest.status == request.status {
                                return
                            }
                        }
                        friendVM.allFriendRequests.append(friendRequest)
                        
                        // i need to refresh the statuses in the add friends page
                    }
                })
            }
    }
}

struct FollowRequestView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView() //FollowRequestView()
    }
}
