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
    var selectedMembers : Set<Int> = Set()
    
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
                let cents = getCentsFromTextField()
                let dollars = Double(cents) / Double(100)
                var (notifFrom , notifTo) : (Notification?, Notification?) = (nil, nil)
                var (from, to) = ("", "")
                //Charge Selected Users
                if chargePaySwitch.selectedSegmentIndex == 0 {
                    to = Auth.auth().currentUser!.uid
                    from = currentHouseMemberUIDs![otherMemberIndex]
                    let fromNickname = currentHouseMemberNicknames![otherMemberIndex]
                    notifFrom = Notification(houseID: currentHouseID!, usersInvolved: [from], type: "Charge", description: "\(currentUserLocalNickName!) charged you $ \(dollars)")
                    notifTo = Notification(houseID: currentHouseID!, usersInvolved: [to], type: "Charge", description: "You charged \(fromNickname) $ \(dollars)")
                }
                    //Pay Selected Users
                else if chargePaySwitch.selectedSegmentIndex == 1 {
                    from = Auth.auth().currentUser!.uid
                    to = currentHouseMemberUIDs![otherMemberIndex]
                    let toNickname = currentHouseMemberNicknames![otherMemberIndex]
                    notifFrom = Notification(houseID: currentHouseID!, usersInvolved: [from], type: "Charge", description: "You paid \(toNickname) $ \(dollars)!")
                    notifTo = Notification(houseID: currentHouseID!, usersInvolved: [to], type: "Charge", description: "\(currentUserLocalNickName!) payed you $ \(dollars)")
                }
                let charge = Charge(fromUser: from, toUser: to, houseID: currentHouseID!, amount: dollars, message: transactionDescriptionTextFeild.text)
                database.createCharge(charge: charge)
                database.addNotification(notification: notifFrom!, usersInvolved: [from])
                database.addNotification(notification: notifTo!, usersInvolved: [to])

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
        return currentHouseMemberNicknames!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseMemberCell", for: indexPath)
        cell.textLabel?.text = currentHouseMemberNicknames![indexPath.row]
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
