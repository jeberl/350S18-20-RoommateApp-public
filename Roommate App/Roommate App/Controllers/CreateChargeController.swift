//
//  CreateChargeController.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/29/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateChargeController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var houseMemberNickNames : [String] = []
    var houseMemberUIDs : [String] = []
    var selectedMembers : Set<Int> = Set()
    var houseID : String = ""
    
    @IBOutlet weak var amountTextFeild: UITextField!
    @IBOutlet weak var chargePaySwitch: UISegmentedControl!
    @IBOutlet weak var transactionDescriptionTextFeild: UITextView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        } else {
            let database = DatabaseAccess.getInstance()
            for otherMemberIndex in selectedMembers {
                var (from, to) = ("", "")
                //Charge Selected Users
                if chargePaySwitch.selectedSegmentIndex == 0 {
                    from = Auth.auth().currentUser!.uid
                    to = houseMemberUIDs[otherMemberIndex]
                }
                    //Pay Selected Users
                else if chargePaySwitch.selectedSegmentIndex == 1 {
                    to = Auth.auth().currentUser!.uid
                    from = houseMemberUIDs[otherMemberIndex]
                }
                let cents = getCentsFromTextField()
                let dollars = Double(cents) / Double(100)
                let charge = Charge(from_user: from, to_user: to, houseID: houseID, timestamp: "", amount: dollars, message: transactionDescriptionTextFeild.text)
                database.createCharge(charge: charge)
                let notif = Notification(houseID: houseID, usersInvolved: [from, to], timestamp: "", type: <#T##String#>, description: <#T##String#>)
                database.addNotification(notification: notif, usersInvolved: [from, to])
            }
        }
    }
    
    func chargeNeedsMessageError() {
        let alert = UIAlertController(title: "Please enter a messgae for the charge", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func DisplayText(_ sender: UITextField) {
        let newCents = getCentsFromTextField()
        amountTextFeild.text = getTextFromCents(cents: newCents);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseMemberNickNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseMemberCell", for: indexPath)
        cell.textLabel?.text = houseMemberNickNames[indexPath.row]
        if selectedMembers.contains(indexPath.row) {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedMembers.contains(indexPath.row) {
            selectedMembers.remove(indexPath.row)
        } else {
            selectedMembers.insert(indexPath.row)
        }
        print("caught pressed cell \(indexPath.row)")
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }

}
