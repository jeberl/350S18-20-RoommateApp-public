//
//  LoginScreenViewController.swift
//  Roommate App
//
//  Created by Elena Iaconis on 2/14/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
import UIKit

import Firebase
import FirebaseDatabase
import FirebaseAuthUI


//Elements taken from: https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2

class LoginScreenViewController: UIViewController {
    //MARK: Properties
    var user: UserAccount!
    
    let ref = Database.database().reference(withPath: "haus-party")

    let alert = UIAlertController(title: "Add User",
                                  message: "Create a new User",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { _ in
                                    // 1
                                    guard let textField = alert.textFields?.first,
                                        let text = textField.text else { return }
                                    
                                    // 2
                                    
                                    let newUser = UserAccount(uid: "U1", email: "test1@test.com", nickname: "test", houses: [], phoneNumber: 2)
                                    // 3
                                    
                                    let userReference = self.ref.child(newUser.email)
                                    
                                    // 4
                                    userReference.setValue(newUser.toAnyObject())
    }
}

