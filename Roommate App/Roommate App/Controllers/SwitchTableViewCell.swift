//
//  SwitchTableViewCell.swift
//  Roommate App
//
//  Created by user136152 on 4/9/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class SwitchTableViewCell: UITableViewCell {

    let database : DatabaseAccess = DatabaseAccess.getInstance()
    
    @IBAction func hausSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            database.userInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
        } else {
            database.userNotInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
