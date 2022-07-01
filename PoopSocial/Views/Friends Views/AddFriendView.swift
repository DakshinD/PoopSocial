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
    
    @State private var userSearchText: String = ""

    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()

                    
                    List {
                        ForEach(filteredUsers, id: \.uid) { user in //id is the users uid
                            AddFriendRowView(user: user, initialStatus: friendVM.checkCurrentFriendshipStatus(userA: FirebaseManager.shared.auth.currentUser?.uid ?? "", userB: user.uid))
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .listRowBackground(Color.secondary)
                    .searchable(text: $userSearchText, placement: .navigationBarDrawer(displayMode: .always))
                                        
                
            }
            .navigationTitle("Add Friends")
        }
    }
    
    var filteredUsers: [User] {
            if userSearchText.isEmpty {
                return friendVM.allUsers.filter { $0.uid != FirebaseManager.shared.auth.currentUser?.uid }
            } else {
                return friendVM.allUsers.filter { $0.username.contains(userSearchText) && $0.uid != FirebaseManager.shared.auth.currentUser?.uid}
            }
        }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView() //AddFriendView(friendVM: FriendsViewModel())
    }
}
