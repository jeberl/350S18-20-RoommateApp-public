//
//  FeedViewController.swift
//  Roommate App
//
//  Created by Elena Iaconis on 3/21/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class FeedViewController: UITableViewController {
    
    var currentUser : UserAccount! // Current user
    var notifications : [String]! = [String]()
    var notifIds : [String]! = [String]()
    var notifData : [String]! = [String]()
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userNotifClosure = { (returnedNotifIds : [String]?) -> Void in
            self.notifIds = returnedNotifIds!
            
            let notifDataClosure = { (data : NSDictionary?) -> Void in
                if data != nil {
                    self.notifData.append(data!.value(forKey: "description") as! String)
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
        let notifString = "New Notification: \(notifData![indexPath.row])"
        cell.textLabel?.text = notifString
        return cell
    }
    
    // connect this page to the feed page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "HouseScreen", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "HouseTabBarController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
        
    }
}

