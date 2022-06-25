//
//  AddFriendRowView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddFriendRowView: View {
    
    var user: User
    
    @ObservedObject var friendVM: FriendsViewModel
    
    @State private var friendRequestStatus: String
    
    init(user: User, initialStatus: String, friendVM: FriendsViewModel) {
        self.user = user
        self.friendVM = friendVM
        friendRequestStatus = initialStatus
    }
    
    
    var body: some View {
        
        HStack {
            WebImage(url: URL(string: user.profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            Text(user.email)
                .foregroundColor(Color.text)
                .font(.body)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                print("pressed")
                friendVM.addFriendship(userA: FirebaseManager.shared.auth.currentUser?.uid ?? "", userB: user.uid) {
                    print("completion handler run")
                    friendVM.fetchAllFriendships {
                        getFriendshipStatus()
                    }
                }

            }) {
                
                ZStack {
                    Capsule()
                        .strokeBorder(.black, lineWidth: 2)
                        .frame(width: 85, height: 35)
                        .background(Capsule().fill(Color.accent.opacity((friendRequestStatus == "pending") ? 0.4 : 0.7)))
                        
                    
                    Text(friendRequestStatus)
                        .foregroundColor(Color.text)
                }
            }
            .disabled((friendRequestStatus == "pending" || friendRequestStatus == "accepted"))
        }
        .padding()
        
    }
    
    func getFriendshipStatus() {
        print("GET FRIENDSHIPSTATUS WAS CALLED")
        let status: String = friendVM.checkCurrentFriendshipStatus(userA: FirebaseManager.shared.auth.currentUser?.uid ?? "", userB: self.user.uid)
        self.friendRequestStatus = status
        print("friend request status: \(friendRequestStatus)")
    }
    
    /*@ViewBuilder
    func getButtonView() -> some View {
        if friendRequestStatus == "Add" {
            Button(action: {
                friendVM.addFriendship(userA: FirebaseManager.shared.auth.currentUser?.uid ?? "", userB: user.uid)
            }) {
                
                ZStack {
                    Capsule()
                        .strokeBorder(.black, lineWidth: 2)
                        .frame(width: 85, height: 35)
                        .background(Capsule().fill(Color.accent.opacity(0.7)))
                        
                    
                    Text(friendRequestStatus)
                        .foregroundColor(Color.text)
                }
            }
        }
        else if friendRequestStatus == "pending" {
            Button(action: {
                print("button pressed while pending")
            }) {
                
                ZStack {
                    Capsule()
                        .strokeBorder(.black, lineWidth: 2)
                        .frame(width: 85, height: 35)
                        .background(Capsule().fill(Color.accent.opacity(0.4)))
                        
                    
                    Text(friendRequestStatus)
                        .foregroundColor(Color.text)
                }
                .disabled(true)
            }
        }
        else if friendRequestStatus == "accepted" {
            
        }
    }*/
}

struct AddFriendRowView_Previews: PreviewProvider {
    static var previews: some View {
        //EmptyView()
        AddFriendRowView(user: User(data: [:]), initialStatus: "add", friendVM: FriendsViewModel())
    }
}
