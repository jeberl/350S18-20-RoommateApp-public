//
//  Charge.swift
//  Roommate App
//
//  Created by Elena Iaconis on 2/14/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Charge {
    
    var chargeID: String?
    var from_user: String
    var to_user: String
    var houseID: String
    var timestamp: String
    //var amount: Double
    var amount: String
    var message: String
    
    init(from_user: String, to_user: String, houseID: String, timestamp: String, amount: String/* amount: Double*/, message: String) {
        self.to_user = to_user
        self.from_user = from_user
        self.houseID = houseID
        self.timestamp = timestamp
        self.amount = amount
        self.message = message
    }
    
    mutating func setChargeID(ID: String) {
        if chargeID == nil {
            self.chargeID = ID
        }
    }
}
