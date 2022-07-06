//
//  LeaderboardView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/4/22.
//

import SwiftUI

struct LeaderboardView: View {
    
    @EnvironmentObject var friendVM: FriendsViewModel
    
    @EnvironmentObject var leaderboardVM: LeaderboardViewModel

    
    @ObservedObject private var user : UserData = UserData.shared
    
    
    @State private var leaderboardType:  Int = 0
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    
                    Picker("Leaderboard Type", selection: $leaderboardType) {
                        Text("Global")
                            .tag(0)
                        Text("Friends")
                            .tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    if leaderboardType == 0 { // Global Leaderboard - top 50 for now
                        
                        GlobalLeaderboardView()
                            .environmentObject(leaderboardVM)
                        
                    }
                    else if leaderboardType == 1 { // Friend Leaderboard
                        
                        FriendLeaderboardView()
                            .environmentObject(leaderboardVM)
                            .environmentObject(friendVM)


                        
                    }
                    
                }
                
            }
            .navigationTitle("Leaderboard")
            .onDisappear {
                friendVM.removeFriendLeaderboardListeners()
            }
            
        }
        
    }

}

    

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
