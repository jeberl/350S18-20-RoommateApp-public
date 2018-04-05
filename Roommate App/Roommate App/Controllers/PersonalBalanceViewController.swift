//
//  PersonalBalanceViewController.swift
//  Roommate App
//
//  Created by Elena Iaconis on 4/5/18.
//  Copyright © 2018 Team 20. All rights reserved.
//


import Foundation

import UIKit
import FirebaseAuth

/*
 Controls rendering the balances that are directly related to the currently logged in account
 */
class PersonalBalanceViewController: UITableViewController {
    
    var currentUser : UserAccount! // Current user
    var charges : [String]! = [String]()
    var chargeIds : [String]! = [String]()
    var chargeData : [NSDictionary]! = [NSDictionary]()
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        let userChargeClosure = { (returnedChargeIds : [String]?) -> Void in
            if let returnedChargeIds = returnedChargeIds {
                self.chargeIds = returnedChargeIds
                let chargeDataClosure = { (data : NSDictionary?) -> Void in
                    if let data = data {
                        self.chargeData.append(data)
                    }
                    self.tableView.reloadData()
                }
                
                for charge in self.chargeIds! {
                    self.database.getChargeData(chargeID: charge, callback: chargeDataClosure)
                }
            }
            else {
                print("House Charges not found!")
            }
        }
        self.database.getHouseCharges(houseId: currentHouseID!, callback: userChargeClosure)
        
    }
    
    @IBAction func createChargeButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "createChargeStoryboard", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "CreateChargeController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Only need one section in table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return number of rows equal to number of houses
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chargeIds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if chargeData.count > indexPath.row {
            print("in personal balances")
            let timestamp = chargeData![indexPath.row].value(forKey: "time_charged")!
            let amount = chargeData![indexPath.row].value(forKey: "amount")! //credit or debit
            var userFrom  = chargeData![indexPath.row].value(forKey: "takeFromUID") as? String
            var userTo  = chargeData![indexPath.row].value(forKey: "giveToUID") as? String
            var currUser = Auth.auth().currentUser?.uid as? String
            if currUser == userFrom || currUser == userTo {
                var userNnOne : String = ""
                var userNnTwo : String = ""
                let getNnClosure = { (returnedNn: String?) -> Void in
                    userNnOne = returnedNn ?? "NicknameNotFound"
                }
                let getNnClosureTwo = { (returnedNn2: String?) -> Void in
                    userNnTwo = returnedNn2 ?? "NicknameNotFound"
                    if (userFrom! == currUser) {
                        userNnOne = "you"
                    }
                    if (userTo! == currUser) {
                        userNnTwo = "you"
                    }
                    cell.textLabel?.text = ("\(userNnOne) and \(userNnTwo) have $\(amount) transaction ")
                }
                self.database.getNicknameFromUID(uid: userFrom!, callback: getNnClosure)
                self.database.getNicknameFromUID(uid: userTo!, callback: getNnClosureTwo)
            }
        }
        return cell
    }
    
    // connect this page to the feed page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currentChargeId = chargeIds[indexPath.row]
    }
    
}
