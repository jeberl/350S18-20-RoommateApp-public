//
//  Notification.swift
//  Roommate App
//
//  Created by Elena Iaconis on 3/19/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation

struct Notification {
    
    var choreID: String?
    var houseID: String
    var houseName: String
    var usersInvolved: [String]
    var timestamp: NSDate
    var type: String
    var checked: Bool
    
    init(houseID: String, houseName: String, usersInvolved: [String], timestamp: NSDate, type: String) {
        self.choreID = nil
        self.houseID = houseID
        self.houseName = houseName
        self.usersInvolved = usersInvolved
        self.timestamp = timestamp
        self.type = type
        self.checked = false // false upon constructing
    }

    // Set id once chore is created and added to database
    mutating func setChoreID(ID: String) {
        if choreID == nil {
            self.choreID = ID
        }
    }
    
    // Check and change visibility of notification
    mutating func setChecked() {
        self.checked = !self.checked
    }

}
