//
//  Chore.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
<<<<<<< HEAD
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
    
=======

struct Chore {
    var choreID: String?
    var title: String
    var assigned_by: String
    var assigned_to: String
    var completed: Bool
    var time_assigned: NSDate
    var time_completed: NSDate?
    var house: String
    var description: String
    
    init(chore_title: String, assignor: String, assignee: String, time_assigned: NSDate, house: String, description: String ){
        self.choreID = nil
        self.completed = false
        self.title = chore_title
        self.assigned_by = assignor
        self.assigned_to = assignee
        self.time_assigned = time_assigned
        self.time_completed = nil
        self.house = house
        self.description = description
    }
    
    mutating func setChoreID(ID: String) {
        if choreID == nil {
            self.choreID = ID
        }
    }
>>>>>>> b265635c4ab6f6b6c4bae618e747f4ea275daf31
}
