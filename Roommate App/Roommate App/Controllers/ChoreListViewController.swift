//
//  ChoreListViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class ChoreListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var choreCountLabel: UILabel!
    @IBOutlet weak var createChoreButton: UIButton!
    @IBOutlet weak var choreTableView: UITableView!
    @IBOutlet weak var showCompletedButton: UIButton!
    var currentUser : UserAccount! // Current user
    var chores : [ChoreAJ]! = [ChoreAJ]() // Chores in the house
    var chore_ids : [String]! = [String]() // ChoreIDs of chores in the house
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    var currentHouse : House!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        choreTableView.delegate = self
        choreTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = chores[indexPath.row].title
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
