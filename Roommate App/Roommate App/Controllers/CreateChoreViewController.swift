//
//  CreateChoreViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//
// Controller for creating chores page.  Takes in user input for chore information and creates
// a chore in the database
//

import UIKit
import FirebaseAuth

class CreateChoreViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var choreTitleTextField: UITextField!
    @IBOutlet weak var choreDescriptionTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let database : DatabaseAccess = DatabaseAccess.getInstance()
    var usernames : [String]! = [String]() // Users in the house
    var userIDs : [String]! = [String]() // userIDs of homies
    var assigneeNickname : String = ""
    var assigneeUID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.isHidden = false
        pickerView.delegate = self
        pickerView.dataSource = self

        let usernamesClosure = {(returnedUserIDs: [String]?) -> Void in
            self.userIDs = returnedUserIDs
            let usernameClosure = { (username : String?) -> Void in
                if username != nil {
                    self.usernames.append(username!)
                    self.pickerView.reloadAllComponents()
                }
            }
            self.userIDs = returnedUserIDs ?? []
            for userID in self.userIDs {
                self.database.getUserGlobalNickname(forUid: userID, callback: usernameClosure)
            }
        }
        let error1 = self.database.getListOfUIDSInHouse(houseID: currentHouseID!, callback: usernamesClosure)
        if error1.returned_error {
            error1.raiseErrorAlert(with_title: "Error:", view: self)
        }
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
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
        let date = self.database.getTimestampAsString()
        
        
       
        // Create new house object to add to database
        let newChore = ChoreAJ(choreTitle: choreTitle!, assignor: (Auth.auth().currentUser?.email!)!, assignee: self.assigneeNickname, assigneeUID: self.assigneeUID , houseID: currentHouseID!, description: choreDescription!)
        self.database.createChore(chore: newChore)
        let assignor = Auth.auth().currentUser?.email!
        
        // Notification for chore
        let newNotif = Notification(houseID: currentHouseID!, UIDsInvolved: [assigneeUID], type: "Chore", description: "\(assignor ?? "Error: nil Assignor") assigned \(newChore.title) to you!")
        self.database.addNotification(notification: newNotif)
    }

    
    // Only need one section in table because only displaying chores
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent section: Int) -> Int {
        return usernames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usernames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.assigneeNickname = self.usernames[row]
        self.assigneeUID = self.userIDs[row]
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
