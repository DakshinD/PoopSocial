//
//  FollowRequestRow.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/25/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowRequestRow: View {
    
    var user: User // from user
    @EnvironmentObject var friendVM: FriendsViewModel

    var body: some View {
        HStack {
            WebImage(url: URL(string: user.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            Text(user.username ?? "")
                .foregroundColor(Color.text)
                .font(.body)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                acceptFriendRequest()
            }) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color.init(red: 11/255, green: 230/255, blue: 37/255), Color.init(red: 33/255, green: 194/255, blue: 52/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 30, height: 30)

            
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.text)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                rejectFriendRequest()
            }) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [Color.init(red: 209/255, green: 21/255, blue: 30/255), Color.init(red: 186/255, green: 28/255, blue: 36/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 30, height: 30)

            
                    Image(systemName: "xmark")
                        .foregroundColor(Color.text)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
    }
    
    func acceptFriendRequest() {
        // modify status property in friendship document then reload the friends array
        let documentID = user.uid + (FirebaseManager.shared.auth.currentUser?.uid ?? "")
        FirebaseManager.shared.firestore.collection("friendships").document(documentID).updateData([
            "status": "accepted"
        ]) { error in
            if let error = error {
                print("Error in accepting friend request document: \(error.localizedDescription)")
                return
            } else {
                print("Successfully modified friend request document")
                
                // refresh friends list
                print("FETCHING ALL FRIENDSHIPS")
                friendVM.fetchAllFriendshipsBothParts {
                    print("FETCHING ALL FRIENDS")
                    friendVM.fetchAllFriends()
                }
                // refresh list
                friendVM.allFriendRequests.removeAll(where: {
                    $0.userA == user.uid && $0.userB == FirebaseManager.shared.auth.currentUser?.uid
                })
                friendVM.friendRequestCount = friendVM.allFriendRequests.count //update for badge
            }
        }
    }
    
    func rejectFriendRequest() {
        // delete friendship document
        let documentID = user.uid + (FirebaseManager.shared.auth.currentUser?.uid ?? "")
        FirebaseManager.shared.firestore.collection("friendships").document(documentID)
            .delete { error in
                if let error = error {
                    print("Error in deleting friend request document: \(error.localizedDescription)")
                    return
                }
            }
        
        // refresh friends list
        print("FETCHING ALL FRIENDSHIPS")
        friendVM.fetchAllFriendshipsBothParts {
            print("FETCHING ALL FRIENDS")
            friendVM.fetchAllFriends()
        }
        
        // refresh list
        friendVM.allFriendRequests.removeAll(where: {
            $0.userA == user.uid && $0.userB == FirebaseManager.shared.auth.currentUser?.uid
        })
        friendVM.friendRequestCount = friendVM.allFriendRequests.count // update for badge
        
        print("Friend Requests: \(friendVM.allFriendRequests)")
        
    }
}

struct FollowRequestRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView() //FollowRequestRow()
    }
}
