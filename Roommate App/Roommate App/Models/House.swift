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
    let owner: String // unique user email
    var recent_charges: [String] // unique chargeIDs
    var recent_interactions: [String] // array of all uids for Notifs
    
    init(house_name: String, house_users:[String], owner: String, recent_charges: [String], recent_interactions:[String]) {
        self.houseID = nil
        self.house_name = house_name
        self.house_users = house_users
        self.owner = owner
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
    
}
