//
//  FeedViewController.swift
//  Roommate App
//
//  Created by Elena Iaconis on 3/21/18.
//  Copyright © 2018 Team 20. All rights reserved.
//
// Controls the feed page.  Grabs all notifications specific to a user in the database
// and displays it to the current user
//

import UIKit
import FirebaseAuth

class FeedViewController: UITableViewController {
    
    var currentUser : UserAccount! // Current user
    var notifications : [String]! = [String]()
    var notifIds : [String]! = [String]()
    var notifData : [String]! = [String]()
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    let layer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        let userNotifClosure = { (returnedNotifIds : [String]?) -> Void in
            self.notifIds = returnedNotifIds!
            
            let notifDataClosure = { (data : NSDictionary?) -> Void in
                var currHouseId = data?.value(forKey: "houseID") as? String
                let type = data?.value(forKey: "type") as? String
                if currHouseId == currentHouseID && type != "Charge"  {
                    if let value = data?.value(forKey: "description") as? String {
                        print(value)
                        self.notifData.append(value)
                        self.tableView.reloadData()
                    }
                } else if type == "Charge" {
                    let value = data?.value(forKey: "description") as? String
                    self.notifData.append(value!)
                    self.tableView.reloadData()
                }
            }
            
            self.notifIds = returnedNotifIds!
            for notif in self.notifIds! {
                self.database.getNotifData(notifId: notif, callback: notifDataClosure)
            }
        }
        let error1 = self.database.getNotifications(callback: userNotifClosure)
        if error1.returned_error {
            error1.raiseErrorAlert(with_title: "Error:", view: self)
        }
    }
    
    func loadData() {
        // code to load data from network, and refresh the interface
        tableView.reloadData()
    }
    
    func loginError(message : String = "User not found") {
        let title = "Error Logging in"
        print(title)
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let returnAction = UIAlertAction(title:"Login Again",
                                         style: .default,
                                         handler:  { action in self.performSegue(withIdentifier: "loginErrorSegue", sender: self) })
        
        alert.addAction(returnAction)
        present(alert, animated: true, completion: nil)
    }
    
    // rotates gradient background when phone is put in landscape
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.frame = self.view.bounds
        CATransaction.commit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the selected object to the new view controller.
        if (segue.destination == ViewController() as UIViewController) {
            do {
                try Auth.auth().signOut()
            } catch {
                print("caught error signing out")
            }
        }
    }
    
    // Only need one section in table 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return number of rows equal to number of houses
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("notifications.count = \(notifIds.count)")
        return notifIds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.font = UIFont .systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)
        if notifData.count > indexPath.row {
            if indexPath.row == 0 {
                
            } else {
                cell.textLabel?.text = String(notifData![indexPath.row])
            }
            cell.textLabel?.text = String(notifData![indexPath.row])
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // connect this page to the feed page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "HouseScreen", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "HouseTabBarController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    //@IBAction func unwindToFeed(segue:UIStoryboardSegue) { }
}

