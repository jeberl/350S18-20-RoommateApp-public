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
        
        let userChargeClosure = { (returnedChargeIds : [String]?) -> Void in
            self.chargeIds = returnedChargeIds!
            
            let chargeDataClosure = { (data : String?) -> Void in
                self.chargeData.append(data!)
                self.tableView.reloadData()
            }
            
            self.chargeIds = returnedChargeIds!
            for charge in self.chargeIds! {
                self.database.getChargeMessage(chargeID: charge, callback: chargeDataClosure)
            }
        }
        let error1 = self.database.getHouseCharges(houseId: currentHouseID!, callback: userChargeClosure)
        if error1.returned_error {
            error1.raiseErrorAlert(with_title: "Error:", view: self)
        }
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
        print("presenting")
        let storyboard = UIStoryboard(name: "HouseScreen", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "BalanceViewController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
}

