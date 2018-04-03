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
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        currentLocalNickname = currentUserLocalNickName
        
        // closure for getUserGlobalNickname
        let userGlobalNicknameClosure = { (returnedGlobalNickname: String?) -> Void in
            self.currentGlobalNickname = returnedGlobalNickname
            let textForGlobalNickname: String = "Current Global Nickname: \(self.currentGlobalNickname ?? "Error: nil Nickname")"
            self.userProfileGlobalNickname.text = textForGlobalNickname
        }
        
        // calls getUserGlobalNickname, handles errors
        let errorGlobalNickname = self.database.getUserGlobalNickname(forUid: Auth.auth().currentUser?.uid, callback: userGlobalNicknameClosure)
        if errorGlobalNickname.returned_error {
            errorGlobalNickname.raiseErrorAlert(with_title: "error", view: self)
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
    
    func invalidNicknameEntry() {
        let alert = UIAlertController(title: "Please enter a valid Nickname", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitGlobalNicknameClicked(_ sender: UIButton) {
        if let newGlobalNickname = changeGlobalNicknameField.text{
            database.setUserGlobalNickname(newNickname: newGlobalNickname)
        } else {
            invalidNicknameEntry()
        }
    }
    
    
    @IBAction func submitLocalNicknameClicked(_ sender: UIButton) {
        if let newLocalNickname = changeLocalNicknameField.text {
            currentUserLocalNickName = newLocalNickname
            database.setUserLocalNickname(inHouseID: currentHouseID!, to: newLocalNickname, view: self)
        } else {
            invalidNicknameEntry()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
