//
//  PoopDetailView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/7/22.
//

import SwiftUI

struct PoopDetailView: View {
    
    var poop: Poop
    
    var body: some View {
        
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            List {
                
                HStack {
                    
                    Image(systemName: "clock")
                        .foregroundColor(Color.accent)
                        .imageScale(.large)
                    Text("Time")
                        .bold()
                    
                    Spacer()
                    
                    Text(poop.timestamp.dateValue(), style: .date)
                    + Text(" @ ")
                    + Text(poop.timestamp.dateValue(), style: .time)
                    
                }
                
                HStack {
                    Image(systemName: "note.text")
                        .foregroundColor(Color.accent)
                        .imageScale(.large)

                    Text("Description")
                        .bold()

                    
                    Spacer()
                    
                    Text((poop.message == "") ? "Poop Alert!" : poop.message)
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .listRowBackground(Color.secondary)
            
        }
        .navigationTitle("Poop")
        

        
    }
    
}

struct PoopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        //PoopDetailView()
        EmptyView()
    }
}
