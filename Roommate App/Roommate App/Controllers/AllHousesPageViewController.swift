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
        
    var buttonToGetHere = ""
    var currentUser : UserAccount?
    //var houses : ()?
    var houses = ["House 1", "House 2", "House 3"]
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    var houseAdded : String?
    
    @IBOutlet weak var testLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let setCurrentUserClosure = {(user : UserAccount)-> Void in
            print("found user in database in AllHouses User: \(user)")
            self.currentUser = user
            self.testLabel.text = user.email
        }
        
        if Auth.auth().currentUser == nil {
            loginError()
        } else {
            let error = database.getUserModelFromCurrentUser(view: self, callback: setCurrentUserClosure)
            if error.returned_error {
                error.raiseErrorAlert(with_title: "Error:", view: self)
            }
        }
        // Do any additional setup after loading the view.
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
