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
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x03/255, green: 0x7A/255, blue: 0xDE/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x03/255, green: 0xE5/255, blue: 0xB7/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        
        /*var new:[String] = []
        self.database.getListOfHousesUserMemberOf(email: "me@emailcom", callback: {(houses)-> Void in
            print("got houses:\(houses)")
            new = houses
        })
        /*print("here")
        let newNotif = Notification(houseID: "test", houseName: "test", usersInvolved: ["test"], timestamp: NSDate.init(), type: "test")
        var userUid: String? = nil;
        self.database.getUserUidFromEmail(email: "emi@email.com", callback: {(uid) -> Void in
            print("the uid is:\(uid)")
            userUid = uid!
            self.database.addNotification(notification: newNotif, usersInvolved: [userUid!])
        })
        let newNotif = Notification(houseID: "test", houseName: "test", usersInvolved: ["emi@email.com"], timestamp: NSDate.init(), type: "test")
        var currentGlobalNickname: String = "hi"
        let userGlobalNicknameClosure = { (returnedGlobalNickname: String?) -> Void in
            currentGlobalNickname = returnedGlobalNickname!
            print(currentGlobalNickname)
            self.database.addNotification(notification: newNotif, usersInvolved: [currentGlobalNickname])
        }
        
        let errorGlobalNickname = self.database.getUserUidFromEmail(email: "emi@email.com", callback: userGlobalNicknameClosure)
            if errorGlobalNickname.returned_error {
                errorGlobalNickname.raiseErrorAlert(with_title: "error", view: self)
        }*/
        self.database.getNotifications(callback: {(uid) -> Void in
            print("notif:\(uid!)")
            self.database.getNotifData(notifId: uid![0], callback: {(notif) -> Void in
                print(notif!.value(forKey: "type")!)
            })
        })
        //database.deleteNotification(notifId: "-L84AwQ5wP-uSPeLzUPw")
        //database.removeNotification(notifId: "-L84AwQ5wP-uSPeLzUPw")
        // Do any additional setup after loading the view, typically from a nib.
        })
     */
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
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AllHousesPageViewController {
            let vc = segue.destination as? AllHousesPageViewController
            vc?.currentUser = userLoggingIn
            vc?.buttonToGetHere = buttonPressed
        }
    }
    */

    @IBAction func CreateAccountButtonPressed(_ sender: Any) {
        database.createAccount(username: usernameTextField.text!, password: passwordTextField.text!, view: self)
    }
    
    //Remove - For testing
    @IBAction func segToCreateCharge(_ sender: Any) {
        performSegue(withIdentifier: "addChargeSeg", sender: self)
    }
}

