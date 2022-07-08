//
//  ProfileView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/1/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    
    @ObservedObject private var user : UserData = UserData.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showImagePicker: Bool = false
    
    @State private var image: UIImage?

    
    var body: some View {
        
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            VStack {
                // add editing image option
                
                Button(action: {
                    showImagePicker.toggle()
                }) {
                    WebImage(url: URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(50)
                        .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.label), lineWidth: 1)
                        )
                        .shadow(radius: 3)
                }

                
                Text(user.username)
                    .foregroundColor(Color.text)
                    .font(.title)
                    .bold()
                
                List {
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.accent)
                        Text("Email")
                            .bold()
                        Spacer()
                        Text(user.email)
                    }
                    
                }
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    user.handleSignOut()
                }) {
                    Text("Log Out")
                        .bold()
                }
                .buttonStyle(CustomGradientButton())
                .frame(width: 250)
                
            }
            .padding()
            
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $showImagePicker, onDismiss: updateProfileFile) {
            ImagePicker(image: $image)
        }
        
    }
    
    private func updateProfileFile() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("returning here")
            return
        }
        
        guard let newImage = image else {
            print("User didn't choose an image")
            return
        }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = newImage.jpegData(compressionQuality: 0.5)
        else { return }
        
        ref.delete { error in
            if let error = error {
                print("Error in deleting profile image data in storage: \(error.localizedDescription)")
            }
        }
        
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            
            if let error = error {
                print("Failed to push image to Storage: \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                
                if let error = error {
                    print("Failed to retrieve downloadURL: \(error.localizedDescription)")
                    return
                }
                
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                print(url?.absoluteString ?? "")
                guard let url = url else { return }
                self.updateImageStorage(imageProfileUrl: url)
            }
            

        }
    }
    
    public func updateImageStorage(imageProfileUrl: URL) {
        UserData.shared.profileImageUrl = imageProfileUrl.absoluteString
        
        FirebaseManager.shared.firestore.collection("users").document(UserData.shared.uid)
            .updateData([
                "profileImageUrl": imageProfileUrl.absoluteString
            ]) { error in
                if let error = error {
                    print("Error updating image url in user document: \(error.localizedDescription)")
                }
            }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
