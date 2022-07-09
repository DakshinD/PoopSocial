//
//  SettingsView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/6/22.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var userData = UserData.shared
    
    @AppStorage("darkMode") var darkMode: Bool = false
    
    
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
                        Toggle(isOn: $darkMode) {
                            HStack {
                                Image(systemName: "circle.lefthalf.filled")
                                    .foregroundColor(Color.accent)
                                Text("Dark Mode")
                            }
                        }
                    }
                    
                    
                    // Fiber
                    Section(header: Text("Tips")) {
                        NavigationLink(destination: FiberInfoView) {
                            HStack {
                                Image(systemName: "cross.case.fill")
                                    .foregroundColor(Color.accent)

                                Text("Fiber Facts")
                            }
                        }
                    }
                    
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
    
    var FiberInfoView: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            List {
                Section(footer: Text("Disclaimer: This is for informational purposes only and doesn't substitute professional medical advice by a doctor.")) {
                    Text("- Fiber helps your bowel health! Eat your fiber! It'll become easier to poop and you won't become constipated")
                    Text("- Fiber can help you feel full, which in turn can help with weight loss")
                    Text("- You're at a lower risk of heart disease when eating more fiber")
                    Text("- The average adult needs around 30 grams of fiber a day! A banana has around 3 grams of fiber")
                    Text("- Your poops feel fantastic if you eat more fiber")
                }
                
            }
            .listRowBackground(Color.secondary)
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("Fiber Facts")
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
