//
//  Poop.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/29/22.
//

import UIKit
import SwiftUI
import FirebaseFirestore
import Firebase

class Poop: Codable {
    
    //var timestamp: Date
    
    private var timestampDate: Date
    
    var timestamp: Timestamp { Timestamp(date: timestampDate) }
    
    var message: String
    
    
    //var duration: TimeInterval
    
    init(data: [String : Any]) {
        self.timestampDate = data["timestampDate"] as? Date ?? Date()
        self.message = data["message"] as? String ?? ""
    }
    
    init(timeTakenAt: Date, message: String) {
        self.timestampDate = timeTakenAt
        self.message = message
    }

    
}

class PoopDocument: Codable {
    
    var poopArray: [Poop]
    var totalPoops: Int
    
    init(data: [String:Any]) {
        
        self.poopArray = data["poops"] as? [Poop] ?? [Poop]()
        self.totalPoops = data["total_poops"] as? Int ?? 0
    }
    
    init(arr: [Poop], ct: Int) {
        self.poopArray = arr
        self.totalPoops = ct
    }
    
    enum CodingKeys: String, CodingKey {
        case poopArray = "poops"
        case totalPoops = "total_poops"
    }

}

extension PoopDocument {
    
}
