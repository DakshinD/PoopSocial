//
//  SettingsView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/6/22.
//

import SwiftUI

struct SettingsView: View {
    
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()
                
                List {
                    
                    // turn notifications on or off --> setting in firebase user document --> check in cloud function
                    
                    
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
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
