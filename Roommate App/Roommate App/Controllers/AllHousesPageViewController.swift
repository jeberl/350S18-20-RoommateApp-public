//
//  AllHousesPageViewController.swift
//  Roommate App
//
//  Created by user136152 on 2/19/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class AllHousesPageViewController: UIViewController, UITableViewDataSource {
    
    var currentUser : UserAccount?
    //var houses : ()?
    let houses = ["House 1", "House 2", "House 3"]
    var db : DatabaseAccess = DatabaseAccess()
    
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    // Only need one section in table because only displaying houses
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return number of rows equal to number of houses
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        var houseName = houses[indexPath.row]
        cell.textLabel?.text = houseName
        return cell
    }
}
