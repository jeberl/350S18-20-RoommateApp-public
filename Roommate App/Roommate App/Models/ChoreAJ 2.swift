//
//  Chore.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright 2018 Team 20. All rights reserved.
//
import Foundation

struct ChoreAJ {
    var choreID: String?
    var title: String
    var assignedBy: String
    var assigned_to: String
    var completed: Bool
    var timeAssigned: String
    var timeCompleted: String?
    var houseID: String
    var description: String
    
    init(choreTitle: String, assignor: String, assignee: String, houseID: String, description: String ){
        self.choreID = nil
        self.completed = false
        self.title = choreTitle
        self.assignedBy = assignor
        self.assigned_to = assignee
        self.timeAssigned = DatabaseAccess.getInstance().getTimestampAsString()
        self.timeCompleted = nil
        self.houseID = houseID
        self.description = description
    }
    
    mutating func setChoreID(ID: String) {
        if choreID == nil {
            self.choreID = ID
        }
    }
}
