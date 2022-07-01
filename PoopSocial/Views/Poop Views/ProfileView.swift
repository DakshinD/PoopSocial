//
//  ProfileView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/1/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @ObservedObject private var user : UserData = UserData.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            VStack {
                // add editing image option
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
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
