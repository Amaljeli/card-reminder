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
var user:User
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
        self.user = user
    }
}

