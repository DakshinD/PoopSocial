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
    
   /* if let asDouble = dictionary["timestamp"] as? Double {
        self.timestampDate = Date(timeIntervalSince1970: asDouble)
    } else {
        self.timestampDate = Date()
    }*/
    
    var timestamp: Timestamp { Timestamp(date: timestampDate) }
    //var duration: TimeInterval
    
    init(data: [String : Any]) {
        self.timestampDate = data["timestampDate"] as? Date ?? Date()
    }
    
    init(timeTakenAt: Date) {
        self.timestampDate = timeTakenAt
    }
    
}
