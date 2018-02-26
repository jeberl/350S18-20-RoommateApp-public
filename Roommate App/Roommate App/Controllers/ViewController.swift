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
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Do anything that needs to be done before switching views
        let destination = segue.destination as? AllHousesPageViewController
        //destination?.currentUser = 
    }
    
    @IBAction func LogInButtonPressed(_ sender: Any) {
        database.login(username: usernameTextField.text!, password: passwordTextField.text!, view: self)
        
    }

    @IBAction func CreateAccountButtonPressed(_ sender: Any) {
        database.createAccount(username: usernameTextField.text!, password: passwordTextField.text!, view: self)
    }
}

