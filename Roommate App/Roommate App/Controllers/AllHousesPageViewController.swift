//
//  AllHousesPageViewController.swift
//  Roommate App
//
//  Created by user136152 on 2/19/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class AllHousesPageViewController: UIViewController {
    
    var buttonToGetHere = ""
    var currentUser : UserAccount?
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = buttonToGetHere

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
