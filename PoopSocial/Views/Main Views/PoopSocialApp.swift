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
    
    @AppStorage("needsOnboarding") var needsOnboarding: Bool = true
    @AppStorage("darkMode") var darkMode: Bool = true
    @AppStorage("isNotFirstLaunch") var isNotFirstLaunch: Bool = false
    
    init() {
        if !isNotFirstLaunch { // if it is first launch
            // set initial color scheme
            let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
            let scheme: ColorScheme = schemeTransform(userInterfaceStyle: currentSystemScheme)
            darkMode = (scheme == ColorScheme.dark)
            isNotFirstLaunch = true
        }
        
        
    }
    
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
    
    // color scheme func
    func schemeTransform(userInterfaceStyle:UIUserInterfaceStyle) -> ColorScheme {
        if userInterfaceStyle == .light {
            return .light
        }else if userInterfaceStyle == .dark {
            return .dark
        }
        return .light
        
    }
}
