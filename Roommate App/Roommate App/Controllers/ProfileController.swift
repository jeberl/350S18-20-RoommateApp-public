//
//  ProfileController.swift
//  Roommate App
//
//  Created by Nick Buckenham on 2/21/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

/*
 Controls rendering the current user/house info and allows options to edit
 */
class ProfileController: UITableViewController {
    
    let initialOptions = ["Edit Profile", "Edit House", "View Housemates"]
    
    // methods for TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return initialOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cellText = initialOptions[indexPath.row]
        cell.textLabel?.text = cellText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            performSegue(withIdentifier: "UserProfileSegue", sender: self)
        } else if (indexPath.row == 1) {
            performSegue(withIdentifier: "HouseProfileSegue", sender: self)
        } else if (indexPath.row == 2) {
            performSegue(withIdentifier: "HousematesSegue", sender: self)
        }
    }
    
    
    
    // methods for view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutOfHouse(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "AllHousesPageViewController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
        
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
