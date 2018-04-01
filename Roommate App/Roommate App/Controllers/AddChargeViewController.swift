//
//  AddChargeController.swift
//  Roommate App
//
//  Created by Elena Iaconis on 3/31/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation

import UIKit
import FirebaseAuth

class AddChargeViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var userResponsibleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    // TODO add outlets
    let database : DatabaseAccess = DatabaseAccess.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addCharge(_ sender: Any) {
        print("Add charge button pressed")
        let strChargeAmount = amountTextField.text
        let chargeAmount = (strChargeAmount as NSString?)?.doubleValue
        let chargeUserResp = userResponsibleTextField!.text
        let chargeMessage = messageTextField!.text
        let date = self.database.getTimestampAsString()
        
        // Create new house object to add to database
        let assignor = Auth.auth().currentUser?.email!
        let newCharge = Charge(fromUser: assignor!, toUser: chargeUserResp!, houseID: currentHouseID!, timestamp: date, amount: chargeAmount!, message: chargeMessage!)
        self.database.createCharge(charge: newCharge) 
        // Notification for charge
        let newNotif = Notification(houseID: currentHouseID!, usersInvolved: [chargeUserResp!], timestamp: date, type: "Charge", description: "\(assignor ?? "Error: nil Assignor") charged you!")
        self.database.getUserUidFromEmail(email: chargeUserResp!, callback: {(uid) -> Void in
            print("the uid is:\(uid ?? "Error: nil UID")")
            if let uid = uid {
                self.database.addNotification(notification: newNotif, usersInvolved: [uid])
            } else {
                return
            }
        })
    }
    
    /*
     // MARK: - Navigation
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

