//
//  ContentView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/23/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var friendVM: FriendsViewModel
    
    var body: some View {
        
        TabView {
            
            MainMessagesView()//Text("Test View")
                .tabItem {
                    Image(systemName: "person.wave.2.fill")
                    Text("Poop")
                }
            
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
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
