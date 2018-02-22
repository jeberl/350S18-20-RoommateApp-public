//
//  ViewController.swift
//  Roommate App
//
//  Created by Elena Iaconis on 2/9/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
   
    //MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var buttonPressed = ""
    var database: DatabaseAccess = DatabaseAccess()
    var userLoggingIn: UserAccount?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testUser = UserAccount(
            email: "me@emailcom",
            nickname: "testUser",
            houses: ["test1","test2"],
            phoneNumber: "123-456-7890" 
            )
        print("adding users to database")
        self.database.createUser(newUser: testUser)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var performSegue = true
        
        if identifier == "create_account" {
            print("identifier = ", identifier)
            print(usernameTextField.text! + ": " + passwordTextField.text!)
            Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!)
            { user, error in
                if error != nil {
                    self.raiseErrorAlert(with_title: "Account Setup Error", with_message: error!.localizedDescription)
                    performSegue = false
                } else {
                    let InternalSetUp : ReturnValue = self.database
                            .createUserModelFromEmail(email: self.usernameTextField.text!)
                    if InternalSetUp.returned_error {
                        self.raiseErrorAlert(with_title: "Internal Error", with_message: InternalSetUp.getErrorDescription())
                        performSegue = false
                    }
                }
            }
        }
        if !performSegue {
            return performSegue
        }
        print(usernameTextField.text! + ", " + passwordTextField.text!)
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { user, error in
            if error != nil {
                performSegue = false
                self.raiseErrorAlert(with_title: "Error", with_message: error!.localizedDescription)
            } else {
                self.userLoggingIn = self.database.getUserModelFromEmail(email: self.usernameTextField.text!).data
                if self.userLoggingIn == nil {
                    performSegue = false
                }
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AllHousesPageViewController {
            let vc = segue.destination as? AllHousesPageViewController
            vc?.currentUser = userLoggingIn
        }
    }

    func raiseErrorAlert(with_title title: String, with_message message: String) {
        let alert = UIAlertController(title: title,
                                      message: message ,
                                      preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue",
                                           style: .default)
        alert.addAction(continueAction)
        present(alert, animated: true, completion: nil)
        passwordTextField.text = ""
        print(message)
    }

}

