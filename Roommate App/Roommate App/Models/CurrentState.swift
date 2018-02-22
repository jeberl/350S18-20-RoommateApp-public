//
//  CurrentState.swift
//  Roommate App
//
//  Created by Nick Buckenham on 2/22/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation

// this struct acts as a global variable, storing the current user and the current house that the user is viewing
struct CurrentState {
    
    var currentUser: UserAccount
    var currentHouse: House
    
    init(currentUser: UserAccount, currentHouse: House) {
        self.currentUser = currentUser
        self.currentHouse = currentHouse
    }
    
    // sets a new current user
    mutating func setCurrentUser(newUser: UserAccount) {
        self.currentUser = newUser
    }
    
    // sets a new current house
    mutating func setCurrentHouse(newHouse: House) {
        self.currentHouse = newHouse
    }
    
}
