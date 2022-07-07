//
//  SettingsView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/6/22.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var userData = UserData.shared
    
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                List {
                    
                    // turn notifications on or off --> setting in firebase user document --> check in cloud function
                    Section(header: Text("Notifications")) {

                            
                        Toggle(isOn: $userData.recieveNotifications) {
                            HStack {
                                Image(systemName: "bell.fill")
                                    .foregroundColor(Color.accent)
                                Text("Recieve Notifications")
                            }
                        }
                        .onChange(of: userData.recieveNotifications) { newValue in
                            changeNotificationSetting(val: newValue)
                        }
                        
                    }
                    
                    // Appearance - dark mode
                    Section(header: Text("Appearance")) {
                        HStack {
                            Text("Dark Mode")
                            Spacer()
                            //Toggle()
                        }
                    }
                    
                    
                    // FAQ
                    
                }
                .listRowBackground(Color.secondary)
                .listStyle(InsetGroupedListStyle())
                
            }
            .navigationTitle("Settings")
            
        }
        
    }
    
    public func changeNotificationSetting(val: Bool) {
        print("Changed notification setting toggle")
        FirebaseManager.shared.firestore.collection("users").document(UserData.shared.uid)
            .updateData([
                "recieveNotifications": val
            ]) { error in
                if let error = error {
                    print("Failed to update notification settings in user document: \(error.localizedDescription)")
                    return
                }
                print("Successfully updated notification settings")
            }
        
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
