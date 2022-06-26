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
    
    var body: some Scene {
        WindowGroup {
            //LoginView()
            //MainMessagesView()
            ContentView()
                .environmentObject(friendVM)
        }
    }
}
