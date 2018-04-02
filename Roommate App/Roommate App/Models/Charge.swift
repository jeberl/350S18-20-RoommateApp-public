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

class Charge {
    
    var chargeID: String?
    var fromUser: String
    var toUser: String
    var houseID: String
    var timestamp: String
    var amount: Double
    var message: String
    
    init(fromUser: String, toUser: String, houseID: String, amount: Double, message: String) {
        self.toUser = toUser
        self.fromUser = fromUser
        self.houseID = houseID
        self.timestamp = DatabaseAccess.getInstance().getTimestampAsString()
        self.amount = amount
        self.message = message
    }
    
    func setChargeID(ID: String) {
        if chargeID == nil {
            self.chargeID = ID 
        }
    }
}
