//
//  AllHousesPageViewController.swift
//  Roommate App
//
//  Created by user136152 on 2/19/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class AllHousesPageViewController: UITableViewController {
    
    var currentUser : UserAccount?
    //var houses : ()?
    var houses = ["House 1", "House 2", "House 3"]
    var db : DatabaseAccess = DatabaseAccess()
    var houseAdded : String?
    
    @IBOutlet weak var testLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate Database to get list of houses user is in - need to fix database
        //houses = db.getListOfHousesUserMemberOf(email: currentUser!.email, callback: {(houses)-> Void in print("got houses:\(houses)")})
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the selected object to the new view controller.
        if segue.destination is CreateHouseViewController {
            let vc = segue.destination as? CreateHouseViewController
            vc?.currentUser = self.currentUser
        }
    }

    // Only need one section in table because only displaying houses
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return number of rows equal to number of houses
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if houseAdded != nil {
            houses.append(houseAdded!)
            houseAdded = nil
        }
        return houses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let houseName = houses[indexPath.row]
        cell.textLabel?.text = houseName
        return cell
    }
    
    // connect this page to the house main page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            // set current house to house clicked
        } else if (indexPath.row == 1) {
            // set current house to house clicked
        } else if (indexPath.row == 2) {
            // set current house to house clicked
        }
        
        let storyboard = UIStoryboard(name: "HouseScreen", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "HouseTabBarController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
}
