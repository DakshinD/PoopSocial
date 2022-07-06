//
//  OtherProfileView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/6/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct OtherProfileView: View { // for other users - not current user
    
    @ObservedObject private var userData : UserData = UserData.shared
    
    @EnvironmentObject var friendVM: FriendsViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var friendRequestStatus: String = ""
    
    var user: User

    
    var body: some View {
        
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            VStack {
                // add editing image option
                WebImage(url: URL(string: user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(.label), lineWidth: 1)
                    )
                    .shadow(radius: 3)
                
                Text(user.username)
                    .foregroundColor(Color.text)
                    .font(.title)
                    .bold()
                
                
                Button(action: {
                    print("add friend button pressed")
                    friendVM.addFriendship(userA: FirebaseManager.shared.auth.currentUser?.uid ?? "", userB: user.uid) {
                        print("completion handler run")
                        friendVM.fetchAllFriendships { // handle - only fetch the updated friendship? or add friendship object dont call db
                            getFriendshipStatus()
                        }
                    }
                }) {
                    Text(friendRequestStatus)
                        .bold()
                }
                .buttonStyle(CustomGradientButton(disabled: (friendRequestStatus == "Pending" || friendRequestStatus == "Following")))
                .frame(width: 250)
                .disabled((friendRequestStatus == "Pending" || friendRequestStatus == "Following"))
                .padding()
                
                if friendRequestStatus == "Following" {
                    
                    Spacer()
                    
                    Button(action: {
                        friendVM.deleteFriendship(userA: UserData.shared.uid, userB: user.uid)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Remove Friend")
                            .bold()
                    }
                    .buttonStyle(CustomSolidButton(color: .red))
                    .frame(width: 250)
                    .padding()
                }
                

                
                if friendRequestStatus != "Following" {
                    Spacer()
                }
                
            }
            .padding()
            
        }
        .navigationTitle("View Profile")
        .onAppear {
            getFriendshipStatus()
        }
        
    }
    
    func getFriendshipStatus() {
        print("GET FRIENDSHIPSTATUS WAS CALLED")
        let status: String = friendVM.checkCurrentFriendshipStatus(userA: FirebaseManager.shared.auth.currentUser?.uid ?? "", userB: self.user.uid)
        
        switch status {
        case "Add":
                friendRequestStatus = "Add Friend"
        case "pending":
                friendRequestStatus = "Pending"
        case "accepted":
                friendRequestStatus = "Following"
        default:
            friendRequestStatus = "Add Friend"
            
        }
        //print("friend request status: \(friendRequestStatus)")
    }
}

struct OtherProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
        //OtherProfileView()
    }
}
