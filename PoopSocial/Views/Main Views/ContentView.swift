//
//  ContentView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/23/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var friendVM: FriendsViewModel
    @EnvironmentObject var poopVM: PoopViewModel
    
    @ObservedObject private var user: UserData = UserData.shared
    
    var body: some View {
        
        TabView {
            
            PoopView()//Text("Test View")
                .tabItem {
                    Image(systemName: "person.wave.2.fill")
                    Text("Poop")
                }
                .environmentObject(poopVM)
                .environmentObject(friendVM)
            
            //MainMessagesView()
            FriendsView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Friends")
                }
                .environmentObject(friendVM)
            
            Text("Leaderboard")
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Statistics")
                }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .tabViewStyle(DefaultTabViewStyle())
        .accentColor(Color.accent)
        .fullScreenCover(isPresented: $user.isNotLoggedIn) {
            LoginView(didCompleteLoginProcess: {
                //AppDelegate.updateFirestorePushTokenIfNeeded(<#T##self: AppDelegate##AppDelegate#>) do we need to do this after user logs in?
                // need to init poop and friend view models again
                user.isNotLoggedIn = false
                user.fetchCurrentUser()
                poopVM.refreshAllData()
                friendVM.refreshAllData()
            })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
