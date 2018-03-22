//
//  CreateChoreViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateChoreViewController: UIViewController {
    
    @IBOutlet weak var choreTitleTextField: UITextField!
    @IBOutlet weak var choreDescriptionTextField: UITextField!
    @IBOutlet weak var userResponsibleTextField: UITextField!
    @IBOutlet weak var createChoreButton: UIButton!
    let database : DatabaseAccess = DatabaseAccess.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createChoreButtonPressed(_ sender: Any) {
        print("Create chore button pressed")
        let choreTitle = choreTitleTextField!.text
        let choreDescription = choreDescriptionTextField!.text
        let userResponsible = userResponsibleTextField!.text
        let date = self.database.getTimestampAsString()
        
       
        // Create new house object to add to database
        let newChore = ChoreAJ(chore_title: choreTitle!, assignor: (Auth.auth().currentUser?.email!)!, assignee: userResponsible!, time_assigned: date, houseID: currentHouseID!, description: choreDescription!)
        self.database.createChore(chore: newChore)
        let assignor = Auth.auth().currentUser?.email!
        
        // Notification for chore
        
        let newNotif = Notification(houseID: currentHouseID!, usersInvolved: [userResponsible!], timestamp: date, type: "Chore", description: "\(assignor ?? "Error: nil Assignor") assigned \(newChore.title) to you!") 
        var userUid: String? = nil;
        self.database.getUserUidFromEmail(email: userResponsible!, callback: {(uid) -> Void in
            print("the uid is:\(uid ?? "Error: nil UID")")
                userUid = uid!
                self.database.addNotification(notification: newNotif, usersInvolved: [userUid!])
        })
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
