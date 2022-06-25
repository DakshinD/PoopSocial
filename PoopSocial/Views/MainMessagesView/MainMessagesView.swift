//
//  MainMessagesView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/23/22.
//

import SwiftUI
import SDWebImageSwiftUI



class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var user: User?
    @Published var isUserCurrentlyLoggedOut = false
    
    init() {
        
        DispatchQueue.main.async { //bug if u dont choose pfp
            self.isUserCurrentlyLoggedOut = (FirebaseManager.shared.auth.currentUser?.uid == nil)
        }
        
        fetchCurrentUser()
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
    public func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("couldnt find user")
            return
        }
        print(uid)
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user: \(error.localizedDescription)")
                self.errorMessage = "Could not find firebase uid"
                return
            }
            // snapshot has user data
            guard let data = snapshot?.data() else { return }
            
            self.user = .init(data: data)
            print(data)
            //self.errorMessage = user.profileImageUrl
        }
    }
}



struct MainMessagesView: View {

    @State var shouldShowLogOutOptions = false
    @ObservedObject var messagesViewModel = MainMessagesViewModel()
    
    
    var body: some View {
        NavigationView {

            VStack {
                //Text("Current user id: \(messagesViewModel.errorMessage)")
                customNavBar
                messagesView
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            WebImage(url: URL(string: messagesViewModel.user?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
                


            VStack(alignment: .leading, spacing: 4) {
                Text(messagesViewModel.user?.email ?? "")
                    .font(.system(size: 24, weight: .bold))

                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }

            }

            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    messagesViewModel.handleSignOut()
                }),
                    .cancel()
            ])
        }
        .fullScreenCover(isPresented: $messagesViewModel.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(didCompleteLoginProcess: {
                self.messagesViewModel.isUserCurrentlyLoggedOut = false
                self.messagesViewModel.fetchCurrentUser()
            })
        }
    }

    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1)
                            )


                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.system(size: 16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()

                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)

            }.padding(.bottom, 50)
        }
    }
    
    @State private var shouldShowAddFriendScreen: Bool = false

    private var newMessageButton: some View {
        Button {
            shouldShowAddFriendScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowAddFriendScreen) {
            Text("Test")
        }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
