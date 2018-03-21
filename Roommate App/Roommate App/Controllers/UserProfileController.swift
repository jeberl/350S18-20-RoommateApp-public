//
//  UserProfileController.swift
//  Roommate App
//
//  Created by Nick Buckenham on 2/22/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserProfileController: UIViewController {
    
    // stores the instance of the database
    var database: DatabaseAccess = DatabaseAccess.getInstance()
    var currentGlobalNickname: String?
    var currentLocalNickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // closure for getUserGlobalNickname
        let userGlobalNicknameClosure = { (returnedGlobalNickname: String?) -> Void in
            self.currentGlobalNickname = returnedGlobalNickname
            let textForGlobalNickname: String = "Current Global Nickname: \(self.currentGlobalNickname ?? "Error: nil Nickname")"
            self.userProfileGlobalNickname.text = textForGlobalNickname
        }
        
        // calls getUserGlobalNickname, handles errors
        let errorGlobalNickname = self.database.getUserGlobalNickname(for_uid: Auth.auth().currentUser?.uid, callback: userGlobalNicknameClosure)
        if errorGlobalNickname.returned_error {
            errorGlobalNickname.raiseErrorAlert(with_title: "error", view: self)
        }
        
        // closure for getUserLocalNickname
        let userLocalNicknameClosure = { (returnedLocalNickname: String?) -> Void in
            self.currentLocalNickname = returnedLocalNickname
            let textForLocalNickname: String = "Current Local Nickname: \(self.currentLocalNickname ?? "Error: nil Nickname")"
            self.userProfileLocalNickname.text = textForLocalNickname
        }
        
        // calls getUserLocalNickname, handles errors
        let errorLocalNickname = self.database.getUserLocalNickname(from_houseID: currentHouseID, callback: userLocalNicknameClosure)
        if errorLocalNickname.returned_error {
            errorLocalNickname.raiseErrorAlert(with_title: "error", view: self)
        }
        
        // displays current profile email address
        let profileForText: String = "User Profile For: \(Auth.auth().currentUser!.email ?? "Error: nil User")"
        userProfileFor.text = profileForText
        
    }
    
    // outlets for displaying user profile information
    @IBOutlet weak var userProfileFor: UILabel!
    @IBOutlet weak var userProfileGlobalNickname: UILabel!
    @IBOutlet weak var userProfileLocalNickname: UILabel!
    
    // outlets for input text fields
    @IBOutlet weak var changePasswordField: UITextField!
    @IBOutlet weak var changeGlobalNicknameField: UITextField!
    @IBOutlet weak var changeLocalNicknameField: UITextField!
    
    @IBAction func submitPasswordClicked(_ sender: UIButton) {
        // let newPassword = changePasswordField.text
        // TODO: Implement changePassword in DB, then finish this
        
    }
    
    @IBAction func submitGlobalNicknameClicked(_ sender: UIButton) {
        let newGlobalNickname = changeGlobalNicknameField.text
        database.setUserGlobalNickname(new_nickname: newGlobalNickname!)
    }
    
    
    @IBAction func submitLocalNicknameClicked(_ sender: UIButton) {
        let newLocalNickname = changeLocalNicknameField.text
        database.setUserLocalNickname(inHouseID: currentHouseID!, to: newLocalNickname!, view: self)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
