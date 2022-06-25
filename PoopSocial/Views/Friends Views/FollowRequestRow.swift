//
//  FollowRequestRow.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/25/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct FollowRequestRow: View {
    
    var user: User
    @ObservedObject var friendVM : FriendsViewModel
    
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
                print("accept pressed")
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
                print("reject pressed")
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
    }
    
    func rejectFriendRequest() {
        // delete friendship document
    }
}

struct FollowRequestRow_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView() //FollowRequestRow()
    }
}
