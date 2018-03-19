//
//  Chore.swift
//  Roommate App
//
//  Created by Elena Iaconis on 3/19/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Chore {
    
    let chore_ID: String
    let description: String
    let responsible_user: [String]
    let assignees: [String]
    let completed_not: String
    let house: String
    let time_create: NSDate
    let time_due: NSDate
    let time_comp: NSDate
    
    init(assignees: [String], description: String, responsible_user: String, completed_not: String, house: String, time_create: NSDate, time_due: NSDate, time_comp: NSDate, amount: Double) {
        self.chore_ID = nil
        self.description = description
        self.responsible_user = responsible_user
        self.assignees = assignees
        self.completed_not = completed_not
        self.house = house
        self.time_create = time_create
        self.time_due = time_due
        self.time_comp = time_comp
    }
    
    mutating func setChoreID(ID: String) {
        if chore_ID == nil {
            self.chore_ID = ID
        }
    }
    
}
