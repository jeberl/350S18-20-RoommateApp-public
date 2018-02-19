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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!)
        let alert = UIAlertController(title: "Login to Account",
                                      message: "Login to Account",
                                      preferredStyle: .alert)
        //present(alert, animated: true, completion: nil)
        buttonPressed = sender.titleLabel!.text!
    }
    
    
    @IBAction func CreateAccountButtonPressed(_ sender: UIButton) {
        print("Button pressed")
        buttonPressed = sender.titleLabel!.text!
        let alert = UIAlertController(title: "Create Account",
                                      message: "Create Account",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Create",
                                       style: .default) { action in
            let enteredEmail = alert.textFields![0]
            let enteredPassword = alert.textFields![1]

            Auth.auth().createUser(withEmail: enteredEmail.text!, password: enteredPassword.text!)
            { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: self.usernameTextField.text!,
                                       password: self.passwordTextField.text!)
                } else {
                    print(error!.localizedDescription)
                }
            }

        }

        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)

        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }

        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        //present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AllHousesPageViewController {
            let vc = segue.destination as? AllHousesPageViewController
            vc?.buttonToGetHere = buttonPressed
        }
        
    }
}



