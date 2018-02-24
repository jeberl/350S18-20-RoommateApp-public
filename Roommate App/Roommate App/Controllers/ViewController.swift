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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "create_account" {
            database.createAccount(username: usernameTextField.text!, password: passwordTextField.text!)
        } else {
            database.login(username: usernameTextField.text!, password: passwordTextField.text!)
        }
        return Auth.auth().currentUser != nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Do anything that needs to be done before switching views
        
    }

}

