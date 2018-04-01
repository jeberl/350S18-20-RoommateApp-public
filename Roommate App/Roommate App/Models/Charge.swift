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
    
<<<<<<< HEAD
    init(fromUser: String, toUser: String, houseID: String, timestamp: String, amount: String/* amount: Double*/, message: String) {
        self.toUser = toUser
        self.fromUser = fromUser
=======
    init(from_user: String, to_user: String, houseID: String, timestamp: String, amount: Double, message: String) {
        self.to_user = to_user
        self.from_user = from_user
>>>>>>> cca65338446c32cd6359fa8970d28ab3633ccbe8
        self.houseID = houseID
        self.timestamp = timestamp
        self.amount = amount
        self.message = message
    }
    
    func setChargeID(ID: String) {
        if chargeID == nil {
            self.chargeID = ID
        }
    }
}
