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
    var takeFromUID: String
    var giveToUID: String
    var houseID: String
    var timestamp: String
    var amount: Double
    var message: String
    
    init(takeFromUID: String, giveToUID: String, houseID: String, amount: Double, message: String) {
        self.giveToUID = giveToUID
        self.takeFromUID = takeFromUID
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
