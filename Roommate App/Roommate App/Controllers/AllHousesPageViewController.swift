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
    var houses : [String]! = [String]() // Houses user is in
    var house_ids : [String]! = [String]() // Houses user is in in terms of house ids
    var database : DatabaseAccess = DatabaseAccess.getInstance()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userHouseClosure = { (returned_house_ids : [String]?) -> Void in
            print(returned_house_ids)
            print("UHC; in user house closure")
            self.house_ids = returned_house_ids
            
            let houseNameClosure = { (house_name : String?) -> Void in
                print("HNC: in house name closure")
                if house_name != nil {
                    print("HNC: house name is not nil")
                    self.houses.append(house_name!)
                    self.tableView.reloadData()
                }
            }
            
            self.house_ids = returned_house_ids ?? []
            print("starting to translate house ids into names")
            for house_id in self.house_ids! {
                self.database.getStringHouseName(house_id: house_id, callback: houseNameClosure)
            }
        }
        print("PC: user uid = \(Auth.auth().currentUser!.uid)")
        print("PC: user email = \(Auth.auth().currentUser!.email)")
        let error1 = self.database.getListOfHousesUserMemberOf(email: Auth.auth().currentUser!.email!, callback: userHouseClosure)
        if error1.returned_error {
            error1.raiseErrorAlert(with_title: "Error:", view: self)
        }
//        } else if houseIDOfAdded != nil && houseNameOfAdded != nil {
//            house_ids.append(houseIDOfAdded!)
//            houses.append(houseNameOfAdded!)
//            houseIDOfAdded = nil
//            houseNameOfAdded = nil
//        }
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
