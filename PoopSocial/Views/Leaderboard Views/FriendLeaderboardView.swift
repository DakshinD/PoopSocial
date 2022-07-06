//
//  FriendLeaderboardView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/4/22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore
import Firebase

struct FriendLeaderboardView: View {
    
    @EnvironmentObject var leaderboardVM: LeaderboardViewModel
    @EnvironmentObject var friendVM: FriendsViewModel
    @EnvironmentObject var poopVM: PoopViewModel
    

    
    var body: some View {
        // top rounded part where it says "total poops" + filter for list --> all time/month/week/day (firebase query based on timestamp?)
        
        // list of all friends of user based on total poops
        
        // at end of list, have special row to show user's position
        List {
            
            Section {
                
                HStack {
                    Text("Fellow Poopers")
                        .font(.subheadline)
                        .bold()
                        .frame(height: 20)
                    Spacer()
                }
                .listRowBackground(Color.dimGradient)
                
                
                ForEach(Array(friendVM.friendStatsList.sorted{ return $0.value > $1.value }.enumerated()), id: \.1.key) { index, userRankPair in
                    let user: User = UserData.shared.getUserFromUID(uid: userRankPair.key) ?? User(data: [:])
                    HStack {
                        
                        Text("\(index+1)")
                            .font(.title3)
                            .bold()
                        
                        Divider()
                            .padding(5)
                        
                        WebImage(url: URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipped()
                            .cornerRadius(50)
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.label), lineWidth: 1)
                            )
                            .shadow(radius: 3)
                        
                        Text(user.username)
                        
                        Spacer()
                        
                        Text("\(userRankPair.value) 💩")
                        
                    }
                    .listRowBackground((userRankPair.key == UserData.shared.uid) ? Color.orange.opacity(0.1) : Color.secondary)
                }
                .frame(height: 60)
                

                
            }
            
            
        }
        .listRowBackground(Color.secondary)
        .listStyle(InsetGroupedListStyle())
        .environment(\.defaultMinListRowHeight, 20)


        
    }
    

    
}

struct FriendLeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        FriendLeaderboardView()
    }
}
