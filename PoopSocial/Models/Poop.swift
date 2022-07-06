//
//  Poop.swift
//  PoopSocial
//
//  Created by Dakshin Devanand on 6/29/22.
//

import UIKit
import SwiftUI
import FirebaseFirestore

class Poop: Codable {
    
    //var timestamp: Date
    
    private var timestampDate: Date
    
    var timestamp: Timestamp { Timestamp(date: timestampDate) }
    
    
    //var duration: TimeInterval
    
    init(data: [String : Any]) {
        self.timestampDate = data["timestampDate"] as? Date ?? Date()
    }
    
    init(timeTakenAt: Date) {
        self.timestampDate = timeTakenAt
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
