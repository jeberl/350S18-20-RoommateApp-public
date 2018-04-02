//
//  Notification.swift
//  Roommate App
//
//  Created by Elena Iaconis on 3/19/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation

struct Notification {
    
    var notificationID: String?
    var houseID: String
    var usersInvolved: [String]
    var timestamp: String
    var type: String
    var checked: Bool
    var description: String
    
    init(houseID: String, usersInvolved: [String], type: String, description: String) {
        self.notificationID = nil
        self.houseID = houseID
        self.usersInvolved = usersInvolved
        self.timestamp = DatabaseAccess.getInstance().getTimestampAsString()
        self.type = type
        self.checked = false // false upon constructing
        self.description = description
    }

    // Set id once chore is created and added to database
    mutating func setNotificationID(ID: String) {
        if notificationID == nil {
            self.notificationID = ID
        }
    }
    
    // Check and change visibility of notification
    mutating func setChecked() {
        self.checked = !self.checked
    }

}
