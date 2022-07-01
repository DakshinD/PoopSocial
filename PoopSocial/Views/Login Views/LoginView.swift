//
//  ContentView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/23/22.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct LoginView: View {
    
    let didCompleteLoginProcess: () -> ()
    
    @State private var isLoginMode = false
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var shouldShowImagePicker = false
    @State private var image: UIImage?
    @State private var loginStatusMessage = ""
    
    @EnvironmentObject var friendVM: FriendsViewModel

    

    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                ScrollView {

                    VStack(spacing: 16) {
                        Picker(selection: $isLoginMode, label: Text("Picker here")) {
                            Text("Login")
                                .tag(true)
                            Text("Create Account")
                                .tag(false)
                        }.pickerStyle(SegmentedPickerStyle())

                        if !isLoginMode {
                            Button {
                                shouldShowImagePicker.toggle()
                            } label: {
                                VStack {
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 128, height: 128)
                                            .cornerRadius(64)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 64))
                                            .padding()
                                            .foregroundColor(Color(.label))
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                            .stroke(Color.black, lineWidth: 3)
                                )
                            }
                        }
                    
                        Group {
                            if !isLoginMode {
                                TextField("Username", text: $username)
                                    .keyboardType(.default)
                                    .autocapitalization(.none)
                                    .modifier(customViewModifier(roundedCornes: 6, startColor: .orange.opacity(0.6), endColor: .red.opacity(0.6), textColor: .white))
                            }
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .modifier(customViewModifier(roundedCornes: 6, startColor: .orange.opacity(0.6), endColor: .red.opacity(0.6), textColor: .white))
                            
                            SecureField("Password", text: $password)
                                .modifier(customViewModifier(roundedCornes: 6, startColor: .orange.opacity(0.6), endColor: .red.opacity(0.6), textColor: .white))
                        }
                        .background(Color.white)
                        .padding(12)
                        
                        
                        

                        Button(action: {
                            handleAction()
                        }) {
                            
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 25, weight: .bold))
                                
                        }
                        .buttonStyle(CustomGradientButton())
                        .frame(width: 225)
                        .padding()
                        
                        Text(self.loginStatusMessage)
                            .foregroundColor(.red)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.secondary.opacity(0.7)))
                        
                    }
                    .padding()

                }
                .navigationTitle(isLoginMode ? "Log In" : "Create Account")
                .background(Color(.init(white: 0, alpha: 0.05))
                                .ignoresSafeArea())
                
            }
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
    

    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    
    private func createNewAccount() {
        if self.image == nil {
            self.loginStatusMessage = "You must select an avatar image"
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("Failed to create user", error)
                self.loginStatusMessage = "Failed to create user: \(error.localizedDescription)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            
            self.persistsImageToStorage()
        }
    }
    
    private func persistsImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("returning here")
            return
        }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5)
        else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            
            if let error = error {
                self.loginStatusMessage = "Failed to push image to Storage: \(error.localizedDescription)"
                return
            }
            
            ref.downloadURL { url, error in
                
                if let error = error {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(error.localizedDescription)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString ?? "")
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
            

        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["email": self.email, "username": self.username ,"uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.loginStatusMessage = "\(error.localizedDescription)"
                    return
                }
                print("Success")
                
                self.didCompleteLoginProcess()// update user data singleton
            }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("Failed to log in user", error)
                self.loginStatusMessage = "Failed to log in as user: \(error.localizedDescription)"
                return
            }
            
            print("Successfully logged in user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            
            friendVM.refreshData()
            self.didCompleteLoginProcess()// update user data singleton
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess:{} )
    }
}
