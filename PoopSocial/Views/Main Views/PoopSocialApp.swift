//
//  PoopSocialApp.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/23/22.
//

import SwiftUI


@main
struct PoopSocialApp: App {
    
    @StateObject private var friendVM: FriendsViewModel = FriendsViewModel()
    @StateObject private var poopVM: PoopViewModel = PoopViewModel()
    @StateObject private var leaderboardVM: LeaderboardViewModel = LeaderboardViewModel()

    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            //LoginView()
            //MainMessagesView()
            ContentView()
                .environmentObject(friendVM)
                .environmentObject(poopVM)
                .environmentObject(leaderboardVM)
            
        }
    }
}
