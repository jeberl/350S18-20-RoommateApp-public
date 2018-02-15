//
//  Database.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 2/14/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation

import Firebase
import FirebaseDatabase
import FirebaseAuthUI

class DatabaseAccess  {
    
    var data: DatabaseReference!
    
    init(){
        // Add some sort of authetication here through fire base
//        Each instance of DatabaseAccess is from a specific user and the data base manages the permissions of the user. To access the data base you create an instance and log in as that specific user
        
       
    }
    
    deinit {

    }
    
    
    
    //PUBLIC FUNCTIONS TO BE USED BY OTHER CLASSES
    // JESSE IMPLEMENTS
    func CreateUser(email: String) {
        // TO BE IMPLEMENTED
    }
    
    func ChangePasword(email: String, new_password: String) {
        // TO BE IMPLEMENTED
    }
    
    func AddUserToHouse(email: String, HouseID: String) {
        // TO BE IMPLEMENTED
    }
    
    func RemoveUserFromHouse(email: String, HouseID: String) {
        // TO BE IMPLEMENTED
    }
    
    func EditUserName(email: String, newNickName: String) {
        // TO BE IMPLEMENTED
    }
    
    func GetListOfHousesUserMemeberOf(email: String) {
        // TO BE IMPLEMENTED
    }
    
    func DeleteHouse(HouseID: String) {
        // TO BE IMPLEMENTED
    }
    
    func createHouse(HouseID: String) {
        // TO BE IMPLEMENTED
    }
    
    
    
    // ELENA IMPLEMENTS
    func GetListOfUsersInHouse(HouseID: String) {
        // TO BE IMPLEMENTED
    }
    
    func IsUserOwnerOfHouse(HouseID: String, UserEmail: String) {
        // TO BE IMPLEMENTED
    }
    
    func GetOwnerOfHouse(HouseID: String) {
        // TO BE IMPLEMENTED
    }
    
    func addNotification(notification: String, houseID: String, users_to_notify: [String]) {
        // TO BE IMPLEMENTED
    }
    
    func GetMostRecentNotifications(HouseID: String, n: Int) {
        // TO BE IMPLEMENTED
    }
    
    func AddCharge(amount: String, userTo: String, userFrom: String, houseID: String) {
        // TO BE IMPLEMENTED
    }
    
    func userAddCharge(chargeID: String) {
        // TO BE IMPLEMENTED
    }
    
    func GetBalanceBetweenUsers(HouseID: String, User1Email: String, User2Email: String) {
        // TO BE IMPLEMENTED
    }

    
}
