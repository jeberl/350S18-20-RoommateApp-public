//
//  CreateHouseViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 2/22/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateHouseViewController: UIViewController {
    
    @IBOutlet weak var houseNameTextField: UITextField!
    @IBOutlet weak var houseaddressTextField: UITextField!
    @IBOutlet weak var homieUsernameTextField: UITextField!
    var currentUser : UserAccount?
    var homies: [String] = []
    var database: DatabaseAccess?
    var newHome : House!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        database = DatabaseAccess.getInstance()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var alert = UIAlertController(title: "Invalid Name",
                                              message: "Try again",
                                              preferredStyle: .alert)
        if let homie = homieUsernameTextField!.text {
            self.homies.append(homie)
            homieUsernameTextField.text = ""
            alert = UIAlertController(title: "Homie Added",
                                          message: "Homie Added!" ,
                                          preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buildHomeButtonPressed(_ sender: Any) {
        let houseName = houseNameTextField!.text
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
        let address = houseaddressTextField!.text
        // Create new house object to add to database
        let newHome = House(house_name: houseName!, address : address!, house_users: homies, owner: Auth.auth().currentUser!.email!, recent_charges: [], recent_interactions: [])
        self.newHome = self.database!.createHouse(house: newHome)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
