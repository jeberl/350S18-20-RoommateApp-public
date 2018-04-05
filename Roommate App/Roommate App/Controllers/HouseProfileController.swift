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
    
    // outlet for new housemate input field
    @IBOutlet weak var newHousemateTextField: UITextField!
    @IBOutlet weak var addHousemateButton: UIButton!
    let layer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        // callback for getStringHouseName
        let getHouseNameClosure = { (returnedHouseName: String?) -> Void in self.currentHouseName = returnedHouseName
            self.GetHouseNameLabel.text = "Current House: \(self.currentHouseName ?? "Error: nil House")"
        }
        
        // calls getStringHouseName, handles errors
        let errorHouseName = self.database.getStringHouseName(houseId: currentHouseID!, callback: getHouseNameClosure)
        if errorHouseName.returned_error {
            errorHouseName.raiseErrorAlert(with_title: "error", view: self)
        }
        
    }
    
    @IBAction func changeHouseNameTextSubmitClicked(_ sender: UIButton) {
        database.changeHouseName(currHouseID: currentHouseID!, newName: changeHouseNameText.text!)
    }
    
    // rotates gradient background when phone is put in landscape
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.frame = self.view.bounds
        CATransaction.commit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addHousemateButtonPressed(_ sender: UIButton){
        var alert = UIAlertController(title: "Empty Name Field",
                                      message: "Try again",
                                      preferredStyle: .alert)
        if let homie = newHousemateTextField!.text {
            if homie == "" {
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            else {
                let errorAddUserToHouse = self.database.addNewUserToHouse(withEmail: homie, to_house: currentHouseID!)
                if errorAddUserToHouse.returned_error {
                    // do we want to do anything if the email is not associated with an account?
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    present(alert, animated: true, completion: nil)
                } else {
                    newHousemateTextField.text = ""
                    alert = UIAlertController(title: "Homie Added",
                                              message: "Homie Added!" ,
                                              preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    

}
