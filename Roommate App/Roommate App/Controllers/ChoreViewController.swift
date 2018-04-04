//
//  ChoreViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class ChoreViewController: UIViewController {

    @IBOutlet weak var choreTitleLabel: UILabel!
    @IBOutlet weak var choreImageView: UIImageView!
    @IBOutlet weak var choreDescriptionLabel: UILabel!
    @IBOutlet weak var choreAssignorImageView: UIImageView!
    @IBOutlet weak var choreAssignorUsername: UILabel!
    @IBOutlet weak var choreAssigneeImageView: UIImageView!
    @IBOutlet weak var choreAssigneeUsernameLabel: UILabel!
    @IBOutlet weak var nudgeButton: UIButton!
    
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    var currentChoreTitle : String?
    var currentChoreDescription: String?
    var currentChoreAssignor: String?
    var currentChoreAssignee: String?
    var timesNudged : Int?
    var lastTimeNudged: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        // callback for getStringChoreTitle
        let getChoreTitleClosure = { (returnedChoreTitle: String?) -> Void in self.currentChoreTitle = returnedChoreTitle
            self.choreTitleLabel.text = "\(self.currentChoreTitle ?? "Error: nil House")"
        }
        
        // calls getStringChoreTitle, handles errors
        let errorChoreTitle = self.database.getStringChoreTitle(choreID: currentChoreID!, callback: getChoreTitleClosure)
        if errorChoreTitle.returned_error {
            errorChoreTitle.raiseErrorAlert(with_title: "error", view: self)
        }
        
        // callback for getStringChoreDescription
        let getChoreDescriptionClosure = { (returnedChoreDescription: String?) -> Void in self.currentChoreDescription = returnedChoreDescription
            self.choreDescriptionLabel.text = "\(self.currentChoreDescription ?? "Error: nil House")"
        }
        
        // calls getStringChoreDescription, handles errors
        let errorChoreDescription = self.database.getStringChoreDescription(choreID: currentChoreID!, callback: getChoreDescriptionClosure)
        if errorChoreDescription.returned_error {
            errorChoreDescription.raiseErrorAlert(with_title: "error", view: self)
        }
        
        // callback for getStringChoreAssignor
        let getChoreAssignorClosure = { (returnedChoreAssignor: String?) -> Void in self.currentChoreAssignor = returnedChoreAssignor
            self.choreAssignorUsername.text = "\(self.currentChoreAssignor ?? "Error: nil House")"
        }
        
        // calls getStringChoreAssignor, handles errors
        let errorChoreAssignor = self.database.getStringChoreAssignor(choreID: currentChoreID!, callback: getChoreAssignorClosure)
        if errorChoreAssignor.returned_error {
            errorChoreAssignor.raiseErrorAlert(with_title: "error", view: self)
        }
        
        // callback for getStringChoreAssignee
        let getChoreAssigneeClosure = { (returnedChoreAssignee: String?) -> Void in self.currentChoreAssignee = returnedChoreAssignee
            self.choreAssigneeUsernameLabel.text = "\(self.currentChoreAssignee ?? "Error: nil House")"
        }
        
        // calls getStringChoreAssignee, handles errors
        let errorChoreAssignee = self.database.getStringChoreAssignee(choreID: currentChoreID!, callback: getChoreAssigneeClosure)
        if errorChoreAssignee.returned_error {
            errorChoreAssignee.raiseErrorAlert(with_title: "error", view: self)
        }
        
        //callback for getLastTimeNudged
        let getLastTimeNudgedClosure = { (returnedLastTimeNudged: String?) -> Void in
            self.lastTimeNudged = returnedLastTimeNudged
        }
        
        //calls getLastTimeNudged, handles errors
        let errorLastTimeNudged = self.database.getLastTimeNudged(choreID: currentChoreID!, callback: getLastTimeNudgedClosure)
        if errorLastTimeNudged.returned_error {
            errorLastTimeNudged.raiseErrorAlert(with_title: "error", view: self)
        }
        
        //callback for getTimesNudged
        let getTimesNudgedClosure = { (returnedTimesNudged: Int?) -> Void in
            self.timesNudged = returnedTimesNudged
        }
        //calls getTimesNudged, handles errors
        let errorTimesNudged = self.database.getTimesNudged(choreID: currentChoreID!, callback: getTimesNudgedClosure)
        if errorTimesNudged.returned_error {
            errorTimesNudged.raiseErrorAlert(with_title: "error", view: self)
        }
        
        self.database.getStringChoreAssignor(choreID: currentChoreID!, callback: { (assignor_email) in
            DatabaseAccess.getInstance().getUserProfPicFromEmail(email: assignor_email ?? "") { (prof_pic) in
                self.choreAssignorImageView.image = prof_pic!
            }
        
        })
        
        self.database.getStringChoreAssignee(choreID: currentChoreID!, callback: { (assignor_email) in
            DatabaseAccess.getInstance().getUserProfPicFromEmail(email: assignor_email ?? "") { (prof_pic) in
                self.choreAssigneeImageView.image = prof_pic!
            }
            
        })
        
        ImageStorage.getInstance().getChoreImageOnce(choreID: currentChoreID!) { (chore_pic) in
            self.choreImageView.image = chore_pic
        }
        
        
        let currentTime = self.database.getTimestampAsString()
        
        
        
        
//        DatabaseAccess.getInstance().getUserProfPicFromEmail(email: self.currentChoreAssignor ?? "") { (prof_pic) in
//            print("assigning prof pic: \(prof_pic)")
//            self.choreAssignorImageView.image = prof_pic!
//        }
//        
//        DatabaseAccess.getInstance().getUserProfPicFromEmail(email: self.currentChoreAssignee ?? "") { (prof_pic) in
//            print("assigning prof pic 2")
//            self.choreAssigneeImageView.image = prof_pic
//        }
//
//        ImageStorage.getInstance().getChoreImageOnce(choreID: currentChoreID ?? "", view: self) { (chore_pic) in
//            self.choreImageView.image = chore_pic
//        }
//
//
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeChoreButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CompleteChore", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "CompleteChoreController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func nudgeButtonPressed(_ sender: Any) {
        
        let currentTime = self.database.getTimestampAsString()
        
        //converts currentTime and lastTimeNudged to Date(s)
        let currentDate = self.database.getTimestampAsDate(timestamp: currentTime)
        if self.timesNudged == 0 {
            //updates last time nudged
            self.database.setLastTimeNudged(choreID: currentChoreID!, newTime: currentTime, view: self)
            
            //updates amount of time nudged
            let newAmount = self.timesNudged! + 1
            self.database.setTimesNudged(choreID: currentChoreID!, newAmount: newAmount, view: self)
            
            // Notification for chore
            
            let newNotif = Notification(houseID: currentHouseID!, usersInvolved: [choreAssigneeUsernameLabel.text!], type: "Nudge", description: "\(choreAssignorUsername.text ?? "Error: nil Assignor") nudged you to complete your chore, \(choreTitleLabel.text)!")
            self.database.getUserUidFromEmail(email: choreAssigneeUsernameLabel.text!, callback: {(uid) -> Void in
                print("the uid is:\(uid ?? "Error: nil UID")")
                if let uid = uid {
                    self.database.addNotification(notification: newNotif, usersInvolved: [uid])
                } else {
                    
                }
            })
        } else {
            let dateLastNudged = self.database.getTimestampAsDate(timestamp: self.lastTimeNudged!)
            
            var dateComponents = DateComponents()
            let minutesToAdd = 5
            //let daysToAdd = 1
            dateComponents.minute = minutesToAdd
            //dateComponents.day = daysToAdd
            let dateAllowNewNudge = Calendar.current.date(byAdding: dateComponents, to: dateLastNudged)
            
            if currentDate.compare(dateAllowNewNudge!) == .orderedAscending {
                let lastTime = self.database.formatStringTimestamp(timestamp: self.lastTimeNudged!)
                let alert = UIAlertController(title: "Already Been Nudged!",
                                              message: "It's too early to nudge \(self.currentChoreAssignee!). Must wait 5 minutes after \(lastTime)" ,
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                //updates last time nudged
                self.database.setLastTimeNudged(choreID: currentChoreID!, newTime: currentTime, view: self)
                
                //updates amount of time nudged
                let newAmount = self.timesNudged! + 1
                self.database.setTimesNudged(choreID: currentChoreID!, newAmount: newAmount, view: self)
                
                // Notification for chore
                
                let newNotif = Notification(houseID: currentHouseID!, usersInvolved: [choreAssigneeUsernameLabel.text!], type: "Nudge", description: "\(choreAssignorUsername.text ?? "Error: nil Assignor") nudged you to complete your chore, \(choreTitleLabel.text)!")
                self.database.getUserUidFromEmail(email: choreAssigneeUsernameLabel.text!, callback: {(uid) -> Void in
                    print("the uid is:\(uid ?? "Error: nil UID")")
                    if let uid = uid {
                        self.database.addNotification(notification: newNotif, usersInvolved: [uid])
                    } else {
                        
                    }
                })
                
                //add charge if nudged 3 times
                if newAmount == 3 {
                    
                }
            }
        }
        //let timeDifference = self.database.getTimeDifferenceAsString(startDate: currentDate, endDate: dateLastNudged)
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
