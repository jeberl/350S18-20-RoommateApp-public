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
<<<<<<< HEAD
        if !configured {
            FirebaseApp.configure()
            ref = Database.database().reference(withPath: "haus-party")
            configured = true
        }
        
        // Add some sort of authetication here through fire base
        // Each instance of DatabaseAccess is from a specific user and the data base manages the permissions of the user.
        // To access the data base you create an instance and log in as that specific user
=======
        FirebaseApp.configure()
        ref = Database.database().reference(withPath: "haus-party")
>>>>>>> Implement Database Functions
    }
    
    deinit {
        //Sign out???
    }
    
    func createUser(newUser: UserAccount)-> ReturnValue<Bool> {
        ref = Database.database().reference()
        ref.child("users").child(newUser.email).setValue(["email":newUser.email, "nickname": newUser.nickname, "houses": newUser.houses, "phoneNumber": newUser.phoneNumber])
        return ReturnValue(error: false, data: true)
    }

    //PUBLIC FUNCTIONS TO BE USED BY OTHER CLASSES
    func createUserModelForCurrentUser() -> ReturnValue<Bool> {
        if let email : String = Auth.auth().currentUser!.email {
            let user = self.ref.child("users/\(email)")
            user.setValue(email, forKey: "nickname")
            user.setValue(Auth.auth().currentUser!.uid, forKey: "firebase_uid")
            user.setValue(nil, forKey: "phone_number")
            user.setValue([], forKey: "houses")
            return ExpectedExecution()
        } else {
            return NoSuchUserError()
        }
    }
    
    func getUserModelFromCurrentUser() -> ReturnValue<UserAccount> {
        //Check if email not associated with account -> Error(prompt to create account)
        //Return error from Firebase Authentication
        if let currentUser = Auth.auth().currentUser {
            let email : String = currentUser.email!
            let userInLocalDB : DatabaseReference = self.ref.child("users/\(email)")
            let user : UserAccount = UserAccount(uid: currentUser.uid,
                                                 email: email,
                                                 nickname: userInLocalDB.value(forKey: "nickname") as! String,
                                                 houses: userInLocalDB.value(forKey: "houses") as! [String],
                                                 phoneNumber: (userInLocalDB.value(forKey: "phone_number") as! Int?)!)
            return ReturnValue<UserAccount>(error: false, data: user)
        } else {
            return NoSuchUserError()
        }
    }
    
<<<<<<< HEAD
    func changePasword(email: String, new_password: String) -> ReturnValue<Bool>{
=======
    func changePasword(new_password: String) -> ReturnValue<Bool>{
>>>>>>> Implement Database Functions
        //Use Auth.auth()
        return UnimplementedFunctionError()
    }
    
<<<<<<< HEAD
    func deleteUserAccount(email: String) -> ReturnValue<Bool> {
        if !doesUserExist(email: email).data! {
            return NoSuchUserError()
        }
        
        let user : DatabaseReference = self.ref.child("users/\(email)")
        
        let house_enumerator = (user.value(forKey: "houses") as? NSDictionary)?.keyEnumerator()
        while let HouseId = house_enumerator?.nextObject() {
            self.ref.child("houses/\(HouseId)/house_users/\(email)").removeValue()
=======
    func deleteUserAccount() -> ReturnValue<Bool> {
        if let email : String = Auth.auth().currentUser!.email {
            let user : DatabaseReference = self.ref.child("users/\(email)")
            
            let house_enumerator = (user.value(forKey: "houses") as? NSDictionary)?.keyEnumerator()
            while let HouseId = house_enumerator?.nextObject() {
                self.ref.child("houses/\(HouseId)/house_users/\(email)").removeValue()
            }
            
            user.removeValue()
            let FIRuser = Auth.auth().currentUser
            
            var delete_user_error : String?
            FIRuser?.delete { error in
                delete_user_error = error.debugDescription
            }
            
            if delete_user_error == nil {
                return ExpectedExecution()
            } else {
                return FirebaseError(error_message: delete_user_error)
            }
            
>>>>>>> Implement Database Functions
        }
        return NoSuchUserError()
    }
    
<<<<<<< HEAD
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
=======
    func getUserGlobalNickname() -> ReturnValue<String> {
        if let email : String = Auth.auth().currentUser!.email {
            return ReturnValue<String>(error: false,
                               data: self.ref.child("users/\(email)").value(forKey: "nickname") as? String)
        }
        return NoSuchUserError()
    }
    
    func setUserGlobalNickname(new_nickname: String) -> ReturnValue<Bool> {
        if let email : String = Auth.auth().currentUser!.email {
            self.ref.child("users/\(email)/nickname").setValue(new_nickname)
            return ExpectedExecution()
>>>>>>> Implement Database Functions
        }
        return NoSuchUserError()
    }
    
    func getUserLocalNickname(from_house house: House) -> ReturnValue<String> {
        if let email : String = Auth.auth().currentUser!.email {
            let house_users : DatabaseReference = self.ref.child("houses/\(house.houseID)/users")
            if let nickname : String = house_users.value(forKey: "\(email)") as? String {
                return ReturnValue<String>(error: false, data: nickname)
            }
            return UserNotMemberofHouseError()
        }
        return NoSuchUserError()
    }
    
    func setUserLocalNickname(in_house : House, to new_nickname: String) -> ReturnValue<Bool>{
        if let email : String = Auth.auth().currentUser!.email {
            let house_users : DatabaseReference = self.ref.child("houses/\(in_house.houseID)/users")
            if let _ : String = house_users.value(forKey: "\(email)") as? String {
                house_users.setValue(new_nickname, forKey: "\(email)")
                return ExpectedExecution()
            }
            return UserNotMemberofHouseError()
        }
        return NoSuchUserError()
    }
    
    //THIS DOES NOT CREATE A FIREBASE ACCOUNT FOR NEW USER IF ONE DOESNT EXIST
    //ONLY ADDS AN EMAIL TO THE HOUSE LIST OF USERS AND UPDATES USER PREFERENCES
    func addNewUserToHouseUsers(with_email email: String, to_house house_id: String) -> ReturnValue<Bool> {
        let house : DatabaseReference = self.ref.child("houses/\(house_id)")
        if var house_users : [String: String] = house.value(forKey: "users") as? [String: String] {
            if let currentUserEmail : String = Auth.auth().currentUser!.email {
                if house_users.keys.contains(currentUserEmail) {
                    
                    //Add user to house's list of users
                    house_users[email] = email
                    house.setValue(house_users, forKey: "users")
                    
                    
                    //Remove house from user list of houses
                    var users_houses : [String: Bool] = self.ref.child("users/\(email)").value(forKey: "houses") as! [String: Bool]
                    users_houses[house_id] = true
                    self.ref.child("users/\(email)").setValue(users_houses, forKey: "houses")
                    return ExpectedExecution()
                } else {
                    return UserNotMemberofHouseError()
                }
            } else {
                return NoSuchUserError()
            }
        } else {
            return NoSuchHouseError()
        }
    }
    
    //Only the owner of a house or the user himself may remove a user from a house
    func removeUserFromHouse(email_to_remove: String, house_id: String) -> ReturnValue<Bool> {
        let house : DatabaseReference = self.ref.child("houses/\(house_id)")
        if var house_users : [String: String] = house.value(forKey: "users") as? [String: String] {
            if let currentUserEmail : String = Auth.auth().currentUser!.email {
                if currentUserEmail == email_to_remove || currentUserEmail == house.value(forKey: "owner") as? String {
                    if house_users.keys.contains(currentUserEmail) {
                        
                        //Remove user from house's list of users
                        house_users.removeValue(forKey: email_to_remove)
                        house.setValue(house_users, forKey: "users")
                        
                        //Remove house from user list of houses
                        var users_houses : [String: Bool] = self.ref.child("users/\(email_to_remove)").value(forKey: "houses") as! [String: Bool]
                        users_houses.removeValue(forKey: house_id)
                        self.ref.child("users/\(email_to_remove)").setValue(users_houses, forKey: "houses")
                        return ExpectedExecution()
                    } else {
                        return UserNotMemberofHouseError()
                    }
                } else {
                    return UserNotOwnerOfHouseError()
                }
            } else {
                return NoSuchUserError()
            }
        } else {
            return NoSuchHouseError()
        }
    }
    
<<<<<<< HEAD
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
=======
    

>>>>>>> Implement Database Functions
    
    /*func getListOfHousesUserMemberOf(email: String) -> [String]?{
        //let currEmail = Auth.auth().currentUser?.email
        var houses: [String] = []
<<<<<<< HEAD
        ref = Database.database().reference()
        let group = DispatchGroup()
        group.enter()
        ref.child("users").child("me@emailcom").observeSingleEvent(of: .value, with: { (snapshot) in
=======
        ref.child("users/\(currEmail!)").observeSingleEvent(of: .value, with: { (snapshot) in
>>>>>>> Implement Database Functions
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
<<<<<<< HEAD
        if !doesHouseExist(house_id: newHouse.house_id).data! {
            ref.child("houses").child(newHouse.house_id).setValue(["house_name": newHouse.house_name,
=======
        if !doesHouseExist(house_id: newHouse.houseID).data! {
            ref.child("houses").child(newHouse.houseID).setValue(["house_name": newHouse.house_name,
>>>>>>> Implement Database Functions
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
<<<<<<< HEAD
        if doesHouseExist(house_id: curr_house.house_id).data! {
            self.ref.child("houses/\(curr_house.house_id)/house_name").setValue(new_name)
=======
        if doesHouseExist(house_id: curr_house.houseID).data! {
            self.ref.child("houses/\(curr_house.houseID)/house_name").setValue(new_name)
>>>>>>> Implement Database Functions
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
