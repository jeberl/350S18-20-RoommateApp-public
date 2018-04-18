//
//  InDaHausTableViewController.swift
//  Roommate App
//
//  Created by user136152 on 4/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class InDaHausTableViewController: UITableViewController {
    
    let database : DatabaseAccess = DatabaseAccess.getInstance()
    var allRoommateIDs : [String] = []
    var homeRoomates : [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up background color
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)

        // Closure to handle receiving all user IDs of users in the house
        let allUsersClosure = { (allIDs : [String]?) -> Void in
            self.allRoommateIDs = allIDs ?? [] // initialize as empty if house has no roommates
            // Check if each roommate is home
            for id in self.allRoommateIDs {
                // Closure to handle receiving boolean of if the user is in da haus
                let userInDaHausClosure = { (isHome: Bool) -> Void in
                    // If roommate is in da haus, append thier id to the home roommates
                    if isHome {
                        self.allRoommateIDs.append(id)
                        // Closure to handle receiving the user's local nickname and appends it to the list
                        // of nicknames of users in da haus
                        let userNicknameClosure = { (nickname : String?) -> Void in
                            self.homeRoomates.append(nickname!)
                            self.tableView.reloadData()
                        }
                        // Database call to get user's local nickname
                        self.database.getUserLocalNicknamefromUID(fromHouse: currentHouseID!, uid: id,
                                                                  callback: userNicknameClosure)
                    }
                }
                // Database call to see if a user is home
                self.database.isUserHome(uid: id, houseID: currentHouseID!, callback: userInDaHausClosure)
            }
        }
        // Database call to get all roommates of the current house
        self.database.getAllUsersInHouse(houseID: currentHouseID!, callback: allUsersClosure)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Return number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeRoomates.count
    }

    // Populates TableView cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cellText = homeRoomates[indexPath.row]
        cell.textLabel?.text = cellText
        cell.textLabel?.font = UIFont .systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)
        return cell
    }

}
