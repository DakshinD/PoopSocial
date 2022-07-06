//
//  FollowRequestView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/25/22.
//

import SwiftUI

struct FollowRequestView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var friendVM: FriendsViewModel
    
    init() {
        
    }

    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()

                    
                    List {
                        ForEach(friendVM.allFriendRequests) { request in //id is the users uid
                            FollowRequestRow(user: UserData.shared.getUserFromUID(uid: request.userA)!) // fix force unwrap
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .listRowBackground(Color.secondary)
                
            }
            .navigationTitle("Follow Requests")

        }
    }
    

}

struct FollowRequestView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView() //FollowRequestView()
    }
}
