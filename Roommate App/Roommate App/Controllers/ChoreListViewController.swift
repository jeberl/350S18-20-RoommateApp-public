//
//  ChoreListViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChoreListViewController: UITableViewController {
    

    //@IBOutlet weak var choreCountLabel: UILabel!
    //@IBOutlet weak var createChoreButton: UIButton!
    //@IBOutlet weak var choreTableView: UITableView!
    //@IBOutlet weak var showCompletedButton: UIButton!
    var currentUser : UserAccount! // Current user
    var incompleteChoreNames : [String]! = [String]() // Chores in the house
    var incompleteChoreIDs : [String]! = [String]() // ChoreIDs of chores in the house
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let houseChoresClosure = {(returnedChoreIDs: [String]?) -> Void in
            self.incompleteChoreIDs = returnedChoreIDs
            let choreNameClosure = { (choreName : String?) -> Void in
                if choreName != nil {
                    self.incompleteChoreNames.append(choreName!)
                    self.tableView.reloadData()
                }
            }
            self.incompleteChoreIDs = returnedChoreIDs ?? []
            for choreID in self.incompleteChoreIDs {
                self.database.getStringChoreTitle(choreID: choreID, callback: choreNameClosure)
            }
        }
        let error1 = self.database.getHouseChores(houseID: currentHouseID!, callback: houseChoresClosure)
        if error1.returned_error {
            error1.raiseErrorAlert(with_title: "Error:", view: self)
        }
        /*choreTableView.delegate = self
        choreTableView.dataSource = self*/
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
        return incompleteChoreNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if incompleteChoreNames == nil {
            print("array is nil")
        }
        let choreName = incompleteChoreNames[indexPath.row]
        cell.textLabel?.text = choreName
        return cell
    }
    
    // connect this page to the house main page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentChoreID = incompleteChoreIDs[indexPath.row]
        
        let storyboard = UIStoryboard(name: "HouseScreen", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "ChoreViewController") as UIViewController
        
        
        self.present(controller, animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
