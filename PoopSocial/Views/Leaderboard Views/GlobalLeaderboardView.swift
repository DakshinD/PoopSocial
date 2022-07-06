//
//  GlobalLeaderboardView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/4/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct GlobalLeaderboardView: View {
    
    @EnvironmentObject var leaderboardVM: LeaderboardViewModel
    @EnvironmentObject var friendVM: FriendsViewModel

    
    var body: some View {
        
        List {
            
            // top rounded part where it says "total poops" + filter for list --> all time/month/week/day (firebase query based on timestamp?)
            
            // list of top ~50 users with links to profile (add friend button on profile)
            
            // at end of list, if user is not in top 50, have separate row that shows users score and place?
            
            Section {
                
                HStack {
                    Text("Top 20 Poopers")
                        .font(.subheadline)
                        .bold()
                        .frame(height: 20)
                    Spacer()
                }
                .listRowBackground(Color.dimGradient)
                
                
                ForEach(Array(friendVM.globalLeaders.sorted(by: { pair1, pair2 in
                    pair1.0 > pair2.0
                }).enumerated()), id: \.1.1.uid) { index, rankUserPair in
                    HStack {
                        
                        Text("\(index+1)")
                            .font(.title3)
                            .bold()
                        
                        Divider()
                            .padding(5)
                        
                        WebImage(url: URL(string: rankUserPair.1.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipped()
                            .cornerRadius(50)
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color(.label), lineWidth: 1)
                            )
                            .shadow(radius: 3)
                        
                        Text(rankUserPair.1.username)
                        
                        Spacer()
                        
                        Text("\(rankUserPair.0) 💩")
                        
                    }
                    .listRowBackground((rankUserPair.1.uid == UserData.shared.uid) ? Color.orange.opacity(0.1) : Color.secondary)
                }
                .frame(height: 60)
                

                
            }
            
            
        }
        .listRowBackground(Color.secondary)
        .listStyle(InsetGroupedListStyle())
        .environment(\.defaultMinListRowHeight, 20)
        
    }
    
}

struct GlobalLeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalLeaderboardView()
    }
}
