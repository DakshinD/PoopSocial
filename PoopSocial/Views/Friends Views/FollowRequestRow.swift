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
            
            Text(user.email ?? "")
                .foregroundColor(Color.text)
                .font(.body)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                acceptFriendRequest()
            }) {
                ZStack {
                    Circle()
                        .strokeBorder(.black, lineWidth: 2)
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(Color.green.opacity(0.8)))
            
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
                        .strokeBorder(.black, lineWidth: 2)
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(Color.red.opacity(0.8)))
            
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
            }
        }
        // refresh list
        friendVM.allFriendRequests.removeAll(where: {
            $0.userA == user.uid && $0.userB == FirebaseManager.shared.auth.currentUser?.uid
        })

        
        // refresh friends list
        print("FETCHING ALL FRIENDSHIPS")
        friendVM.fetchAllFriendships {
            print("FETCHING ALL FRIENDS")
            friendVM.fetchAllFriends()
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
        // refresh list
        friendVM.allFriendRequests.removeAll(where: {
            $0.userA == user.uid && $0.userB == FirebaseManager.shared.auth.currentUser?.uid
        })

        
        print("Friend Requests: \(friendVM.allFriendRequests)")
        
    }
}

struct FollowRequestRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView() //FollowRequestRow()
    }
}
