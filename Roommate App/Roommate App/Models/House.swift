//
//  House.swift
//  Roommate App
//
//  Created by Elena Iaconis on 2/14/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import CoreLocation
import Foundation
import Firebase
import FirebaseDatabase

struct House {
    
    var houseID: String?
    var houseName: String
    var houseUsers: [String]
    var address : String
    let owner: String // unique user email
    var incompleteChores : [String]
    var completeChores : [String]
    var recentCharges: [String] // unique chargeIDs
    var recentInteractions: [String] // array of all uids for Notifs
    
    init(houseName: String, address: String, houseUsers:[String], owner: String, incompleteChores : [String], completeChores : [String], recentCharges: [String], recentInteractions:[String]) {
        self.houseID = nil
        self.address = address
        self.houseName = houseName
        self.houseUsers = houseUsers
        self.owner = owner
        self.incompleteChores = incompleteChores
        self.completeChores = completeChores
        self.recentCharges = recentCharges
        self.recentInteractions = recentInteractions
    }
    
    mutating func setHouseID(ID: String) {
        if houseID == nil {
            self.houseID = ID
        }
    }
    
    mutating func addUser(email: String) {
        self.houseUsers.append(email)
    }
    
}
