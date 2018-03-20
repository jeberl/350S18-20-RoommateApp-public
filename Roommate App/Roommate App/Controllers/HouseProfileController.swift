//
//  HouseProfileController.swift
//  Roommate App
//
//  Created by Nick Buckenham on 2/22/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class HouseProfileController: UIViewController {

    
    @IBOutlet weak var GetHouseNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentHouseName: String =  "\(currentHouseID ?? "Error: No Current House")"
        GetHouseNameLabel.text = currentHouseName
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
