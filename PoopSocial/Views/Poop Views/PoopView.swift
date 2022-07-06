//
//  PoopView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/29/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PoopView: View {
    
    @EnvironmentObject var poopVM: PoopViewModel
    @EnvironmentObject var friendVM: FriendsViewModel
    
    @ObservedObject private var user : UserData = UserData.shared
    
    @State private var showProfileView: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geo in
                ZStack {
                    
                    Color.background
                        .ignoresSafeArea()
                    
                    VStack {
                        
                        HStack {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.secondary)
                                
                                HStack {
                                    
                                    VStack(alignment: .leading) {
                                        Text("🚽")
                                            .font(.system(size: 30))
                                            .padding(.vertical, 3)
                                        Text("Total Poops")
                                            .foregroundColor(Color.text)
                                            .font(.headline)
                                    }
                                    .padding(.leading, 7)
                                    
                                    Spacer()
                                    
                                    Text("\(poopVM.totalNumberOfPoops)")
                                        .bold()
                                        .padding()
                                    
                                }
                            }
                            .frame(height: 100)
                            .padding(.horizontal)
                            
                            Button(action: {
                                print("pressed poop button")
                                withAnimation {
                                    addNewPoop()
                                }
                                
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.normalGradient)
                                    ZStack(alignment: .bottomTrailing) {
                                        Text("💩")
                                            .font(.system(size: 60))
                                        
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .foregroundColor(Color.black)
                                            .frame(width: 20, height: 20)
                                            .offset(x: 5, y: -1)
                                            
                                    }
                                    
                                }
                                .frame(height: 100)
                                .padding(.vertical)
                                .padding(.trailing)
                            }
                            
                            
                            
                        }
                        
                        HStack {
                            Text("Your Poops")
                                .foregroundColor(Color.text)
                                .font(.title)
                                .bold()
                                
                            
                            Spacer()
                        }
                        .padding(.leading, 30)
                        
                        
                    
                        
                        List(poopVM.allPoops.sorted(by: { poop1, poop2 in
                            return poop1.timestamp.dateValue() > poop2.timestamp.dateValue()
                        }), id: \.timestamp) { poop in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Poop")
                                        .foregroundColor(Color.text)
                                        .font(.body)
                                        .bold()
                                        .padding(.vertical, 5)
                                    
                                    Text(poop.timestamp.dateValue(), style: .date).font(.caption)
                                    + Text(" @ ").font(.caption)
                                    + Text(poop.timestamp.dateValue(), style: .time).font(.caption)
                                }
                                
                                
                                Spacer()
                                
                                Text("\(poop.timestamp.dateValue().timeAgo()) ago")
                                    .foregroundColor(Color.gray)
                                    .font(.footnote)
                                    
                            }
                        }
                        
                    }
                    
                    
                }
                .navigationTitle("Poop Alerter")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ProfileView()) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 35, height: 35)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color(.label), lineWidth: 1)
                                )
                                .shadow(radius: 3)
                        }
//                        Button(action: {
//                            showProfileView.toggle()
//                        }) {
//
//                        }
                    }
                }
            }
            
        }
    }
    
    func addNewPoop() {
        
        let newPoop: Poop = Poop(timeTakenAt: Date.now)
        poopVM.addNewPoop(newPoop: newPoop)
        
    }
}

struct PoopView_Previews: PreviewProvider {
    static var previews: some View {
        PoopView()
    }
}
