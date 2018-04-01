//
//  AllHousesPageViewController.swift
//  Roommate App
//
//  Created by behrbaum on 2/19/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class AllHousesPageViewController: UITableViewController {
    
    var currentUser : UserAccount! // Current user
    var nameToID : [String : String]! = [String : String]() // Houses names user is in mapped to corresponding house ids
    var houses : [String]! = [String]() // list of houses user is in
    var houseIds : [String]! = [String]() // Houses user is in in terms of house ids
    var database : DatabaseAccess = DatabaseAccess.getInstance()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x03/255, green: 0x7A/255, blue: 0xDE/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x03/255, green: 0xE5/255, blue: 0xB7/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        let userHouseClosure = { (returned_houseIds : [String]?) -> Void in
            
            self.houseIds = returned_houseIds
            
            let houseNameClosure = { (houseName : String?) -> Void in
                if houseName != nil {
                    self.houses.append(houseName!)
                    self.tableView.reloadData()
                }
            }
            
            self.houseIds = returned_houseIds ?? []
            for houseId in self.houseIds! {
                self.database.getStringHouseName(houseId: houseId, callback: houseNameClosure)
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
        currentHouseID = houseIds[indexPath.row]
        
        let storyboard = UIStoryboard(name: "HouseScreen", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "HouseTabBarController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
}
