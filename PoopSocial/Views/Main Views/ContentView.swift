//
//  ContentView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/23/22.
//

import SwiftUI

struct ContentView: View {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @EnvironmentObject var friendVM: FriendsViewModel
    @EnvironmentObject var poopVM: PoopViewModel
    @EnvironmentObject var leaderboardVM: LeaderboardViewModel
    
    @ObservedObject private var user: UserData = UserData.shared
    
    @AppStorage("darkMode") var darkMode: Bool = false
    
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
            
            LeaderboardView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Leaderboard")
                }
                .environmentObject(friendVM)
                .environmentObject(leaderboardVM)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .tabViewStyle(DefaultTabViewStyle())
        .accentColor(Color.orange)
        .preferredColorScheme(darkMode ? .dark : .light)
        .fullScreenCover(isPresented: $user.isNotLoggedIn) {
            LoginView(didCompleteLoginProcess: {
                appDelegate.updateFirestorePushTokenIfNeeded()
                // need to init poop and friend view models again
                user.isNotLoggedIn = false
                user.fetchCurrentUserFromFirebase() {
                    poopVM.refreshAllData()
                    friendVM.refreshAllData()
                }
            })
        }
        .onAppear {
            UserData.shared.isNotLoggedIn = (FirebaseManager.shared.auth.currentUser?.uid == nil)

        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
