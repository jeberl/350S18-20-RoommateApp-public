//
//  House.swift
//  Roommate App
//
//  Created by Elena Iaconis on 2/14/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct House {
    
    var houseID: String?
    var house_name: String
    var house_users: [String]
    var address : String
    let owner: String // unique user email
    var incompleteChores : [String]
    var completeChores : [String]
    var recent_charges: [String] // unique chargeIDs
    var recent_interactions: [String] // array of all uids for Notifs
    
    init(house_name: String, address: String, house_users:[String], owner: String, incompleteChores : [String], completeChores : [String], recent_charges: [String], recent_interactions:[String]) {
        self.houseID = nil
        self.address = address
        self.house_name = house_name
        self.house_users = house_users
        self.owner = owner
        self.incompleteChores = incompleteChores
        self.completeChores = completeChores
        self.recent_charges = recent_charges
        self.recent_interactions = recent_interactions
    }
    
    mutating func setHouseID(ID: String) {
        if houseID == nil {
            self.houseID = ID
        }
    }
    
    mutating func addUser(email: String) {
        self.house_users.append(email)
    }
    
    mutating func addChore(newChore : ChoreAJ) {
        let choreID = newChore.choreID!
        self.incompleteChores.append(choreID)
    }
    
    
}
