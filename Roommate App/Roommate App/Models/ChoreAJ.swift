//
//  Chore.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation

struct ChoreAJ {
    var choreID: String?
    var title: String
    var assigned_by: String
    var assigned_to: String
    var completed: Bool
    var time_assigned: String
    var time_completed: String?
    var houseID: String
    var description: String
    
    init(chore_title: String, assignor: String, assignee: String, time_assigned: String, houseID: String, description: String ){
        self.choreID = nil
        self.completed = false
        self.title = chore_title
        self.assigned_by = assignor
        self.assigned_to = assignee
        self.time_assigned = time_assigned
        self.time_completed = nil
        self.houseID = houseID
        self.description = description
    }
    
    mutating func setChoreID(ID: String) {
        if choreID == nil {
            self.choreID = ID
        }
    }
}
