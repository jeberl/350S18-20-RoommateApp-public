//
//  ChoreListViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//
// Controls the chore list page.  Displays all chores a user needs to complete by getting these
// incomplete chores from the database and displaying to the user
//

import UIKit
import FirebaseAuth

class ChoreListViewController: UITableViewController {
    
    var currentUser : UserAccount! // Current user
    var incompleteChoreNames : [String]! = [String]() // Chores in the house
    var incompleteChoreIDs : [String]! = [String]() // ChoreIDs of chores in the house
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    let layer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateTableView()
        
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
    }
    
    // unwind without clearing
    @IBAction func unwindToChoresList(_ sender: UIStoryboardSegue) {
        
    }
    
    // unwind with clearing
    @IBAction func unwindToChoresListFromCreateChore(_ sender: UIStoryboardSegue) {
        // reset these two variables to prevent duplication in
        // unwind segue
        incompleteChoreNames.removeAll()
        incompleteChoreIDs.removeAll()
        self.tableView.reloadData()
    }
    
    // rotates gradient background when phone is put in landscape
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.frame = self.view.bounds
        CATransaction.commit()
    }
    
    func updateTableView() {
        
        // reset these two variables to prevent duplication in
        // unwind segue
        incompleteChoreNames.removeAll()
        incompleteChoreIDs.removeAll()
        self.tableView.reloadData()
        
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
    
    // Only need one section in table because only displaying chores
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incompleteChoreNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if incompleteChoreNames.count == 0 {
            print("Array is empty")
        }
        //ERROR OCCURS HERE (INDEX OUT OF RANGE)
        let choreName = incompleteChoreNames[indexPath.row]
        cell.textLabel?.font = UIFont .systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)
        cell.textLabel?.text = choreName
        return cell
    }
    
    // connect this page to the chore view page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentChoreID = incompleteChoreIDs[indexPath.row]
        
        let storyboard = UIStoryboard(name: "HouseScreen", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "ChoreViewStoryboard") as! UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
