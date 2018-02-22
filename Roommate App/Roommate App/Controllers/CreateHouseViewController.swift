//
//  CreateHouseViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 2/22/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class CreateHouseViewController: UIViewController {
    
    @IBOutlet weak var houseNameTextField: UITextField!
    @IBOutlet weak var houseaddressTextField: UITextField!
    @IBOutlet weak var homieUsernameTextField: UITextField!
    var currentUser : UserAccount?
    var homies: [String] = []
    var database: DatabaseAccess?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var homie = homieUsernameTextField!.text
        self.homies.append(homie!)
        homieUsernameTextField.text = ""
        let alert = UIAlertController(title: "Homie Added",
                                      message: "Homie Added!" ,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buildHomeButtonPressed(_ sender: Any) {
        var houseName = houseNameTextField!.text
        if ((houseName?.contains("."))! || (houseName?.contains("$"))! ||
        (houseName?.contains("["))! || (houseName?.contains("]"))! ||
            (houseName?.contains("#"))!){
            let alert = UIAlertController(title: "Invalid characters included in house name",
                                          message: "Invalid house name. Please do not include '.', '$', '#', '[', or  ']' in the house name." ,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            houseNameTextField!.text = ""
        }
        var address = houseaddressTextField!.text
        var newHome = House(uid: <#T##String#>, house_name: houseName!, house_users: homies, owner: (currentUser?.email)!, recent_charges: [], recent_interactions: [])
        self.database?.createHouse(newHouse: newHome)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destination is AllHousesPageViewController {
            let vc = segue.destination as? AllHousesPageViewController
            vc?.currentUser = currentUser
        }
    }
    

}
