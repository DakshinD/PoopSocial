//
//  FriendsView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendsView: View {
    
    @State private var addFriendButtonPressed: Bool = false
    @State private var showFollowRequestView: Bool  =  false
    
    @EnvironmentObject var friendVM: FriendsViewModel

    //@ObservedObject var friendVM: FriendsViewModel = FriendsViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    
                    List {
                        
                        ForEach(friendVM.friends, id: \.uid) { friend in
                            NavigationLink(destination: OtherProfileView(user: friend)) {
                                HStack {
                                    WebImage(url: URL(string: friend.profileImageUrl ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipped()
                                        .cornerRadius(50)
                                        .overlay(RoundedRectangle(cornerRadius: 50)
                                                    .stroke(Color(.label), lineWidth: 1)
                                        )
                                        .shadow(radius: 5)
                                    
                                    Text(friend.username ?? "")
                                        .foregroundColor(Color.text)
                                        .font(.body)
                                        .padding(.horizontal)
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        
                    }
                    .listStyle(InsetGroupedListStyle())
                    .listRowBackground(Color.secondary)

                }
                .sheet(isPresented: $addFriendButtonPressed) {
                    AddFriendView()
                        .navigationTitle("Add Friends")
                        .environmentObject(self.friendVM)

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
                    .overlay(Badge(count: $friendVM.friendRequestCount))
                    
                }
            }
            .sheet(isPresented: $showFollowRequestView) {
                FollowRequestView()
                    .environmentObject(self.friendVM)
                    .navigationTitle("Friend Requests")
            }
            .onAppear {
                friendVM.fetchNewFriends()
                fetchFriendRequests()
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
                        friendVM.friendRequestCount = friendVM.allFriendRequests.count
                        friendVM.fetchAllFriendships(completion: {})
                        // i need to refresh the statuses in the add friends page
                    }
                })
            }
    }
    
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
