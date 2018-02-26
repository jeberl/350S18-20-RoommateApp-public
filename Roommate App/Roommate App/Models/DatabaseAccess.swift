//
//  Database.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 2/14/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
import UIKit

import Firebase
import FirebaseDatabase
import FirebaseAuthUI


var configured : Bool = false

class DatabaseAccess  {
    
    static var instance: DatabaseAccess? = nil
    
    var ref: DatabaseReference!
    var error_logging_in: Error? = nil
    
    private init(){
        if !configured {
            FirebaseApp.configure()
            configured = true
            ref = Database.database().reference()
        }
    }
    
    public static func getInstance() -> DatabaseAccess {
        if instance == nil {
            instance = DatabaseAccess()
        }
        return instance!
    }
    
    deinit {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    func createAccount(username: String, password: String, view: UIViewController){
        print("creating user")
        Auth.auth().createUser(withEmail: username, password: password)
        { user, error in
            if error != nil {
                print("error creating user \(error.debugDescription)")
                self.create_account_error(error: error!, view: view)
            } else if user != nil {
                self.createUserModelForCurrentUser()
                self.ok_account_creation(view: view)
            }
            
        }
    }
    
    func login(username: String, password: String, view: UIViewController){
        print("loging in: \(username) , \(password)")
        Auth.auth().signIn(withEmail: username, password: password) { user, error in
            if error != nil {
                print("error logging in: \(error.debugDescription)")
                self.login_error(error: error!, view: view)
            } else if user != nil {
                view.performSegue(withIdentifier: "log_in", sender: view)
            }
        }
    }
    
    private func ok_account_creation(view: UIViewController) {
        let alert = UIAlertController(title: "Account Created",
                                      message: "Please login" ,
                                      preferredStyle: .alert)
        present_popup(alert: alert, view: view, return_to_login: false)
    }
    
    private func create_account_error(error: Error, view: UIViewController) {
        let alert = UIAlertController(title: "Account Creation Error",
                                      message: error.localizedDescription ,
                                      preferredStyle: .alert)
        present_popup(alert: alert, view: view, return_to_login: false)
    }
    
    private func login_error(error: Error, view: UIViewController) {
        let alert = UIAlertController(title: "Login Error",
                                      message: error.localizedDescription ,
                                      preferredStyle: .alert)
        present_popup(alert: alert, view: view, return_to_login: false)
    }
    
    
    private func present_popup(alert: UIAlertController, view: UIViewController, return_to_login: Bool) {
        
        let returnAction = UIAlertAction(title:"Login Again",
                                         style: .default,
                                         handler:  { action in view.performSegue(withIdentifier: "loginErrorSegue", sender: self) })
        
        let continueAction = UIAlertAction(title: "Continue",
                                           style: .default)
        
        alert.addAction(return_to_login ? returnAction : continueAction)
        view.present(alert, animated: true, completion: nil)
    }


    //PUBLIC FUNCTIONS TO BE USED BY OTHER CLASSES
    private func createUserModelForCurrentUser(){
        if let uid : String = Auth.auth().currentUser?.uid {
            print("adding user to db")
            let user : [String: Any?] = ["uid" : Auth.auth().currentUser!.uid,
                                         "email" : Auth.auth().currentUser!.email,
                                         "nickname": Auth.auth().currentUser!.email,
                                         "phone_number": nil,
                                         "houses": []]
            self.ref.child("users/\(uid)").setValue(user)
            print("added user")
        } else {
            print("Error adding user to db: User Not Found")
            self.error_logging_in = NoSuchUserError<Bool>() as Error
        }
    }
    
    func getUserModelFromCurrentUser(callback: @escaping (_ user: UserAccount)->Void) -> ReturnValue<Bool> {
        var retValue: ReturnValue<Bool> = ExpectedExecution()
        if let uid : String = Auth.auth().currentUser?.uid {
            print("getting user from local db: \(uid)")
            self.ref.child("users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                print("found user in db")
                let value = snapshot.value as? NSDictionary
                callback(UserAccount(dict : value!))

            }) { (error) in
                print("couldent find user in db")
                retValue = ReturnValue(error: true, error_message: error.localizedDescription)
            }
            return retValue
        } else {
            return NoSuchUserError()
        }
    }
    
    func changePasword(new_password: String) -> ReturnValue<Bool>{
        //Use Auth.auth()
        return UnimplementedFunctionError()
    }
    
    func deleteUserAccount() -> ReturnValue<Bool> {
        if let email : String = Auth.auth().currentUser!.email {
            let user : DatabaseReference = self.ref.child("users/\(email)")
            
            let house_enumerator = (user.value(forKey: "houses") as? NSDictionary)?.keyEnumerator()
            while let HouseId = house_enumerator?.nextObject() {
                self.ref.child("houses/\(HouseId)/house_users/\(email)").removeValue()
            }
            
            user.removeValue()
            let FIRuser = Auth.auth().currentUser
            
            var delete_user_error : String = ""
            FIRuser?.delete { error in
                delete_user_error = error.debugDescription
            }
            
            if delete_user_error == nil {
                return ExpectedExecution()
            } else {
                return FirebaseError(error_message: delete_user_error)
            }
            
        }
        return NoSuchUserError()
    }
    
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
    
    

    
    func getListOfHousesUserMemberOf() -> ReturnValue<[String]>{
        let currEmail = Auth.auth().currentUser?.email
        var houses: [String] = []
        ref.child("users/\(currEmail!)").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if snapshot.exists(){
                let value = snapshot.value as? NSDictionary
                houses = value?["houses"] as? [String] ?? []
            }
        })
        return ReturnValue(error:false, data:houses)
    }
    
    func getUserPhoneNumber(curr_user: User)-> ReturnValue<Int?> {
        var phone_number: Int? = 0
        ref.child("users").child(curr_user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
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
        if !doesHouseExist(house_id: newHouse.houseID).data! {
            ref.child("houses").child(newHouse.houseID).setValue(["house_name": newHouse.house_name,
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
        if doesHouseExist(house_id: curr_house.houseID).data! {
            self.ref.child("houses/\(curr_house.houseID)/house_name").setValue(new_name)
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
