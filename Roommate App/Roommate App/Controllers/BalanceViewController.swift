//
//  BalanceViewController.swift
//  Roommate App
//
//  Created by Elena Iaconis on 3/31/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation

import UIKit
import FirebaseAuth

class BalanceViewController: UITableViewController {
    
    var currentUser : UserAccount! // Current user
    var charges : [String]! = [String]()
    var chargeIds : [String]! = [String]()
    var chargeData : [String]! = [String]()
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        // Load pending charges specific to house with most recent charge at the top - need front end to test this since
        //can't do getters in test cases
        var sortedChargeIDs : [String]! = [String]()  // Array of charge IDs where most recent charge is first
        var timeToID = [String : String]() // Dictionary of timestamps mapped to their corresponding charge ID
        var sortedChargeMessages : [String]! = [String]()  // Array of charge messages where most recent change is first
        var sortedChargeAmounts : [String]! = [String]() // Array of charge amounts where most recent charge is first
        
        // Closure to map time stamp to charge ID
        let getChargeTimeStampClosure = { (idAndTime : [String]?) -> Void in
            timeToID[(idAndTime?[1])!] = idAndTime?[0]
        }
        
        // Closure to add charge message to sorted charge messages
        let getChargeMessageClosure = { (chargeMessage : String?) -> Void in
            sortedChargeMessages.append(chargeMessage!)
        }
        
        // Closure to add charge amount to sorted charge amounts
        let getChargeAmountClosure = { (chargeAmount : String?) -> Void in
            sortedChargeAmounts.append(chargeAmount!)
        }
        
        // Closure to sort house charges
        let sortHouseChargesClosure = { (returnedChargeIDs : [String]?) -> Void in
            let chargeIDs = returnedChargeIDs ?? []
            
            // For each charge id, get the timestamp
            for chargeID in chargeIDs {
                self.database.getChargeTimeStamp(chargeID: chargeID, callback: getChargeTimeStampClosure)
            }
            
            // Array of timestamps sorted with most recent first
            var timestamps : [String] = [String](timeToID.keys.sorted(by: >))
            
            // Iterate through each time stamp in order to get the corresponding charge ID and append it to the sorted
            // list of charge IDs
            while (timestamps.count > 0) {
                let timestamp : String = timestamps.removeFirst()
                let id : String = timeToID[timestamp]!
                sortedChargeIDs.append(id)
            }
            
            // I think this will loop through and preserve order?
            // Loop through all charge IDs in sorted order to get the charge message and amount for the front end
            // to display
            for chargeID in sortedChargeIDs {
                self.database.getChargeMessage(chargeID: chargeID, callback: getChargeMessageClosure)
                self.database.getChargeAmount(chargeID: chargeID, callback: getChargeAmountClosure)
            }
            
        }
        self.database.getHouseCharges(houseId: currentHouseID!, callback: sortHouseChargesClosure)
        
        // Load pending charges specific to user with most recent charge at the top - need front end to test this since can't do getters in test cases
        /*
        var sortedChargeIDs : [String]! = [String]()
        var timeToID = [String : String]()
        var sortedChargeMessages : [String]! = [String]()
        var sortedChargeAmounts : [String]! = [String]()
        
        let getChargeTimeStampClosure = { (idAndTime : [String]?) -> Void in
            timeToID[(idAndTime?[1])!] = idAndTime?[0]
        }
        
        let getChargeMessageClosure = { (chargeMessage : String?) -> Void in
            sortedChargeMessages.append(chargeMessage!)
        }
        
        let getChargeAmountClosure = { (chargeAmount : String?) -> Void in
            sortedChargeAmounts.append(chargeAmount!)
        }
        
        let sortUserChargesClosure = { (returnedChargeIDs : [String]?) -> Void in
            let chargeIDs = returnedChargeIDs ?? []
            for chargeID in chargeIDs {
                self.database.getChargeTimeStamp(chargeID: chargeID, callback: getChargeTimeStampClosure)
            }
            
            var timestamps : [String] = [String](timeToID.keys.sorted(by: >))
            while (timestamps.count > 0) {
                let timestamp : String = timestamps.removeFirst()
                let id : String = timeToID[timestamp]!
                sortedChargeIDs.append(id)
            }
            
            // I think this will loop through and preserve order?
            for chargeID in sortedChargeIDs {
                self.database.getChargeMessage(chargeID: chargeID, callback: getChargeMessageClosure)
                self.database.getChargeAmount(chargeID: chargeID, callback: getChargeAmountClosure)
            }
            
        }
        self.database.getUserCharges(uid: (Auth.auth().currentUser?.uid)!, callback: sortUserChargesClosure)
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*@IBAction func addChargeButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateCharge", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "AddChargeController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }*/
    
    
    // Only need one section in table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return number of rows equal to number of houses
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* print("notifications.count = \(notifIds.count)")
        return notifIds.count*/
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        /*if notifData.count > indexPath.row {
            
            cell.textLabel?.text = String(notifData![indexPath.row])
        }
        return cell*/
        return cell
    }
    
    // connect this page to the feed page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "HouseScreen", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "HouseTabBarController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

