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
    
    let uid: String // think this is just a Firebase specific thing, not sure
    let from_user: String
    let to_user: String
    let house: String
    let timestamp: NSDate
    let amount: Double
    
    init(uid: String, from_user: String, to_user: String, house: String, timestamp: NSDate, amount: Double) {
        self.uid = uid
        self.to_user = to_user
        self.from_user = from_user
        self.house = house
        self.timestamp = timestamp
        self.amount = amount
    }
    
}
