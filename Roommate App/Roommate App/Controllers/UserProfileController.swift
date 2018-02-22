//
//  UserProfileController.swift
//  Roommate App
//
//  Created by Nick Buckenham on 2/22/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class UserProfileController: UIViewController {

    @IBOutlet weak var userProfileFor: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileForText: String = "User Profile For \(currentUser?.nickname ?? "Error: No Current User")"
        userProfileFor.text = profileForText

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
