//
//  PoopViewModel.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/29/22.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseFirestore

class PoopViewModel: ObservableObject {
    
    @Published var totalNumberOfPoops: Int = 0
    
    @Published var allPoops: [Poop] = [Poop]()
    
    init() {
        //totalNumberOfPoops = 0 // calc total number from firebase by getting array length
        fetchAllPoops()
    }
    
    public func refreshAllData() {
        fetchAllPoops()
    }
    
    public func fetchAllPoops() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("User is not logged in")
            return
        }
        //let uid = FirebaseManager.shared.auth.currentUser?.uid ?? ""
        
        FirebaseManager.shared.firestore.collection("poops").document(uid).getDocument { document, error in
            
            if let error = error {
                print("Failed to retrieve poop document: \(error.localizedDescription)")
                return
            } else {
                let data = document?.data()
                if let data = data {
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                        let poopData = try JSONDecoder().decode([String:[Poop]].self, from: jsonData)
                        let poopsArray = poopData["poops"]
                        self.allPoops = poopsArray ?? []
                        self.totalNumberOfPoops = self.allPoops.count // set correct number of poops for upload validations type
                        print("PoopsArray is: \(poopsArray)")
                        print("Successfully retrieved poop document")
                        
                        
                    } catch {
                        print("Error decoding poops document from firebase: \(error)")
                    }
                    
                }
                
                
            }
        }
        
    }
    
    public func addNewPoop(newPoop: Poop) {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("User is not logged in")
            return
        }
       // let uid = FirebaseManager.shared.auth.currentUser?.uid ?? ""
        var newPoopArray: [Poop] = [Poop]()
        newPoopArray.append(newPoop)
        
        var newPoopJSON: Any
        do {
            let jsonData = try JSONEncoder().encode(newPoop)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            newPoopJSON = jsonObject
        } catch {
            print("Found error in converting Poop Object to JSON: \(error.localizedDescription)")
            return
        }
        
        if self.totalNumberOfPoops == 0 { // no document - need to setData
            
            FirebaseManager.shared.firestore.collection("poops").document(uid).setData([
                "poops": FieldValue.arrayUnion([newPoopJSON])
            ]) { error in
                if let error = error {
                    //self.errorMessage = "Failed to upload poop document: \(error.localizedDescription)"
                    print("Failed to upload poop document: \(error.localizedDescription)")
                    return
                } else {
                    print("Successfully uploaded poop document")
                    //completion()
                }
            }
            
        } else { // already document, need to updateData
            
            FirebaseManager.shared.firestore.collection("poops").document(uid).updateData([
                "poops": FieldValue.arrayUnion([newPoopJSON])
            ]) { error in
                if let error = error {
                    //self.errorMessage = "Failed to upload poop document: \(error.localizedDescription)"
                    print("Failed to upload poop document: \(error.localizedDescription)")
                    return
                } else {
                    print("Successfully uploaded poop document")
                    //completion()
                }
            }
            
        }
        // just for current app session, once app is closed and open, number of poops will be fetched from firebase directly
        self.totalNumberOfPoops += 1
        // add the new poop object into allPoops array manually for this run
        allPoops.append(newPoop)
    }
    
}
