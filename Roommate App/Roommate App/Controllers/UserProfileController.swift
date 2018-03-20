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
        
        let userGlobalNicknameClosure = { (returnedGlobalNickname: String?) -> Void in
            self.currentGlobalNickname = returnedGlobalNickname
            print("TEST")
            print("\(returnedGlobalNickname!)")
            print("\(self.currentGlobalNickname!)")
        }
        
        let errorGlobalNickname = self.database.getUserGlobalNickname(for_uid: Auth.auth().currentUser?.uid, callback: userGlobalNicknameClosure)
        if errorGlobalNickname.returned_error {
            errorGlobalNickname.raiseErrorAlert(with_title: "error", view: self)
        }
        
        let userLocalNicknameClosure = { (returnedLocalNickname: String?) -> Void in
            self.currentLocalNickname = returnedLocalNickname
        }
        
        let errorLocalNickname = self.database.getUserLocalNickname(from_houseID: currentHouseID, callback: userLocalNicknameClosure)
        if errorLocalNickname.returned_error {
            errorLocalNickname.raiseErrorAlert(with_title: "error", view: self)
        }
        
        print("TEST")
        
        // displays current profile email address
        let profileForText: String = "User Profile For: \(Auth.auth().currentUser!.email ?? "Error: nil user") \nCurrent Global Nickname:  \nCurrent Local Nickname:)"
        userProfileFor.text = profileForText
        
    }
    
    // outlet for displaying user profile
    @IBOutlet weak var userProfileFor: UILabel!
    
    // outlets for input text fields
    @IBOutlet weak var changePasswordField: UITextField!
    @IBOutlet weak var changeGlobalNicknameField: UITextField!
    @IBOutlet weak var changeLocalNicknameField: UITextField!
    
    @IBAction func submitPasswordClicked(_ sender: UIButton) {
        let newPassword = changePasswordField.text
        
    }
    
    @IBAction func submitGlobalNicknameClicked(_ sender: UIButton) {
        let newGlobalNickname = changeGlobalNicknameField.text
        
    }
    
    @IBAction func submitLocalNicknameClicked(_ sender: UIButton) {
        let newLocalNickname = changeLocalNicknameField.text
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
