//
//  HousematesViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 4/3/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

/*
 Controls rendering the users that are members of the currently logged in house
 */
class HousematesViewController: UITableViewController {
    
    let database : DatabaseAccess = DatabaseAccess.getInstance()
    var usernames : [String]! = [String]() // Users in the house
    var userIDs : [String]! = [String]() // userIDs of homies
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        let usernamesClosure = {(returnedUserIDs: [String]?) -> Void in
            self.userIDs = returnedUserIDs
            let usernameClosure = { (username : String?) -> Void in
                if username != nil {
                    self.usernames.append(username!)
                    self.tableView.reloadData()
                }
            }
            self.userIDs = returnedUserIDs ?? []
            for userID in self.userIDs {
                self.database.getUserGlobalNickname(forUid: userID, callback: usernameClosure)
            }
        }
        let error1 = self.database.getListOfUIDSInHouse(houseID: currentHouseID!, callback: usernamesClosure)
        if error1.returned_error {
            error1.raiseErrorAlert(with_title: "Error:", view: self)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Only need one section in table because only displaying chores
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usernames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if usernames.count == 0 {
            print("array is empty")
        }
        let username = usernames[indexPath.row]
        cell.textLabel?.text = username
        return cell
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
