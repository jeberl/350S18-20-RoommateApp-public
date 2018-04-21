//
//  CreateChargeController.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/29/18.
//  Copyright © 2018 Team 20. All rights reserved.
//
// Controls create charge page by taking in user input about the charge and creating it in the database
//

import UIKit
import FirebaseAuth

class CreateChargeController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedMembersUIDs : Set<String> = Set()
    
    @IBOutlet weak var amountTextFeild: UITextField!
    @IBOutlet weak var chargePaySwitch: UISegmentedControl!
    @IBOutlet weak var transactionDescriptionTextFeild: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading create charge VC")
        
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        amountTextFeild.keyboardType = UIKeyboardType.numberPad
        amountTextFeild.textAlignment = NSTextAlignment.right
        
    }
    
    private func getCentsFromTextField() -> Int {
        let text = amountTextFeild.text
        let numbers = text!.filter({ (char) -> Bool in
            return "0123456789".contains(char)
        })
        return Int(numbers)!
    }
    
    private func getTextFromCents(cents: Int) -> String {
        var decimal = String(cents % 100)
        if cents % 100 < 10 {
            decimal = "0\(decimal)"
        }
        return "$ \(cents / 100).\(decimal)"
    }
    
    @IBAction func createChorePressed() {
        let message = transactionDescriptionTextFeild.text
        if message == "" || message?.lowercased() == "message" {
            chargeNeedsMessageError()
        } else if getCentsFromTextField() == 0 {
            zeroAmoutError()
        } else if selectedMembersUIDs.contains(Auth.auth().currentUser!.uid) {
            chargeSelfError()
        } else {
            confirm()
        }
    }
    
    @IBAction func unwindToView(_ sender: UIStoryboardSegue) { }
    
    func addChargesToDB(dollars: Double, charge: Bool) {
        let database = DatabaseAccess.getInstance()
        var result : ReturnValue<Bool> = ExpectedExecution<Bool>()
        for otherUID in selectedMembersUIDs {
            var (notifFrom , notifTo) : (Notification?, Notification?) = (nil, nil)
            var (takeFromUID, giveToUID) = ("", "")
            //Charge Selected Users
            var otherNickname = ""
            if charge {
                giveToUID = Auth.auth().currentUser!.uid
                takeFromUID = otherUID
                otherNickname = currentHouseUIDtoNickname[otherUID] ?? otherUID
                notifFrom = Notification(houseID: currentHouseID!, UIDsInvolved: [takeFromUID], type: "Charge", description: "\(currentUserLocalNickName) charged you $ \(dollars)")
                /*notifTo = Notification(houseID: currentHouseID!, UIDsInvolved: [giveToUID], type: "Charge", description: "You charged \(otherNickname) $ \(dollars)")*/ // this is pointless
                database.addNotification(notification: notifFrom!)
            }
                //Pay Selected Users
            else {
                takeFromUID = Auth.auth().currentUser!.uid
                giveToUID = otherUID
                otherNickname = currentHouseUIDtoNickname[otherUID] ?? otherUID
                /*notifFrom = Notification(houseID: currentHouseID!, UIDsInvolved: [takeFromUID], type: "Charge", description: "You paid \(otherNickname) $ \(dollars)!")*/ // this is pointless
                notifTo = Notification(houseID: currentHouseID!, UIDsInvolved: [giveToUID], type: "Charge", description: "\(currentUserLocalNickName) paid you $ \(dollars)")
                database.addNotification(notification: notifTo!)
            }
            let charge = Charge(takeFromUID: takeFromUID, giveToUID: giveToUID, houseID: currentHouseID!, amount: dollars, message: transactionDescriptionTextFeild.text)
            result = database.createCharge(charge: charge)
            if result.returned_error {
                raiseError(title : "Couldnt completed charge with \(otherNickname)")
            }
        }
        if !result.returned_error {
            returnPopup(title : "Sucessfully added charge(s)")
        }
    }
    
    func confirm() {
        let cents = getCentsFromTextField()
        let dollars = Double(cents) / Double(100)
        let charge = chargePaySwitch.selectedSegmentIndex == 0
        var title = "Are you sure you want to "
        if charge {
            title.append("charge $\(dollars) to ")
        } else {
            title.append("settle up to the amount of $\(dollars) with ")
        }
        for otherMemberUID in selectedMembersUIDs {
            title.append((currentHouseUIDtoNickname[otherMemberUID] ?? otherMemberUID)  + ", ")
        }
        title.removeLast()
        title.removeLast()
        title.append("?")
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Not Yet", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler : { (alert) in
            self.addChargesToDB(dollars: dollars, charge: charge)
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func returnPopup(title : String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_) in
            self.performSegue(withIdentifier: "unwindToBalances", sender: self)
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    func chargeNeedsMessageError() {
        raiseError(title : "Please enter a messgae for the charge")
    }
    
    func zeroAmoutError() {
        raiseError(title : "Amount must be greater than 0")
    }
    
    func chargeSelfError() {
        raiseError(title : "You cannot charge/Settle up with yourself")
    }
    
    func raiseError(title : String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func DisplayText(_ sender: UITextField) {
        let newCents = getCentsFromTextField()
        amountTextFeild.text = getTextFromCents(cents: newCents);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentHouseUIDtoNickname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseMemberCell", for: indexPath)
        cell.textLabel?.text = currentHouseUIDtoNickname[currentHouseOrderedUIDs[indexPath.row]]
        if selectedMembersUIDs.contains(currentHouseOrderedUIDs[indexPath.row]) {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedMembersUIDs.contains(currentHouseOrderedUIDs[indexPath.row]) {
            selectedMembersUIDs.remove(currentHouseOrderedUIDs[indexPath.row])
        } else {
            selectedMembersUIDs.insert(currentHouseOrderedUIDs[indexPath.row])
        }
        print("caught pressed cell \(indexPath.row)")
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }

}
