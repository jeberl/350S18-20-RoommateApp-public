//
//  AllHousesPageViewController.swift
//  Roommate App
//
//  Created by user136152 on 2/19/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class AllHousesPageViewController: UITableViewController {
    
    var currentUser : UserAccount! // Current user
    var nameToID : [String : String]! = [String : String]() // Houses names user is in mapped to corresponding house ids
    var houses : [String]! = [String]() // list of houses user is in
    var house_ids : [String]! = [String]() // Houses user is in in terms of house ids
    var database : DatabaseAccess = DatabaseAccess.getInstance()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userHouseClosure = { (returned_house_ids : [String]?) -> Void in
            print(returned_house_ids)
            
            self.house_ids = returned_house_ids
            
            let houseNameClosure = { (houseInfo : [String]?) -> Void in
                if houseInfo != nil {
                    self.houses.append(houseInfo![1])
                    self.nameToID[houseInfo![1]] = houseInfo![0]
                    self.tableView.reloadData()
                }
            }
            
            self.house_ids = returned_house_ids ?? []
            for house_id in self.house_ids! {
                self.database.getStringHouseName(house_id: house_id, callback: houseNameClosure)
            }
        }
        let error1 = self.database.getListOfHousesUserMemberOf(email: Auth.auth().currentUser!.email!, callback: userHouseClosure)
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
        if segue.destination is HouseTabBarViewController {
            let vc = segue.destination as? HouseTabBarViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let currentHouseName = houses[indexPath.row]
                let currentHID = nameToID[currentHouseName]
                currentHouseID = currentHID
            }
        }
        
        // Pass the selected object to the new view controller.
        if (segue.destination == ViewController() as UIViewController) {
            do {
                try Auth.auth().signOut()
            } catch {
                print("caught error signing out")
            }
        }
    }

    // Only need one section in table because only displaying houses
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return number of rows equal to number of houses
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("houses.count = \(houses.count)")
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
        self.performSegue(withIdentifier: "goToTabBar", sender: self)
    }
}
