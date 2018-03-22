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

    let database: DatabaseAccess = DatabaseAccess.getInstance()

    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Do anything that needs to be done before switching views
    }
    
    @IBAction func LogInButtonPressed(_ sender: Any) {
        database.login(username: usernameTextField.text!, password: passwordTextField.text!, view: self)
    } 
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AllHousesPageViewController {
            let vc = segue.destination as? AllHousesPageViewController
            vc?.currentUser = userLoggingIn
            vc?.buttonToGetHere = buttonPressed
        }
    }*/

    @IBAction func CreateAccountButtonPressed(_ sender: Any) {
        database.createAccount(username: usernameTextField.text!, password: passwordTextField.text!, view: self)
    }
}

