//
//  FriendsView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore

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
                // both are listeners for acceptance of friend requests, and new friend requests for user
                friendVM.fetchNewFriends()
                friendVM.fetchFriendRequests()
            }

            
        }
       
        
    }
    
    
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
