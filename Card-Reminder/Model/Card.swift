//
//  Card.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 23/05/1443 AH.
//

import Foundation
import Firebase
struct Card {
    
var id = ""
var imageUrl = ""
var startDate = ""
var ExpiryDate = ""
var type = ""
var userId = ""
var createdAt:Timestamp?
    
    
    init(dict:[String:Any],id:String,user:User) {
        if let startDate = dict["startDate"] as? String,
           let ExpiryDate = dict["ExpiryDate"] as? String,
           let imageUrl = dict["imageUrl"] as? String,
            let createdAt = dict["createdAt"] as? Timestamp {
            self.startDate = startDate
            self.ExpiryDate = ExpiryDate
            self.imageUrl = imageUrl
            self.createdAt = createdAt
        }
        self.id = id
       // self.user = user
    }
    
     init(id: String = "", imageUrl: String = "", startDate: String = "", ExpiryDate: String = "", type: String = "", userId: String, createdAt: Timestamp? = nil) {
        self.id = id
        self.imageUrl = imageUrl
        self.startDate = startDate
        self.ExpiryDate = ExpiryDate
        self.type = type
        self.userId = userId
        self.createdAt = createdAt
    }
}

