//
//  InDaHausViewController.swift
//  Roommate App
//
//  Created by user136152 on 4/9/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class InDaHausViewController: UITabBarController {
    
    let database : DatabaseAccess = DatabaseAccess.getInstance()
    let layer = CAGradientLayer()

    @IBAction func hausSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            database.userInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
        } else {
            database.userNotInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)*/
        
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
