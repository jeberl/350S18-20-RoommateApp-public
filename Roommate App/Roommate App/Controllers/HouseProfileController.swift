//
//  HouseProfileController.swift
//  Roommate App
//
//  Created by Nick Buckenham on 2/22/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class HouseProfileController: UIViewController {
    
    var currentHouseName : String?
    var database: DatabaseAccess = DatabaseAccess.getInstance()

    // outlet that displays house name / ID
    @IBOutlet weak var GetHouseNameLabel: UILabel!
    
    // outlet for text input field
    @IBOutlet weak var changeHouseNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // callback for getStringHouseName
        let getHouseNameClosure = { (returnedHouseName: String?) -> Void in self.currentHouseName = returnedHouseName
            self.GetHouseNameLabel.text = "Current House: \(self.currentHouseName ?? "Error: nil House")"
        }
        
        // calls getStringHouseName, handles errors
        let errorHouseName = self.database.getStringHouseName(house_id: currentHouseID!, callback: getHouseNameClosure)
        if errorHouseName.returned_error {
            errorHouseName.raiseErrorAlert(with_title: "error", view: self)
        }
        
    }
    
    @IBAction func changeHouseNameTextSubmitClicked(_ sender: UIButton) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
