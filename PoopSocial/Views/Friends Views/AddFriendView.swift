//
//  AddFriendView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/24/22.
//

import SwiftUI

struct AddFriendView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var friendVM: FriendsViewModel

    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()

                    
                    List {
                        ForEach(friendVM.allUsers, id: \.uid) { user in //id is the users uid
                            AddFriendRowView(user: user, initialStatus: friendVM.checkCurrentFriendshipStatus(userA: FirebaseManager.shared.auth.currentUser?.uid ?? "", userB: user.uid))
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .listRowBackground(Color.secondary)
                
            }
            .navigationTitle("Add Friends")
        }
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView() //AddFriendView(friendVM: FriendsViewModel())
    }
}
