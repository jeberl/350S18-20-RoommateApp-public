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
    
    let uid: String // think this is just a Firebase specific thing, not sure
    let house_name: String
    let house_users: [String]
    let owner: String // unique userID
    let recent_charges: [String] // unique chargeIDs
    let recent_interactions: [String] // array of all uids for Notifs
    
    init(uid: String, house_name: String, house_users:[String], owner: String, recent_charges: [String], recent_interactions:[String]) {
        self.uid = uid
        self.house_name = house_name
        self.house_users = house_users
        self.owner = owner
        self.recent_charges = recent_charges
        self.recent_interactions = recent_interactions
    }
    
}
