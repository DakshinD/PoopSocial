//
//  LeaderboardViewModel.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/4/22.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore

class LeaderboardViewModel: ObservableObject {
    
    @Published var userGlobalPlace: Int = 0
    // set these values in respective function
    @Published var userFriendPlace: Int = 0
    
    //@Published var friendStatList: [(Int, User)] = []
    
    init() {
        
//        UserData.shared.fetchGlobalTopUsers { userArray in
//            self.globalLeaders = userArray
//        };
        
        fetchAllFriendStats()
        
    }
    

    
    public func fetchAllFriendStats() {
        
        // do i get the array for all friends --> this allows for sorting based on time
        
        // or do i just get the length of the array --> this doesn't allow for sorting
        
    }
    
}

