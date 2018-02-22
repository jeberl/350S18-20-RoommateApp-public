//
//  ProfileController.swift
//  Roommate App
//
//  Created by Nick Buckenham on 2/21/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITableViewDataSource {
    
    let initialOptions = ["Edit Profile", "Edit House"]
    
    // methods for TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cellText = initialOptions[indexPath.row]
        cell.textLabel?.text = cellText
        return cell
    }
    
    // methods for view
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
