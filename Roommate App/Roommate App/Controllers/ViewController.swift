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

    let database: DatabaseAccess = sharedDatabaseAccess
    var buttonPressed = ""
    var userLoggingIn: UserAccount?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*var new:[String] = []
        self.database.getListOfHousesUserMemberOf(email: "me@emailcom", callback: {(houses)-> Void in
            print("got houses:\(houses)")
            new = houses
        })*/
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var retValue : ReturnValue<UserAccount>
        if identifier == "create_account" {
            if !createAccount(username: usernameTextField.text!, password: passwordTextField.text!) {
                
            }
        }
        retValue = database.login(username: usernameTextField.text!, password: passwordTextField.text!)
        if retValue.returned_error {
            let title = retValue.error_number == 50 ? "Error" : "Internal Error"
            raiseErrorAlert(with_title: title, with_message: retValue.error_message!)
            return false
        }
        userLoggingIn = retValue.data!
        return true
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

