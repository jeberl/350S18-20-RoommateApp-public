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

var configured : Bool = false

class DatabaseAccess  {
    
    var ref: DatabaseReference!
    
    init(){
        if !configured {
            FirebaseApp.configure()
            ref = Database.database().reference(withPath: "haus-party")
            configured = true
        }
        
        // Add some sort of authetication here through fire base
        // Each instance of DatabaseAccess is from a specific user and the data base manages the permissions of the user.
        // To access the data base you create an instance and log in as that specific user
    }
    
    
    deinit {
        
    }
    
    func createUser(newUser: UserAccount)-> ReturnValue<Bool> {
        ref = Database.database().reference()
        ref.child("users").child(newUser.email).setValue(["email":newUser.email, "nickname": newUser.nickname, "houses": newUser.houses, "phoneNumber": newUser.phoneNumber])
        return ReturnValue(error: false, data: true)
    }

    //PUBLIC FUNCTIONS TO BE USED BY OTHER CLASSES
    func createUserModelFromEmail(email: String) -> ReturnValue<Bool> {
        //Check if email already associated with account -> Error
        if !doesUserExist(email: email).data! {
            return NoSuchUserError()
        }

        return UnimplementedFunctionError()
    }
    
    func getUserModelFromEmail(email: String) -> ReturnValue<UserAccount> {
        //Check if email not associated with account -> Error(prompt to create account)
        //Return error from Firebase Authentication
        
        return UnimplementedFunctionError()
    }
    
    func changePasword(email: String, new_password: String) -> ReturnValue<Bool>{
        //Use Auth.auth()
        return UnimplementedFunctionError()
    }
    
    func deleteUserAccount(email: String) -> ReturnValue<Bool> {
        if !doesUserExist(email: email).data! {
            return NoSuchUserError()
        }
        
        let user : DatabaseReference = self.ref.child("users/\(email)")
        
        let house_enumerator = (user.value(forKey: "houses") as? NSDictionary)?.keyEnumerator()
        while let HouseId = house_enumerator?.nextObject() {
            self.ref.child("houses/\(HouseId)/house_users/\(email)").removeValue()
        }

        user.removeValue()
        
        //Still need to remove authorization
        return UnimplementedFunctionError()
    }
    
    func doesUserExist(email: String) -> ReturnValue<Bool> {
        var result: Bool = false
        ref.child("users").child(email).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                result = true
            }
        })
        return ReturnValue(error:false, data: result)
    }
    
    func getUserGlobalNickname(email: String) -> ReturnValue<String> {
        var nickname: String = ""
        if !doesUserExist(email: email).data! {
            return NoSuchUserError()
        } else {
            ref.child("users").child(email).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if snapshot.exists(){
                    let value = snapshot.value as? NSDictionary
                    nickname = value?["nickname"] as? String! ?? nil
                }
            })
        }
        return ReturnValue(error: false, data:nickname)
    }
    
    func setUserGlobalNickname(email: String, newNickName: String) -> ReturnValue<Bool> {
        if !doesUserExist(email: email).data! {
            return NoSuchUserError()
        }
        self.ref.child("users/\(email)/nickname").setValue(newNickName)
        return ExpectedExecution()
    }
    
    func getUserLocalNickname(currUser: User, house: House) -> ReturnValue<String> {
        //TO BE IMPLEMENTED
        return UnimplementedFunctionError()
    }
    
    func setUserLocalNickname(currUser: User, house: House, newNickName: String) -> ReturnValue<Bool>{
        //TO BE IMPLEMENTED
        return UnimplementedFunctionError()
    }
    
    func addUserToHouse(email: String, HouseID: String) {
        let new_user = self.ref.child("houses/\(HouseID)/house_users/\(email)")
        new_user.setValue(email);
    }
    
    func removeUserFromHouse(email: String, house_id: String)-> ReturnValue<Bool> {
        if doesHouseExist(house_id: house_id).data! {
            let user_to_remove = self.ref.child("houses/\(house_id)/house_users/\(email)")
            user_to_remove.removeValue()
            return ReturnValue(error: false, data: true)
        } else {
            return ReturnValue(error: true, data: false, error_number: 20)
        }
    }
    
    func getListOfHousesUserMemberOf(email: String, callback: @escaping (_ houses: [String])->Void){
        var houses: [String] = []
        ref = Database.database().reference()
        ref.child("users").child("me@emailcom").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            if snapshot.exists(){
                let snapshotValue = snapshot.value as? NSDictionary
                houses = (snapshotValue?["houses"] as? [String])!
            }
            callback(houses)
        })
    }
    
    /*func getListOfHousesUserMemberOf(email: String) -> [String]?{
        //let currEmail = Auth.auth().currentUser?.email
        var houses: [String] = []
        ref = Database.database().reference()
        let group = DispatchGroup()
        group.enter()
        ref.child("users").child("me@emailcom").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                let snapshotValue = snapshot.value as? NSDictionary
                houses = (snapshotValue?["houses"] as? [String])!
                group.leave()
            }
        })
        return houses
    }*/
    
    func getUserPhoneNumber(email: String)-> ReturnValue<Int?> {
        var phone_number: Int? = 0
        ref.child("users").child(email).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                phone_number = value?["phone_number"] as? Int? ?? 0
            }
        })
        return ReturnValue(error: false, data: phone_number)
    }
    
    func deleteHouse(houseID: String)-> ReturnValue<Bool> {
        ref = Database.database().reference()
        ref.child("houses").child(houseID).setValue(nil)
        return ExpectedExecution()
    }
    
    // returns true if a house was created, false if the house already exists
    func createHouse(newHouse: House)-> ReturnValue<Bool> {
        ref = Database.database().reference()
        if !doesHouseExist(house_id: newHouse.uid).data! {
            ref.child("houses").child(newHouse.uid).setValue(["house_name": newHouse.house_name,
                                                               "house_users": newHouse.house_users,
                                                               "owner": newHouse.owner,
                                                               "recent_charges": newHouse.recent_charges])
        } else {
            return ReturnValue(error: false, data: false)
        }
        return ReturnValue(error: false, data: true)
    }
    
    
    func doesHouseExist(house_id: String)-> ReturnValue<Bool> {
        var result: Bool = false
        ref.child("houses").child(house_id).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                result = true
            } 
        })
        return ReturnValue(error:false, data: result)
    }
    
    // Updates house name if it exists and returns true, otherwise returns appropriate error and false
    func changeHouseName(curr_house : House, new_name: String)-> ReturnValue<Bool> {
        if doesHouseExist(house_id: curr_house.uid).data! {
            self.ref.child("houses/\(curr_house.uid)/house_name").setValue(new_name)
            return ReturnValue(error: false, data: true)
        }
        return ReturnValue(error: true, data: false, error_number: 20)
    }
    
    func getListOfUsersInHouse(HouseID: String)-> ReturnValue<[String]> {
        var users: [String] = []
        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                users = value?["users"] as? [String] ?? []
            }
        })
        return ReturnValue(error:false, data: users)
    }
    
    // Checks if house exists and returns if user is owner, otherwise returns false and appropriate error
    func isUserOwnerOfHouse(house_id: String)-> ReturnValue<Bool> {
        if doesHouseExist(house_id: house_id).data! {
            let result = (getOwnerOfHouse(HouseID: house_id).data! == Auth.auth().currentUser?.uid)
            return ReturnValue(error: false, data: result)
        }
        return ReturnValue(error: false, data: false, error_number: 20)
    }
    
    func getOwnerOfHouse(HouseID: String)-> ReturnValue<String?> {
        var owner: String? = ""
        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                owner = value?["owner"] as? String ?? ""
            }
        })
        return ReturnValue(error: false, data: owner)
    }
    
    // Unsure about storing as array, should probably modify for scalability so don't have to retrieve append and update.
    // look into handling lists of data
    func addNotification(notification: String, houseID: String, users_to_notify: [String]) {
        var recent_inters = getMostRecentNotifications(HouseID: houseID, n: 10) // dummy n value
        recent_inters.append(notification)
        self.ref.child("houses/\(houseID)/recent_charges").setValue(recent_inters)
    }

    //TODO: account for n
    func getMostRecentNotifications(HouseID: String, n: Int)-> [String] {
        var recent_inters: [String] = []
        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                recent_inters = value?["recent_charges"] as? [String] ?? []
            }
        })
        return recent_inters
    }

    func userAddCharge(chargeID: String) {
        //var curr_chars = getCharges(HouseID: houseID) // dummy n value
        // TODO create charge type potentially?
        //var newCharge
        //curr_chars.append(newCharge)
        //self.ref.child("houses/\(houseID)/recent_charges").setValue(curr_chars)
    }
    
    func getCharges(HouseID: String)-> [String] {
        var charges: [String] = []
        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                charges = value?["recent_charges"] as? [String] ?? []
            }
        })
        return charges
    }
    
    
    func addCharge(amount: String, userTo: String, userFrom: String, houseID: String) {
        // TO BE IMPLEMENTED
    }

    func getBalanceBetweenUsers(HouseID: String, User1Email: String, User2Email: String) {
        // TO BE IMPLEMENTED
    }

    
}
