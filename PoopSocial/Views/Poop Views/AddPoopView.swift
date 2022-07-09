//
//  AddPoopView.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 7/7/22.
//

import SwiftUI
import Combine
import UIKit

struct AddPoopView: View {

    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var poopVM: PoopViewModel
    
    @State private var message: String = ""
    @State private var keyboardHeight: CGFloat = 0
    
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.background
                    .ignoresSafeArea()

                
                ScrollViewReader { (proxy: ScrollViewProxy) in

                    List {
                        
                        Section {
                            Text("Type in a custom message about your poop to notify your friends with")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                        }
                        .listRowBackground(Color.clear)
                        
                        Section(footer: Text("Message is limited to 170 characters")) {
                            
                                
                            
                            
                            ZStack {
                                
                                TextEditor(text: $message)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
                                    //.background(Color.orange.opacity(0.2))
                                    .onChange(of: self.message, perform: { value in
                                       if value.count > 170 {
                                           self.message = String(value.prefix(170))
                                      }
                                    })
                                    .onChange(of: message) { newValue in
                                        proxy.scrollTo(999, anchor: .bottom)
                                    }
                                    .padding(.vertical)
                                    
                                
                                Text(message).opacity(0).padding(.all, 8)
                            }
                            .shadow(radius: 1)
                                              
                            Text("Character count: \(message.count)")
                                .font(.footnote)
                                .bold()
                                .id(999)

                            
                            
                        }
                        
                        
                        Section {
                            Button(action: {
                                addNewPoop()
                            }) {
                                Text("Add New Poop 💩")
                                    .bold()
                            }
                            .buttonStyle(CustomGradientButton())
                            .frame(width: 250)
                            .padding()
                            
                        }
                        .listRowBackground(Color.clear)

                        
                    }
                        .listRowBackground(Color.secondary)
                        .listStyle(InsetGroupedListStyle())
                        .padding()

                }
                
                //.keyboardAdaptive()


                
            }
            .navigationTitle("Add Poop")
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .onAppear {
                
            }
            
        }
        

        
    }
    
    func addNewPoop() {
        print("add new poop called")
        
        let newPoop: Poop = Poop(timeTakenAt: Date.now, message: message)
        poopVM.addNewPoop(newPoop: newPoop)
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct AddPoopView_Previews: PreviewProvider {
    static var previews: some View {
        AddPoopView()
    }
}
