//
//  CreateChargeController.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/29/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class CreateChargeController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var charge : Charge?
    var houseMemberUserNames : [String] = []
    var selectedMembers : Set<Int> = Set()
    
    @IBOutlet weak var amountTextFeild: UITextField!
    @IBOutlet weak var chargePaySwitch: UISegmentedControl!
    @IBOutlet weak var transactionDescriptionTextFeild: UITextView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextFeild.keyboardType = UIKeyboardType.numberPad
        amountTextFeild.textAlignment = NSTextAlignment.right
        charge = nil
        
        houseMemberUserNames = ["Test House Member 1", "Test House Member 2", "Test House Member 3"]
        selectedMembers.insert(0)
        
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
    
    @IBAction func DisplayText(_ sender: UITextField) {
        let newCents = getCentsFromTextField()
        amountTextFeild.text = getTextFromCents(cents: newCents);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseMemberUserNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseMemberCell", for: indexPath)
        cell.textLabel?.text = houseMemberUserNames[indexPath.row]
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
