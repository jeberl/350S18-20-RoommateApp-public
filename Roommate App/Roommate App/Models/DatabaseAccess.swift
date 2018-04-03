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

/*
    Class to contain all database calls to retrieve, update, or add data to the database. Implemented as
    a singleton throughout application.
 */

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
    
    //----------------------- Account Methods----------------------------------------
    func createAccount(username: String, password: String, view: UIViewController?){
        print("creating user")
        Auth.auth().createUser(withEmail: username, password: password)
        { user, error in
            print("created user \(user) with error \(error)")
            if error != nil {
                print("error creating user \(error.debugDescription)")
                if view != nil {
                    self.createAccountError(error: error!, view: view!)
                }
            } else if user != nil {
                self.createUserModelForCurrentUser()
                if view != nil {
                    self.okAccountCreation(view: view!)
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
                    self.loginError(error: error!, view: view!)
                }
            } else if user != nil {
                if view != nil {
                    view?.performSegue(withIdentifier: "log_in", sender: view!) 
                }
            }
        }
    }
    
    private func okAccountCreation(view: UIViewController) {
        let alert = UIAlertController(title: "Account Created",
                                      message: "Please login" ,
                                      preferredStyle: .alert)
        presentPopup(alert: alert, view: view, returnToLogin: false)
    }
    
    private func createAccountError(error: Error, view: UIViewController) {
        let alert = UIAlertController(title: "Account Creation Error",
                                      message: error.localizedDescription ,
                                      preferredStyle: .alert)
        presentPopup(alert: alert, view: view, returnToLogin: false)
    }
    
    private func loginError(error: Error, view: UIViewController) {
        let alert = UIAlertController(title: "Login Error",
                                      message: error.localizedDescription ,
                                      preferredStyle: .alert)
        presentPopup(alert: alert, view: view, returnToLogin: false)
    }
    
    private func databaseError(_ error: Error? = nil, error_header: String = "Error", view: UIViewController) {
        let alert = UIAlertController(title: error_header,
                                      message: error?.localizedDescription ,
                                      preferredStyle: .alert)
        presentPopup(alert: alert, view: view, returnToLogin: false)
    }
    
    
    private func presentPopup(alert: UIAlertController, view: UIViewController, returnToLogin: Bool) {
        
        let returnAction = UIAlertAction(title:"Login Again",
                                         style: .default,
                                         handler:  { action in view.performSegue(withIdentifier: "loginErrorSegue", sender: self) })
        
        let continueAction = UIAlertAction(title: "Continue",
                                           style: .default)
        
        alert.addAction(returnToLogin ? returnAction : continueAction)
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
                let user : [String: Any?] = ["uid" : uid,
                                            "email" : email,
                                            "formatted_email" : formattedEmail,
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
                    self.databaseError(error_header: "Error: Couldnt find User", view: view)
                }
            })
            return ExpectedExecution()
        } else {
            return NoSuchUserError()
        }
    }
    
    //TODO : Implement and TEST!!
   /* func changePassword(new_password: String) -> ReturnValue<Bool>{
        //Use Auth.auth()
        return UnimplementedFunctionError()
    }
    
    func deleteUserAccount(view: UIViewController) -> ReturnValue<Bool> {
        if let uid = Auth.auth().currentUser?.uid {
            let user : DatabaseReference = self.ref.child("users/\(uid)")
            
            // Remove User from associated houses
            user.child("houses").observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for houseID in snapshot.children {
                        self.ref.child("houses/\(houseID as! String)/houseUsers/\(uid)").removeValue()
                    }
                }
            })
            //Remove User from database
            user.removeValue()
            //Remove User Authentication
            Auth.auth().currentUser?.delete { error in
                if error != nil {
                    print(error!.localizedDescription)
                    self.databaseError(error!, error_header: "Error: Could not delete user", view: view)
                }
            }
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }*/
    
    func getUserGlobalNickname(for_email: String, callback : @escaping (String?) -> Void){
        let name_callback : (DataSnapshot) -> Void = { (uid) in
            self.getUserGlobalNickname(forUid: (uid.value as! String), callback: callback)
        }
        let formattedEmail = reformatEmail(email: for_email)
        self.ref.child("user_emails/\(formattedEmail)/uid").observe(.value, with: name_callback)
    }
    
    func getUserGlobalNickname(forUid: String?, callback : @escaping (String?) -> Void) -> ReturnValue<Bool> {
        //Check specific uid was given if not return for current user
        var uid = forUid
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
    
    func setUserGlobalNickname(newNickname: String) -> ReturnValue<Bool> {
        //Check if user is logged in
        if let uid : String = Auth.auth().currentUser?.uid {
            // Setting value does not require closures and can be done dicrectly to the DatabaseReferecece returned by .child() function
            self.ref.child("users/\(uid)/nickname").setValue(newNickname)
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    
    func getCurrentUserLocalNickname(fromHouse house: House, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        return getCurrentUserLocalNickname(fromHouse : house.houseID, callback: callback)
    }
    
    
    func getCurrentUserLocalNickname(fromHouse houseID: String?, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        if let uid = Auth.auth().currentUser?.uid {
            return getUserLocalNicknameFromUID(fromHouse: houseID, uid: uid, callback : callback)
        }
        return NoSuchUserError()
    }
    
    func getUserLocalNicknameFromUID(fromHouse houseID: String?, uid : String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        print("uid =  \(uid)")
        if let houseID = houseID {
            self.ref.child("houses/\(houseID)/house_users").observe(.value, with: { (snapshot) in
                if snapshot.exists() && snapshot.hasChild(uid) {
                    let nickname = snapshot.childSnapshot(forPath: "\(uid)/nickname").value as? String
                    print("found nickname \(nickname)")
                    callback(nickname)
                } else {
                    //return nil if house not found or user not member of house
                    callback(nil)
                }
            })
            return ExpectedExecution()
        }
        return NoSuchHouseError()
    }
    
    // NEW CODE
    func setUserLocalNickname(inHouse : House, to newNickname: String, view: UIViewController) -> ReturnValue<Bool>{
        if let hId = inHouse.houseID {
            return setUserLocalNickname(inHouseID : hId, to: newNickname, view: view)
        }
        return NoSuchHouseError()
    } 
    
    // NEW CODE
    func setUserLocalNickname(inHouseID : String, to newNickname: String, view: UIViewController) -> ReturnValue<Bool>{
        if let uid : String = Auth.auth().currentUser?.uid {
            self.ref.child("houses/\(inHouseID)/house_users").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    if snapshot.hasChild(uid) {
                        self.ref.child("houses/\(inHouseID)/house_users/\(uid)/nickname").setValue(newNickname)
                    } else {
                        self.databaseError(error_header: "Error: User not member of house", view: view)
                    }
                } else {
                    self.databaseError(error_header: "Error: House not found", view: view)
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
    
    // Gets corresponding uid of a user email
    func getUserUidFromEmail(email: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        var formatEmail = reformatEmail(email: email)
        //Navigate to the formatted email field and get a "Snapshot" of the data stored there
            self.ref.child("user_emails/\(formatEmail)/uid").observeSingleEvent(of: .value, with: { (snapshot) in
                //This is the closure where we say what to do with the given snapshot which in this case is the nickname
                // We check if the snapshot exists ie. is there data stored there
                if snapshot.exists() {
                    // Get the value of the snapshot (cast to string) and store as nickname
                    if let userUid = snapshot.value as? String {
                        //Run the function, callback, which is given by the frontend, passing it the nickname we read from the snapshot as an argument
                        callback(userUid)
                    } else {
                        // If cast coulnt occur no uid found, run  callback with nil
                        print("No uid found")
                        callback(nil)
                    }
                } else {
                    // If no snapshot then no user, run the callback with nil
                    print("User not found")
                    callback(nil)
                }
            })
        return NoSuchUserError()
    }
    
    //Add User
    func addNewUserToHouse(withEmail email: String, to_house houseId: String) -> ReturnValue<Bool> {
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
                self.ref.child("user_emails/\(formattedEmail)/houses/\(houseId)").setValue(true)
            }
            else {
                //Email is not associated with account and already added to other houses
                if snapshot.childSnapshot(forPath: "created").value as! Bool{
                    //Add House To User's List Of Houses
                    let toAddUID = snapshot.childSnapshot(forPath: "uid").value as! String
                    self.ref.child("users/\(toAddUID)/houses/\(houseId)").setValue(true)
                    //Add User To House's List Of Users
                    let addUserToHouseCallback : (String?) -> Void = { (global_nickname) in
                        print("adding user to house closure")
                        self.ref.child("houses/\(houseId)/house_users/\(toAddUID)/email").setValue(email)
                        self.ref.child("houses/\(houseId)/house_users/\(toAddUID)/nickname").setValue(global_nickname)
                    }
                    self.getUserGlobalNickname(for_email: email, callback: addUserToHouseCallback)
                } else {
                    let uid = snapshot.childSnapshot(forPath: "uid").value as! String
                    self.ref.child("users/\(uid)/houses/\(houseId)").setValue(true)
                }
            }
        })
        return ExpectedExecution()
    }
    
    //Only the owner of a house or the user himself may remove a user from a house
//    func removeUserFromHouse(email_to_remove: String, houseId: String, view: UIViewController) -> ReturnValue<Bool> {
//        let uid : String? = Auth.auth().currentUser?.uid
//        if uid == nil  {
//            return NoSuchUserError()
//        }
//
//        if email_to_remove == Auth.auth().currentUser!.email {
//            return leaveHouse(houseId: houseId, view: view)
//        } else {
//            let formattedEmail = reformatEmail(email: email_to_remove)
//            self.ref.child("houses/\(houseId)").observe(.value, with: { (snapshot) in
//                if snapshot.exists() {
//                    if snapshot.childSnapshot(forPath: "owner").value as? String == Auth.auth().currentUser!.email {
//                        self.ref.child("user_emails/\(formattedEmail)/uid").observe(.value, with: { (snapshot) in
//                            if snapshot.exists(), let uid = snapshot.value as? String {
//                                self.ref.child("houses/\(houseId)/house_users\(uid)").removeValue()
//                            } else {
//                                self.databaseError(error_header: "Error: Email not found", view: view)
//                            }
//                        })
//                    } else {
//                        self.databaseError(error_header: "Error: Only the owner can remove hommies", view: view)
//                    }
//                } else {
//                    self.databaseError(error_header: "Error: House not found", view: view)
//                }
//            })
//        }
//        return ExpectedExecution()
//    }
    
    func leaveHouse(houseId: String, view: UIViewController) -> ReturnValue<Bool> {
        if let uid : String = Auth.auth().currentUser?.uid {
            self.ref.child("houses/\(houseId)").observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    self.ref.child("houses/\(houseId)/house_users\(uid)").removeValue()
                } else {
                    self.databaseError(error_header: "Error: House not found", view: view)
                }
            })
            return ExpectedExecution()
        } else {
            return NoSuchUserError()
        }
    }
    // All functions above implemented and not tested //
    
    // Function to get a House's string name from its UID
    func getStringHouseName(houseId: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("houses/\(houseId)/house_name").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                print("snapshot : \(snapshot.children.allObjects)")
                // Get the value of the snapshot (cast to string) and store as house name
                if let houseName = snapshot.value as? String {
                    //Run the function, callback, which is given by the frontend, passing it the nickname we read from the snapshot as an argument
                    callback(houseName)
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
                    // Get the value of the snapshot, i.e. the houseIds the user is in (cast to string array)
                    let houseIds = snapshot.value as? NSDictionary
                    if let houseIdStrings = houseIds?.allKeys as? [String]? {
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
        let houseId = self.ref.child("houses").childByAutoId().key
        print("creating house with key \(houseId)")
        let houseValueToAdd : Any = [ "houseID": houseId,
                                      "house_name": newHouse.houseName,
                                      "owner": newHouse.owner,
                                      "recent_charges": newHouse.recentCharges]
        self.ref.child("houses/\(houseId)").setValue(houseValueToAdd)
        newHouse.setHouseID(ID: houseId)
        let uid = Auth.auth().currentUser!.uid
        self.ref.child("users/\(uid)/houses/\(houseId)").setValue(true)
        addNewUserToHouse(withEmail: newHouse.owner, to_house: houseId)
        for email in newHouse.houseUsers {
            addNewUserToHouse(withEmail: email, to_house: houseId)
        }
        return newHouse
    }
    
    func ifHouseExists(houseId: String?, if_callback: @escaping () -> Void, else_callback: @escaping () -> Void) {
        if houseId == nil {
            else_callback()
        } else {
            self.ref.child("houses/\(houseId)").observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    /*
     Creates chore in database
     Input: Chore assigned
     Output: True if chore added with no error message, false and with error message if not added
     */
    func createChore(chore : ChoreAJ) -> ReturnValue<Bool> {
        var newChore = chore
        print("Assigning chore with chore name \(newChore.title)")
        let choreID = self.ref.child("chores").childByAutoId().key
        let choreToAdd : Any = [ "title" : newChore.title,
                                 "assigned_by" : newChore.assignedBy,
                                 "assigned_to" : newChore.assigned_to,
                                 "completed" : false,
                                 "time_assigned" : newChore.timeAssigned,
                                 "time_completed" : nil,
                                 "houseID" : newChore.houseID,
                                 "description" : newChore.description
        ]
        self.ref.child("chores/\(choreID)").setValue(choreToAdd)
        newChore.setChoreID(ID: choreID)
        assignChoreToUser(userEmail: chore.assigned_to, choreID: choreID)
        assignChoreToHouse(houseID: newChore.houseID, choreID: choreID)
        return ExpectedExecution()
    }
    
    /*
     Assigns the chore to the user
     Input: Email of the user the chore was assigned to
     Output: Return value with true and no error if chore was assigned properly.  Otherwise, return value with false and associated error code
    */
    func assignChoreToUser(userEmail: String, choreID: String) -> ReturnValue<Bool> {
        var userID : String?
        let getUIDClosure = { (returnedID : String?) -> Void in
            userID = returnedID
            
            if userID == nil {
                print("User has not yet created an account")
            } else {
                // Add choreID to dictionary of user's incomplete chores
                self.ref.child("users/\(userID!)/incompleteChores/\(choreID)").setValue(true)
            }
        }
        getUIDFromEmail(email: userEmail, callback: getUIDClosure)
        
        return ExpectedExecution()
    }
    
    /*
     Assigns chore to house's list of all incomplete chores
     Input: String ID of associated house and string ID of chore to add
     Output: Return value containing true and no error if chore was added.  Otherwise, returns false and an associated error code
    */
    func assignChoreToHouse(houseID: String, choreID: String) -> ReturnValue<Bool> {
        // Add choreID to dictionary of house's incomplete chores
        self.ref.child("houses/\(houseID)/incompleteChores/\(choreID)").setValue(true)
        return ExpectedExecution()
    }
    
    /*
     Finds and returns the user's UID given their email
     Input: User's email
     Output: callback returns user's associated UID
    */
    func getUIDFromEmail(email: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        let formattedEmail = reformatEmail(email: email)
        self.ref.child("user_emails/\(formattedEmail)/uid").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                print("snapshot exists in uid email")
                if let uid = snapshot.value as? String {
                    // Get the value of the snapshot (cast to string) and store as uid
                    callback(uid)
                }
            } else {
                print("User has not yet created an account")
                callback(nil)
            }
        })
        return ExpectedExecution()
    }
    
    func getUserProfPicFromEmail(email: String, callback: @escaping (UIImage?) -> Void) -> ReturnValue<Bool> {
        
        let fake_mapping_email_uid = ["amotta@email.com" : "ajani.jpg",
                                      "jesse@email.com" : "jesse.jpg",
                                      "brooke@me.com" : "brooke.jpeg",
                                      "emi@email.com" : "elena.JPG",
                                      "nickbuck@wharton.upenn.edu" : "nick.JPG"]
        
        if let uid = fake_mapping_email_uid[email] {
            print("trying to get image for uid \(uid)")
            ImageStorage.getInstance().getUserProfImageOnce(uid: uid, callback: callback)
        } else {
            print("trying to get image for email \(email)")

            getUIDFromEmail(email: email, callback: { (uid) in
                if let uid = uid {
                    ImageStorage.getInstance().getUserProfImageOnce(uid: uid, callback: callback)
                } else {
                    callback(nil)
                }
            })
        }
        return ExpectedExecution()
    }
    
    /*
     Gets list of chores a given user is a associated with
     Input: String email of user and the callback function to use (aka what to do with the retrieved data)
     Output: ReturnValue object with true and no error code if proper execution, othewise with false and a corresponding error code
    */
    func getUserChores(uid: String, callback : @escaping ([String]?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("users/\(uid)/incompleteChores").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                let choreIDs = snapshot.value as? NSDictionary
                if let choreIDstr = choreIDs?.allKeys as? [String]? {
                    callback(choreIDstr)
                }
                else {
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
    
    /*
     Gets list of chores in a given house
     Input: String email of user and the callback function to use (aka what to do with the retrieved data)
     Output: ReturnValue object with true and no error code if proper execution, othewise with false and a corresponding error code
     */
    func getHouseChores(houseID: String, callback : @escaping ([String]?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("houses/\(houseID)/incompleteChores").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                let choreIDs = snapshot.value as? NSDictionary
                if let choreIDstr = choreIDs?.allKeys as? [String]? {
                    callback(choreIDstr)
                }
                else {
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
    
    /*
     Function to get a chore's string name from its choreID
    */
    func getStringChoreTitle(choreID: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("chores/\(choreID)/title").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                // Get the value of the snapshot (cast to string) and store as chore name
                if let title = snapshot.value as? String {
                    //Run the function, callback, which is given by the frontend, passing it the nickname we read from the snapshot as an argument
                    let choreTitle : String = title
                    callback(choreTitle)
                } else {
                    // If cast could not occur then no chore name found so run callback with nil
                    print("Chore Name not found")
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
    /*
     Function to get a chore's string description from its choreID
     */
    func getStringChoreDescription(choreID: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("chores/\(choreID)/description").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                // Get the value of the snapshot (cast to string) and store as chore name
                if let description = snapshot.value as? String {
                    //Run the function, callback, which is given by the frontend, passing it the nickname we read from the snapshot as an argument
                    let choreDescription : String = description
                    callback(choreDescription)
                } else {
                    // If cast could not occur then no chore name found so run callback with nil
                    print("Chore description not found")
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
    /*
     Function to get a chore's string description from its choreID
     */
    func getStringChoreAssignor(choreID: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("chores/\(choreID)/assignedBy").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                // Get the value of the snapshot (cast to string) and store as chore name
                if let assignor = snapshot.value as? String {
                    //Run the function, callback, which is given by the frontend, passing it the nickname we read from the snapshot as an argument
                    let choreAssignor : String = assignor
                    callback(choreAssignor)
                } else {
                    // If cast could not occur then no chore name found so run callback with nil
                    print("Chore description not found")
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
    /*
     Function to get a chore's string description from its choreID
     */
    func getStringChoreAssignee(choreID: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("chores/\(choreID)/assigned_to").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                // Get the value of the snapshot (cast to string) and store as chore name
                if let assignee = snapshot.value as? String {
                    //Run the function, callback, which is given by the frontend, passing it the nickname we read from the snapshot as an argument
                    let choreAssignee : String = assignee
                    callback(choreAssignee)
                } else {
                    // If cast could not occur then no chore name found so run callback with nil
                    print("Chore description not found")
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }

    
    /*
     Complete chore
    */
    func completeChore() {
    
	}    
    
    // NEW CODE
    func changeHouseName(currHouseID : String, newName: String)-> ReturnValue<Bool> {
        //Check if user is logged in
        if Auth.auth().currentUser?.uid != nil {
            // Setting value does not require closures and can be done directly to the DatabaseReferecece returned by .child() function
            self.ref.child("houses/\(String(describing: currHouseID))/house_name").setValue(newName)
            return ExpectedExecution()
        }
        return NoSuchHouseError()
    }
    
    func getListOfUIDSInHouse(houseID: String, callback : @escaping ([String]?) -> Void) -> ReturnValue<Bool> {
        print("getting list of UIDs")
        if Auth.auth().currentUser?.uid != nil {
            // Navigate to the houses users field and get a "Snapshot" of the data stored there
            self.ref.child("houses/\(houseID)/house_users").observe(.value, with: { (snapshot) in
                // This is the closure where we say what to do with the given snapshot, in this case, the users in
                // a given house
                // Check if snapshot exists i.e. if data is stored there
                if snapshot.exists(){
                    // Get the value of the snapshot, i.e. the userIds in the house(cast to string array)
                    let userIds = snapshot.value as? NSDictionary
                    if let userIdsStrings = userIds?.allKeys as? [String]? {
                        // Callback with house ids which are random identifier strings of letters and numbers
                        print("Number users in houseId: \(userIdsStrings!.count) ")
                        callback(userIdsStrings)
                    } else {
                        // If cast could not occur aka no users found, run callback with nil
                        print("couldnt cast to [String] = \(userIds?.allKeys)")
                        callback(nil)
                    }
                } else {
                    print("House \(houseID) not found")
                }
            })
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    
    func setGlobalHouseVariables() {
        print("attempting to set global house vars with houseID = \(currentHouseID)")
        var result = getCurrentUserLocalNickname(fromHouse: currentHouseID!) { (localNick) in
            if let localNick = localNick {
                currentUserLocalNickName = localNick
                print("set currentUserLocalNickName to \(localNick)")
            } else {
                print("couldnt find local nickname to set global var")
            }
        }
        if result.returned_error {
            print(result.error_message)
        }
        result = getListOfUIDSInHouse(houseID: currentHouseID!) { (UIDs) in
            if let UIDs = UIDs {
                currentHouseMemberUIDs = UIDs
                print("set currentHouseMemberUIDs to \(UIDs)")
                currentHouseMemberNicknames = []
                for uid in UIDs {
                    self.getUserLocalNicknameFromUID(fromHouse: currentHouseID, uid: uid, callback: { (nickname) in
                        if let nickname = nickname {
                            currentHouseMemberNicknames.append(nickname)
                        } else {
                           currentHouseMemberNicknames.append("nickname not found")
                        }
                    })
                }
                print("set currentHouseMemberNicknames to \(currentHouseMemberNicknames)")
            } else {
                print("UIDs not found")
            }
        }
        if result.returned_error {
            print(result.error_message)
        }
        
    }
    
    // Adds notification value to all notifications part of db and ongoing list of notifications in a user's account
    func addNotification(notification: Notification, usersInvolved: [String])-> ReturnValue<Bool> {
        let notifID = self.ref.child("notifications").childByAutoId().key
        var newNotification = notification
        newNotification.setNotificationID(ID: notifID)
        var newUsersInvolved : [String] = []
        for user in newNotification.usersInvolved {
            var formatEmail = reformatEmail(email: user)
            newUsersInvolved.append(formatEmail) 
        }
        let notificationValueToAdd : [String: Any?] = ["houseID": newNotification.houseID,
                                                       "description": newNotification.description,
                                      //"users_involved": newUsersInvolved,
                                      //"timestamp": newNotification,
                                      "type": newNotification.type]
        self.ref.child("notifications/\(notifID)").setValue(notificationValueToAdd)
        // For each user in usersInvolved add the notifId to their notifications and send notifier to user
        for someUser in newUsersInvolved {
            self.ref.child("notifications/\(notifID)/users_involved/\(someUser)").setValue(true)
        }
        for currUser in notification.usersInvolved {
            let formattedEmail = reformatEmail(email: currUser)
            self.ref.child("user_emails/\(formattedEmail)/uid").observe(.value, with: { (snapshot) in
                let uid = snapshot.value!
                self.ref.child("users/\(uid)/notifications/\(notifID)").setValue(true)
            })
        }
        return ExpectedExecution()
    }
    
    /*
     Gets the current time stamp and returns it as a string
     Input: N/A
     Output: String representation of timestamp
     */
    func getTimestampAsString() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let timeStamp = formatter.string(from: Date())
        print("Current time stamp = \(timeStamp)")
        return timeStamp
    }
    
    // once a user deletes the notification, it is deleted from their account and deletes the user from the notification in db,
    // it is deleted from db altogether if no other users are dependent on it
    func deleteNotification(notifId: String) -> ReturnValue<Bool> {
        //let currUser = Auth.auth().currentUser?.email
        let currUser = reformatEmail(email: "emi@email.com")
        let formattedEmail = reformatEmail(email: currUser)
        self.ref.child("user_emails/\(formattedEmail)/uid").observe(.value, with: { (snapshot) in
            let uid = snapshot.value!
            //self.ref.child("notifications/\(notifId)/users_involved/\(currUser)").setValue(nil)
            self.ref.child("users/\(uid)/notifications/\(notifId)").setValue(nil)
        })
        self.ref.child("notifications/\(notifId)/users_involved/\(currUser)").setValue(nil)
        return ExpectedExecution()
    }
    
    // Remove entire notification reference in db if no more users need it
    func removeNotification(notifId: String) -> ReturnValue<Bool> {
        self.ref.child("notifications/\(notifId)").observe(.value, with: { (snapshot) in
            if !snapshot.hasChild("users_involved") {
                self.ref.child("notifications/\(notifId)").setValue(nil)
            }
        })
        return ExpectedExecution()
    }

    // retrieve a current users notifications for display on screen
    func getNotifications(callback : @escaping ([String]?) -> Void) -> ReturnValue<Bool> {
        if let currUID = Auth.auth().currentUser?.uid {
            // Navigate to the user houses field and get a "Snapshot" of the data stored there
            self.ref.child("users/\(currUID)/notifications").observe(.value, with: { (snapshot) in
                // This is the closure where we say what to do with the given snapshot, in this case, the houses the
                // user is in
                // Check if snapshot exists i.e. if data is stored there
                if snapshot.exists(){
                    // Get the value of the snapshot, i.e. the houseIds the user is in (cast to string array)
                    let notifIds = snapshot.value as? NSDictionary
                    if let notifIdStrings = notifIds?.allKeys as? [String]? {
                        // Callback with notification ids which are random identifier strings of letters and numbers
                        callback(notifIdStrings)
                    } else {
                        // If cast could not occur aka no notifications found, run callback with nil
                        print("No notifications for user")
                        callback(nil)
                    }
                }
            })
            return ExpectedExecution()
        }
        return NoSuchUserError()
    }
    
    func getNotifData(notifId: String, callback: @escaping (NSDictionary?) -> Void) -> ReturnValue<Bool> {
        //Navigate to the formatted email field and get a "Snapshot" of the data stored there
        self.ref.child("notifications/\(notifId)").observe(.value, with: { (snapshot) in
            //This is the closure where we say what to do with the given snapshot which in this case is the nickname
            // We check if the snapshot exists ie. is there data stored there
            if snapshot.exists() {
                // Get the value of the snapshot (cast to string) and store as nickname
                if let notification = snapshot.value as? NSDictionary {
                    //Run the function, callback, which is given by the frontend, passing it the nickname we read from the snapshot as an argument
                    callback(notification)
                } else {
                    // If cast coulnt occur no uid found, run  callback with nil
                    print("No notification")
                    callback(nil)
                }
            } else {
                // If no snapshot then no user, run the callback with nil
                print("notification not found")
                callback(nil)
            }
        })
        return NoSuchUserError()
    }
    
    /*
     Creates charge in database
     Input: Charge assigned
     Output: True if charge added with no error message, false and with error message if not added
     */
    func createCharge(charge: Charge) -> ReturnValue<Bool> {
        let newCharge = charge
        print("Assigning charge to \(newCharge.toUser) for \(newCharge.amount)")
        let chargeID = self.ref.child("charges").childByAutoId().key
        let chargeToAdd : Any = [ "amount" : newCharge.amount,
                                  "assigned_by" : newCharge.fromUser,
                                  "assigned_to" : newCharge.toUser,
                                  "houseID" : newCharge.houseID,
                                  "time_charged" : newCharge.timestamp,
                                  "message" : newCharge.message
        ]
        self.ref.child("charges/\(chargeID)").setValue(chargeToAdd)
        newCharge.setChargeID(ID: chargeID)
        assignChargeToUser(userEmail: newCharge.toUser, chargeID: chargeID)
        assignChargeToHouse(houseID: newCharge.houseID, chargeID: chargeID)
        return ExpectedExecution()
    }
    
    
    /*
     Assigns the charge to the user
     Input: Email of the user the charge was billed to and string ID of charge to add
     Output: Return value with true and no error if charge was assigned properly.  Otherwise, return value with false and associated error code
     */
    func assignChargeToUser(userEmail: String, chargeID: String) -> ReturnValue<Bool> {
        var userID : String?
        let getUIDClosure = { (returnedID : String?) -> Void in
            userID = returnedID
            
            if userID == nil {
                print("User has not yet created an account")
            } else {
                // Add chargeID to dictionary of user's incomplete charges
                self.ref.child("users/\(userID!)/incompleteCharges/\(chargeID)").setValue(true)
            }
        }
        getUIDFromEmail(email: userEmail, callback: getUIDClosure)
        
        return ExpectedExecution()
    }
    
    /*
     Assigns charge to house's list of all incomplete charges
     Input: String ID of associated house and string ID of charge to add
     Output: Return value containing true and no error if charge was added.  Otherwise, returns false and an associated error code
     */
    func assignChargeToHouse(houseID: String, chargeID: String) -> ReturnValue<Bool> {
        // Add choreID to dictionary of house's incomplete chores
        self.ref.child("houses/\(houseID)/incompleteCharges/\(chargeID)").setValue(true)
        return ExpectedExecution()
    }
    

    /*
     Gets list of charges a given user has been charged
     Input: String ID of user and the callback function to use (aka what to do with the retrieved data)
     Output: ReturnValue object with true and no error code if proper execution, othewise with false and a corresponding error code
     Callback Returns: List of string charge IDs.  View controller then uses this to find charge messages and amounts
     */
    func getUserCharges(uid: String, callback : @escaping ([String]?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("users/\(uid)/incompleteCharges").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                let chargeIDs = snapshot.value as? NSDictionary
                if let chargeIDstr = chargeIDs?.allKeys as? [String]? {
                    callback(chargeIDstr)
                }
                else {
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
    
    /*
     Gets the list of charges stored in a house to be displayed on the house balance page
     Input: String representation of house id and clalback function to use (aka what to do with retrieved data)
     Output: ReturnValue object with true and no error code if proper execution, otherwise with false and a corresponding error code
     Callback Returns: List of string charge IDs for the given house.  View Controller uses this to find charge messages and amounts
     */
    func getHouseCharges(houseId: String, callback : @escaping ([String]?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("houses/\(houseId)/incompleteCharges").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                let chargeIDs = snapshot.value as? NSDictionary
                if let chargeIDstr = chargeIDs?.allKeys as? [String]? {
                    callback(chargeIDstr)
                }
                else {
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
    /*
     Function to get a charge's string message from its chargeID
     Input: Charge ID of charge you wish to get message for
     Output: Return value with true and no error messgae if charge messge is found.  False and error code if charge is not found
     Callback returns: the charge's string messgae
     */
    func getChargeMessage(chargeID: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("charges/\(chargeID)/message").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                // Get the value of the snapshot (cast to string) and store as charge name
                if let message = snapshot.value as? String {
                    // Run the function, callback, which is given by the frontend, passing it the message we read from the snapshot as an argument
                    let chargeMessage : String = message
                    callback(chargeMessage)
                } else {
                    // If cast could not occur then no charge message found so run callback with nil
                    print("Charge Measage not found")
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
    /*
     Function to get a charge's double amount from its chargeID
     Input: Charge ID of charge you wish to get amount of
     Output: Return value with true and no error messgae if charge messge is found.  False and error code if charge is not found
     Callback returns: the charge's amount
     */
    func getChargeAmount(chargeID: String, callback: @escaping (String?) -> Void) -> ReturnValue<Bool> {
        self.ref.child("charges/\(chargeID)/amount").observe(.value, with: { (snapshot) in
            if snapshot.exists() {
                // Get the value of the snapshot (cast to string) and store as charge name
                if let amount = snapshot.value as? String {
                    // Run the function, callback, which is given by the frontend, passing it the amount we read from the snapshot as an argument
                    let chargeAmount : String = amount
                    callback(chargeAmount)
                } else {
                    // If cast could not occur then no charge amount found so run callback with nil
                    print("Charge amount not found")
                    callback(nil)
                }
            }
        })
        return ExpectedExecution()
    }
    
//    func getBalanceBetweenUsers(HouseID: String, User1Email: String, User2Email: String) {
//        // TO BE IMPLEMENTED
//    }
//

}
