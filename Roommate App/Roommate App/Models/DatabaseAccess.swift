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

class DatabaseAccess  {
    
    static var instance: DatabaseAccess? = nil
    
    var ref: DatabaseReference!
    var error_logging_in: Error? = nil
    
    private init(){
        FirebaseApp.configure()
        ref = Database.database().reference()
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
    
    func createAccount(username: String, password: String, view: UIViewController?){
        print("creating user")
        Auth.auth().createUser(withEmail: username, password: password)
        { user, error in
            print("created user \(user) with error \(error)")
            if error != nil {
                print("error creating user \(error.debugDescription)")
                if view != nil {
                    self.create_account_error(error: error!, view: view!)
                }
            } else if user != nil {
                self.createUserModelForCurrentUser()
                if view != nil {
                    self.ok_account_creation(view: view!)
                }
            }
        }
    }
    
    func login(username: String, password: String, view: UIViewController?){
        print("loging in: \(username) , \(password)")
        Auth.auth().signIn(withEmail: username, password: password) { user, error in
            if error != nil {
                print("error logging in: \(error.debugDescription)")
                if view != nil {
                    self.login_error(error: error!, view: view!)
                }
            } else if user != nil {
                if view != nil {
                    view?.performSegue(withIdentifier: "log_in", sender: view!) 
                }
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
    
    private func database_error(_ error: Error? = nil, error_header: String = "Error", view: UIViewController) {
        let alert = UIAlertController(title: error_header,
                                      message: error?.localizedDescription ,
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

    // creates user in database, automatically adds them to houses their email has been associated with
    // before account creation
    private func createUserModelForCurrentUser(){
        if let email : String = Auth.auth().currentUser?.email {
            //Check if email is already been added to houses
            let formattedEmail = reformatEmail(email: email)
            let uid = Auth.auth().currentUser!.uid
            // update known set values of field properly
            self.ref.child("user_emails/\(formattedEmail)/created").setValue(true)
            self.ref.child("user_emails/\(formattedEmail)/uid").setValue(uid)
            self.ref.child("user_emails/\(formattedEmail)").observe(.value, with: { (snapshot) in
                var user : [String: Any?] = ["uid" : uid,
                                            "email" : email,
                                            "formattedEmail" : formattedEmail,
                                            "nickname": email,
                                            "phone_number": nil]
                self.ref.child("users/\(uid)").setValue(user)
                // check if there are are any previously inserted houses, update user model
                if snapshot.hasChild("houses") {
                    self.ref.child("user_emails/\(formattedEmail)/houses").observe(.value, with: { (snapshot) in
                        for houseID in (snapshot.value as? NSDictionary)!.allKeys {
                            self.ref.child("users/\(uid)/houses/\(houseID)").setValue(true)
                        }
                    })
                } else {
                    print("User has not been added to any houses")
                }
            })
        } else {
            print("Error adding user to db: User Not Found")
            self.error_logging_in = NoSuchUserError<Bool>() as Error
        }
    }
    
    func getUserModelFromCurrentUser(view: UIViewController, callback: @escaping (_ user: UserAccount)->Void) -> ReturnValue<Bool> {
        if let uid : String = Auth.auth().currentUser?.uid {
            print("getting user from local db: \(uid)")
            self.ref.child("users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    print("found user in db")
                    let value = snapshot.value as? NSDictionary
                    callback(UserAccount(dict : value!))
                } else {
                    print("couldnt find user in db")
                    self.database_error(error_header: "Error: Couldnt find User", view: view)
                }
            })
            return ExpectedExecution()
        } else {
            return NoSuchUserError()
        }
    }
    
    func changePassword(new_password: String) -> ReturnValue<Bool>{
        //Use Auth.auth()
        return UnimplementedFunctionError()
    }
    
    //I DONT THINK THIS WORKS - TEST!!
    func deleteUserAccount(view: UIViewController) -> ReturnValue<Bool> {
        if let uid = Auth.auth().currentUser?.uid {
            let user : DatabaseReference = self.ref.child("users/\(uid)")
            
            // Remove User from associated houses
            user.child("houses").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for houseID in snapshot.children {
                        self.ref.child("houses/\(houseID as! String)/house_users/\(uid)").removeValue()
                    }
                }
            })
            
            //Remove User from database
            user.removeValue()
            
            //Remove User Authentication
            Auth.auth().currentUser?.delete { error in
                if error != nil {
                    print(error!.localizedDescription)
                    self.database_error(error!, error_header: "Error: Could not delete user", view: view)
                }
            }
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    

    func getUserGlobalNickname(for_email: String, callback : @escaping (String?) -> Void){
        let name_callback : (DataSnapshot) -> Void = { (uid) in
            self.getUserGlobalNickname(for_uid: (uid.value as! String), callback: callback)
        }
        let formattedEmail = reformatEmail(email: for_email)
        self.ref.child("user_emails/\(formattedEmail)/uid").observe(.value, with: name_callback)
    }
    
    func getUserGlobalNickname(for_uid: String?, callback : @escaping (String?) -> Void) -> ReturnValue<Bool> {
        //Check specific uid was given if not return for current user
        var uid = for_uid
        if uid == nil {
            uid = Auth.auth().currentUser?.uid
        }
        if uid != nil  {
            //Navigate to the user nickname field and get a "Snapshot" of the data stored there
            self.ref.child("users/\(uid!)/nickname").observe(.value, with: { (snapshot) in
                //This is the closure where we say what to do with the given snapshot which in this case is the nickname
                
                // We check if the snapshot exists ie. is there data stored there
                if snapshot.exists() {
                    // Get the value of the snapshot (cast to string) and store as nickname
                    if let nickname = snapshot.value as? String {
                        //Run the function, callback, which is given by the frontend, passing it the nickname we read from the snapshot as an argument
                        callback(nickname)
                    } else {
                        // If cast coulnt occur no nickname found, run  callback with nil
                        print("Nickname not found")
                        callback(nil)
                    }
                } else {
                    // If no snapshot then no user, run the callback with nil
                    print("User not found")
                    callback(nil)
                }
            })
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    
    func setUserGlobalNickname(new_nickname: String) -> ReturnValue<Bool> {
        //Check if user is logged in
        if let uid : String = Auth.auth().currentUser?.uid {
            // Setting value does not require closures and can be done dicrectly to the DatabaseReferecece returned by .child() function
            self.ref.child("users/\(uid)/nickname").setValue(new_nickname)
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    
    func getUserLocalNickname(from_house house: House, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        if let uid : String = Auth.auth().currentUser?.uid {
            self.ref.child("houses/\(house.houseID)/house_users").observe(.value, with: { (snapshot) in
                if snapshot.exists() && snapshot.hasChild(uid) {
                    let nickname = snapshot.childSnapshot(forPath: "\(uid)/nickname").value as? String
                    callback(nickname)
                } else {
                    //return nil if house not found or user not member of house
                    callback(nil)
                }
            })
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    
    func getUserLocalNickname(from_houseID houseID: String?, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        if let uid : String = Auth.auth().currentUser?.uid {
            self.ref.child("houses/\(houseID!)/house_users").observe(.value, with: { (snapshot) in
                if snapshot.exists() && snapshot.hasChild(uid) {
                    let nickname = snapshot.childSnapshot(forPath: "\(uid)/nickname").value as? String
                    callback(nickname)
                } else {
                    //return nil if house not found or user not member of house
                    callback(nil)
                }
            })
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    
    func setUserLocalNickname(in_house : House, to new_nickname: String, view: UIViewController) -> ReturnValue<Bool>{
        if let hId = in_house.houseID {
            return setUserLocalNickname(inHouseID : hId, to: new_nickname, view: view)
        }
        return NoSuchHouseError()
    } 
    
    // TODO, this is causing a key value coding-compliant issue, NSUnknownKeyException
    func setUserLocalNickname(inHouseID : String, to new_nickname: String, view: UIViewController) -> ReturnValue<Bool>{
        if let uid : String = Auth.auth().currentUser?.uid {
            self.ref.child("houses/\(inHouseID)/house_users").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    if snapshot.hasChild(uid) {
                        self.ref.child("houses/\(inHouseID)/house_users/\(uid)/nickname").setValue(new_nickname)
                    } else {
                        self.database_error(error_header: "Error: User not member of house", view: view)
                    }
                } else {
                    self.database_error(error_header: "Error: House not found", view: view)
                }
            })
            
        }
        return NoSuchUserError()
    }
    
    /*
     Firebase does not allow quering for something in the data base with . # $ [ or ] thus we must remove these characters.  We came up with the following mapping to resolve this:
         . becomes &
         # becomes *
         $ becomes @
         [ becomes <
         ] becomes >
    */
    func reformatEmail(email: String) -> String {
        let period : Character = "."
        let pound : Character = "#"
        let dollar : Character = "$"
        let lBracket : Character = "["
        let rBracket : Character = "]"
        var fixedEmail : String = ""
        for char in email {
            if char == period {
                fixedEmail.append("&")
            } else if char == pound {
                fixedEmail.append("*")
            } else if char == dollar {
                fixedEmail.append("@")
            } else if char == lBracket {
                fixedEmail.append("<")
            } else if char == rBracket {
                fixedEmail.append(">")
            } else {
                fixedEmail.append(char)
            }
        }
        return fixedEmail
    }
    
    //Add User
    func addNewUserToHouse(with_email email: String, to_house house_id: String) -> ReturnValue<Bool> {
        let uid : String? = Auth.auth().currentUser?.uid
        if uid == nil  {
            return NoSuchUserError()
        }
        let formattedEmail = reformatEmail(email: email)
        self.ref.child("user_emails/\(formattedEmail)").observeSingleEvent(of: .value, with: { (snapshot) in
            //No account set up for user - email not associated with other houses
            print("snapshot for email: \(formattedEmail) = \(snapshot.children.allObjects)")
            if !snapshot.exists() {
                self.ref.child("user_emails/\(formattedEmail)/created").setValue(false)
                self.ref.child("user_emails/\(formattedEmail)/houses/\(house_id)").setValue(true)
            }
            else {
                //Email is not associated with account and already added to other houses
                if snapshot.childSnapshot(forPath: "created").value as! Bool{
                    //Add House To User's List Of Houses
                    let toAddUID = snapshot.childSnapshot(forPath: "uid").value as! String
                    self.ref.child("users/\(toAddUID)/houses/\(house_id)").setValue(true)
                    //Add User To House's List Of Users
                    let addUserToHouseCallback : (String?) -> Void = { (global_nickname) in
                        print("adding user to house closure")
                        self.ref.child("houses/\(house_id)/house_users/\(toAddUID)/email").setValue(email)
                        self.ref.child("houses/\(house_id)/house_users/\(toAddUID)/nickname").setValue(global_nickname)
                    }
                    self.getUserGlobalNickname(for_email: email, callback: addUserToHouseCallback)
                } else {
                    snapshot.setValue(true, forKey: "houses/\(house_id)")
                }
            }
        })
        return ExpectedExecution()
    }
    
    //Only the owner of a house or the user himself may remove a user from a house
//    func removeUserFromHouse(email_to_remove: String, house_id: String, view: UIViewController) -> ReturnValue<Bool> {
//        let uid : String? = Auth.auth().currentUser?.uid
//        if uid == nil  {
//            return NoSuchUserError()
//        }
//
//        if email_to_remove == Auth.auth().currentUser!.email {
//            return leaveHouse(house_id: house_id, view: view)
//        } else {
//            let formattedEmail = reformatEmail(email: email_to_remove)
//            self.ref.child("houses/\(house_id)").observe(.value, with: { (snapshot) in
//                if snapshot.exists() {
//                    if snapshot.childSnapshot(forPath: "owner").value as? String == Auth.auth().currentUser!.email {
//                        self.ref.child("user_emails/\(formattedEmail)/uid").observe(.value, with: { (snapshot) in
//                            if snapshot.exists(), let uid = snapshot.value as? String {
//                                self.ref.child("houses/\(house_id)/house_users\(uid)").removeValue()
//                            } else {
//                                self.database_error(error_header: "Error: Email not found", view: view)
//                            }
//                        })
//                    } else {
//                        self.database_error(error_header: "Error: Only the owner can remove hommies", view: view)
//                    }
//                } else {
//                    self.database_error(error_header: "Error: House not found", view: view)
//                }
//            })
//        }
//        return ExpectedExecution()
//    }
    
    func leaveHouse(house_id: String, view: UIViewController) -> ReturnValue<Bool> {
        if let uid : String = Auth.auth().currentUser?.uid {
            self.ref.child("houses/\(house_id)").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    self.ref.child("houses/\(house_id)/house_users\(uid)").removeValue()
                } else {
                    self.database_error(error_header: "Error: House not found", view: view)
                }
            })
            return ExpectedExecution()
        } else {
            return NoSuchUserError()
        }
    }
    // All functions above implemented and not tested //
    
    // Function to get a House's string name from its UID
    func getStringHouseName(house_id: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        
        self.ref.child("houses/\(house_id)/house_name").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                print("snapshot : \(snapshot.children.allObjects)")
                // Get the value of the snapshot (cast to string) and store as house name
                if let house_name = snapshot.value as? String {
                    //Run the function, callback, which is given by the frontend, passing it the nickname we read from the snapshot as an argument
                    print("Found House \(house_name)")
                    callback(house_name)
                } else {
                    // If cast could not occur then no house name found so run callback with nil
                    print("House Name not found")
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
    /*
     Gets list of houses a given user is a member of
     Input: String email of user and the callback function to use (aka what to do with the retrieved data)
     Output: ReturnValue object with true and no error code if proper execution, othewise with false and a corresponding error code
    */
    func getListOfHousesUserMemberOf(email: String, callback : @escaping ([String]?) -> Void) -> ReturnValue<Bool> {
        if let currUID = Auth.auth().currentUser?.uid {
            print("DB: \(currUID)")
            // Navigate to the user houses field and get a "Snapshot" of the data stored there
            self.ref.child("users/\(currUID)/houses").observe(.value, with: { (snapshot) in
                // This is the closure where we say what to do with the given snapshot, in this case, the houses the
                // user is in
                print("DB: taking snapshot")
                // Check if snapshot exists i.e. if data is stored there
                if snapshot.exists(){
                    print("DB: Snapshot exists")
                    // Get the value of the snapshot, i.e. the house_ids the user is in (cast to string array)
                    let house_ids = snapshot.value as? NSDictionary
                    if let houseIdStrings = house_ids?.allKeys as? [String]? {
                        // Callback with house ids which are random identifier strings of letters and numbers
                        print("User is in \(houseIdStrings!.count) houses")
                        callback(houseIdStrings)
                    } else {
                        // If cast could not occur aka no houses found, run callback with nil
                        print("User not in any houses/Houses not found")
                        callback(nil)
                    }
                }
            })
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    
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
    func createHouse(house: House) -> House {
        var newHouse = house
        print("create house function called")
        let house_id = self.ref.child("houses").childByAutoId().key
        print("creating house with key \(house_id)")
        let houseValueToAdd : Any = [ "houseID": house_id,
                                      "house_name": newHouse.house_name,
                                      "owner": newHouse.owner,
                                      "recent_charges": newHouse.recent_charges]
        self.ref.child("houses/\(house_id)").setValue(houseValueToAdd)
        newHouse.setHouseID(ID: house_id)
        let uid = Auth.auth().currentUser!.uid
        self.ref.child("users/\(uid)/houses/\(house_id)").setValue(true)
        addNewUserToHouse(with_email: newHouse.owner, to_house: house_id)
        for email in newHouse.house_users {
            addNewUserToHouse(with_email: email, to_house: house_id)
        }
        return newHouse
    }
    
    func ifHouseExists(house_id: String?, if_callback: @escaping () -> Void, else_callback: @escaping () -> Void) {
        if house_id == nil {
            else_callback()
        } else {
            self.ref.child("houses/\(house_id)").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if snapshot.exists() {
                    if_callback()
                } else {
                    else_callback()
                }
            })
        }
    }
    
    // Updates house name if it exists and returns true, otherwise returns appropriate error and false
    
    func changeHouseName(currHouse : House, newName: String)-> ReturnValue<Bool> {
        //Check if user is logged in
        if Auth.auth().currentUser?.uid != nil {
            // Setting value does not require closures and can be done directly to the DatabaseReferecece returned by .child() function
            self.ref.child("houses/\(String(describing: currHouse.houseID))/house_name").setValue(newName)
            return ExpectedExecution()
        }
        return NoSuchHouseError()
    }
    
    func changeHouseName(currHouseID : String, newName: String)-> ReturnValue<Bool> {
        //Check if user is logged in
        if Auth.auth().currentUser?.uid != nil {
            // Setting value does not require closures and can be done directly to the DatabaseReferecece returned by .child() function
            self.ref.child("houses/\(String(describing: currHouseID))/house_name").setValue(newName)
            return ExpectedExecution()
        }
        return NoSuchHouseError()
    }
    
    //ELENA+Jesse - FIX COMMENTED FUNCTIONS
    
//
//    func getListOfUsersInHouse(HouseID: String)-> ReturnValue<[String]> {
//        var users: [String] = []
//        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            if snapshot.exists(){
//                let value = snapshot.value as? NSDictionary
//                users = value?["users"] as? [String] ?? []
//            }
//        })
//        return ReturnValue(error:false, data: users)
//    }
//
//    // Checks if house exists and returns if user is owner, otherwise returns false and appropriate error
//    func isUserOwnerOfHouse(house_id: String)-> ReturnValue<Bool> {
//        if doesHouseExist(house_id: house_id).data! {
//            let result = (getOwnerOfHouse(HouseID: house_id).data! == Auth.auth().currentUser?.uid)
//            return ReturnValue(error: false, data: result)
//        }
//        return ReturnValue(error: false, data: false, error_number: 20)
//    }
//
//    func getOwnerOfHouse(HouseID: String)-> ReturnValue<String?> {
//        var owner: String? = ""
//        ref.child("houses").child(HouseID).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            if snapshot.exists(){
//                let value = snapshot.value as? NSDictionary
//                owner = value?["owner"] as? String ?? ""
//            }
//        })
//        return ReturnValue(error: false, data: owner)
//    }
//

    // Unsure about storing as array, should probably modify for scalability so don't have to retrieve append and update.
    // look into handling lists of data
//    func addNotification(notification: String, houseID: String, users_to_notify: [String]) {
//        var recent_inters = getMostRecentNotifications(HouseID: houseID, n: 10) // dummy n value
//        recent_inters.append(notification)
//        self.ref.child("houses/\(houseID)/recent_charges").setValue(recent_inters)
//    }
//
//    //TODO: account for n
//    func getMostRecentNotifications(HouseID: String, n: Int)-> [String] {
//        var recent_inters: [String] = []
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
//        //var curr_chars = getCharges(HouseID: houseID) // dummy n value
//        // TODO create charge type potentially?
//        //var newCharge
//        //curr_chars.append(newCharge)
//        //self.ref.child("houses/\(houseID)/recent_charges").setValue(curr_chars)
//    }
//
//    func getCharges(HouseID: String)-> [String] {
//        var charges: [String] = []
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
//

}
