//
//  AllHousesPageViewController.swift
//  Roommate App
//
//  Created by user136152 on 2/19/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class AllHousesPageViewController: UIViewController {
    
    var buttonToGetHere = ""
    var currentUser : UserAccount?
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = buttonToGetHere
        
        let setCurrentUserClosure = {(user : UserAccount)-> Void in
            print("found user in database in AllHouses User: \(user)")
            self.currentUser = user
        }
        
        if let error : Error = sharedDatabaseAccess.error_logging_in {
            loginError(message : error.localizedDescription)
        } else if Auth.auth().currentUser == nil {
            loginError()
        } else {
            testLabel.text = Auth.auth().currentUser!.email
            let error = sharedDatabaseAccess.getUserModelFromCurrentUser(callback: setCurrentUserClosure)
            if error.returned_error {
                error.raiseErrorAlert(with_title: "Error:", view: self)
            }
        }
        // Do any additional setup after loading the view.
    }

    func loginError(message : String = "User not found") {
        let title = "Error Logging in"
        print(title)
        let alert = UIAlertController(title: title,
                                      message: message ,
                                      preferredStyle: .alert)
        let returnAction = UIAlertAction(title:"Login Again",
                                         style: .default,
                                         handler:  { action in self.performSegue(withIdentifier: "loginErrorSegue", sender: self) })
        
        alert.addAction(returnAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.destination == ViewController() as UIViewController) {
            do {
                try Auth.auth().signOut()
            } catch {
                print("caught error signing out")
            }
        }
    }


}
