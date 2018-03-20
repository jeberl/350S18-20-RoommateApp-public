//
//  CreateChoreViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class CreateChoreViewController: UIViewController {
    
    @IBOutlet weak var choreTitleTextField: UITextField!
    @IBOutlet weak var choreDescriptionTextField: UITextField!
    @IBOutlet weak var userResponsibleTextField: UITextField!
    @IBOutlet weak var createChoreButton: UIButton!
    var currentUser : UserAccount?
    var currentHouse : House!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createChoreButtonPressed(_ sender: Any) {
        let choreTitle = choreTitleTextField!.text
        let choreDescription = choreDescriptionTextField!.text
        let userResponsible = userResponsibleTextField!.text
        let date = NSDate()
        
       
        // Create new house object to add to database
        var newChore = ChoreAJ(chore_title: choreTitle!, assignor: (currentUser?.nickname)! , assignee: userResponsible!, time_assigned: date, house: currentHouse.houseID!, description: choreDescription!)
        
        //self.newChore = self.database!.createChore(chore: newChore)
        
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
