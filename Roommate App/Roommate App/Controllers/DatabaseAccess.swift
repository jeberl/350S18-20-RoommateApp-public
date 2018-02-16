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
    
    var ref: DatabaseReference!
    
    init(){
        ref = Database.database().reference(withPath: "haus-party")
        
        // Add some sort of authetication here through fire base
//        Each instance of DatabaseAccess is from a specific user and the data base manages the permissions of the user. To access the data base you create an instance and log in as that specific user
    }
    
    deinit {

    }
    
    //PUBLIC FUNCTIONS TO BE USED BY OTHER CLASSES
    func createUser(email: String, password:String) -> Error? {
        //Check if email already associated with account -> Error


        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            // ...
        }
    }
    
    func deleteUserAccount(email: String) -> ReturnValue<Bool> {
        //TO BE IMPLEMENTED
    }
    
    func doesUserExist(email: String) -> Bool {
        return true
        //TO BE IMPLEMENTED
    }
    
    func getUserGlobalNickname(email: String) -> ReturnValue<String> {
        //TO BE IMPLEMENTED
    }
    
    func setUserGlobalNickname(currUser: User, newNickName: String) -> ReturnValue<Any> {
        self.ref.child("users/\(currUser.uid)/nickname").setValue(newNickName)
    }
    
    func getUserLocalNickname(currUser: User, house: House) -> ReturnValue<String> {
        //return ReturnValue<String>(error: false, data: "Jesse")
        //TO BE IMPLEMENTED
    }
    
    func setUserLocalNickname(currUser: User, house: House, newNickName: String) -> ReturnValue<Any>{
        //TO BE IMPLEMENTED
    }
    
    func signInUser(email: String, password:String) -> Error {
        //Check if email not associated with account -> Error(prompt to create account)
        //Return error from Firebase Authentication
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
        }
    }
    
    func changePasword(currUser: User, new_password: String) {
        self.ref.child("users/\(currUser.uid)/password").setValue(new_password)
    }
    
    func addUserToHouse(email: String, HouseID: String) {
        let new_user = self.ref.child("houses/\(HouseID)/house_users/\(email)")
        new_user.setValue(email);
    }
    
    func removeUserFromHouse(email: String, HouseID: String) {
        let user_to_remove = self.ref.child("houses/\(HouseID)/house_users/\(email)")
        user_to_remove.removeValue()
    }
    

    
    func getListOfHousesUserMemberOf(email: String) {
        // TO BE IMPLEMENTED
    }
    
    func getUserPhoneNumber(email: String) {
        // TO BE IMPLEMENTED
    }
    
    func deleteHouse(HouseID: String) {
        // TO BE IMPLEMENTED
    }
    
    func createHouse(newHouse: House) {
        ref = Database.database().reference()
        self.ref.child("houses").child(newHouse.uid).setValue(["house_name": newHouse.house_name,
                                                               "house_users": newHouse.house_users,
                                                               "owner": newHouse.owner,
                                                               "recent_charges": newHouse.recent_charges])
    }
    
    func changeHouseName(currHouse : House, new_name: String) {
        self.ref.child("houses/\(currHouse.uid)/house_name").setValue(new_name)
    }
    
    func getListOfUsersInHouse(HouseID: String)-> [String] {
        var users: [String] = []
        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                users = value?["users"] as? [String] ?? []
            }
        })
        return users
    }
    
    func isUserOwnerOfHouse(HouseID: String)-> Bool {
        return (getOwnerOfHouse(HouseID: HouseID) == Auth.auth().currentUser?.uid)
    }
    
    func getOwnerOfHouse(HouseID: String)-> String? {
        var owner: String? = ""
        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                owner = value?["owner"] as? String ?? ""
            }
        })
        return owner
    }
    
//    // Unsure about storing as array, should probably modify for scalability so don't have to retrieve append and update.
//    // look into handling lists of data
//    func addNotification(notification: String, houseID: String, users_to_notify: [String]) {
//        var recent_inters = getMostRecentNotifications(HouseID: houseID, n: 10) // dummy n value
//        recent_inters.append(notification)
//        self.ref.child("houses/\(houseID)/recent_charges").setValue(recent_inters)
//    }
//
//    //TODO: account for n
//    func getMostRecentNotifications(HouseID: String, n: Int)-> [String] {
//        var recent_inters: [String] = ""
//        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            if snapshot.exists(){
//                let value = snapshot.value as? NSDictionary
//                recent_inters = value?["recent_charges"] as? [String] ?? []
//            }
//        })
//        return recent_inters
//    }
//
//    func userAddCharge(chargeID: String) {
//        var curr_chars = getCharges(HouseID: houseID) // dummy n value
//        // TODO create charge type potentially?
//        var newCharge
//        curr_charss.append(newCharge)
//        self.ref.child("houses/\(houseID)/recent_charges").setValue(curr_chars)
//    }
//    
//    func getCharges(HouseID: String)-> [String] {
//        var charges: [String] = ""
//        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            if snapshot.exists(){
//                let value = snapshot.value as? NSDictionary
//                charges = value?["recent_charges"] as? [String] ?? []
//            }
//        })
//        return charges
//    }
//    
//    
//    func addCharge(amount: String, userTo: String, userFrom: String, houseID: String) {
//        // TO BE IMPLEMENTED
//    }
//
//    func getBalanceBetweenUsers(HouseID: String, User1Email: String, User2Email: String) {
//        // TO BE IMPLEMENTED
//    }

    
}
