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
    let database : DatabaseAccess = DatabaseAccess.getInstance()
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
        let date = getTimestampAsString()
        
       
        // Create new house object to add to database
        let newChore : ChoreAJ = ChoreAJ(chore_title: choreTitle!, assignor: (currentUser?.nickname)! , assignee: userResponsible!, time_assigned: date, houseID: currentHouse.houseID!, description: choreDescription!)
        print("title = \(newChore.title)")
        print("assignor = \(newChore.assigned_by)")
        print("assigned to = \(newChore.assigned_to)")
        print("time assigned = \(newChore.time_assigned)")
        print("house id = \(newChore.houseID)")
        print("description = \(newChore.description)")
        
        self.database.createChore(chore: newChore)
        
    }
    
    /*
     Gets the current time stamp and returns it as a string
     Input: N/A
     Output: String representation of timestamp
    */
    func getTimestampAsString() -> String {
        let formatter = DateFormatter()
        
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date())
        
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        
        // again convert your date to string
        let dateString = formatter.string(from: yourDate!)
        print(dateString)
        return dateString
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
