//
//  ChoreViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 3/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//
// Populates and controls page that displays information about a chore when you
// click on the chore in the chore list page
//

import UIKit

class ChoreViewController: UIViewController, UIViewImageTextPickerDestination {

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
    var currentChoreAssigneeUID: String?
    var timesNudged : Int?
    var lastTimeNudged: String?
    
    var selfErrorViewController = self
    
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
        
        // callback for getStringChoreAssigneeUID
        let getChoreAssigneeUIDClosure = { (returnedChoreAssigneeUID: String?) -> Void in
            self.currentChoreAssigneeUID = returnedChoreAssigneeUID
        }
        
        // calls getStringChoreAssignee, handles errors
        let errorChoreAssigneeUID = self.database.getStringChoreAssigneeUID(choreID: currentChoreID!, callback: getChoreAssigneeUIDClosure)
        if errorChoreAssigneeUID.returned_error {
            errorChoreAssigneeUID.raiseErrorAlert(with_title: "error", view: self)
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
                self.choreAssigneeImageView.image = prof_pic ?? #imageLiteral(resourceName: "defaultChoreImage")
            }
            
        })
        
        ImageStorage.getInstance().getChoreImageOnce(choreID: currentChoreID!) { (chore_pic) in
            self.choreImageView.image = chore_pic
        }
        
        
        let currentTime = self.database.getTimestampAsString()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToChorePage(_ sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func completeChoreButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "getImageToCompeteChore", sender: self)
    }
    
    func raiseAlert(title : String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
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
            self.timesNudged = newAmount
            
            // Notification for chore
            
            let newNotif = Notification(houseID: currentHouseID!, UIDsInvolved: [self.currentChoreAssigneeUID!], type: "Nudge", description: "\(choreAssignorUsername.text ?? "Error: nil Assignor") nudged you to complete your chore, \(choreTitleLabel.text!)! (\(self.timesNudged!))")
            self.database.addNotification(notification: newNotif)
            /*self.database.getUserUidFromEmail(email: choreAssigneeUsernameLabel.text!, callback: {(uid) -> Void in
                print("the uid is:\(uid ?? "Error: nil UID")")
                if let uid = uid {
                    self.database.addNotification(notification: newNotif)
                } else {
                    
                }
            })*/
        } else {
            let dateLastNudged = self.database.getTimestampAsDate(timestamp: self.lastTimeNudged!)
            
            var dateComponents = DateComponents()
            let minutesToAdd = 1
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
                self.timesNudged = newAmount
                
                // Notification for chore
                
                let newNotif = Notification(houseID: currentHouseID!, UIDsInvolved:  [self.currentChoreAssigneeUID!], type: "Nudge", description: "\(choreAssignorUsername.text ?? "Error: nil Assignor") nudged you to complete your chore, \(choreTitleLabel.text!)! (\(self.timesNudged!))")
                self.database.addNotification(notification: newNotif)
                /*self.database.getUserUidFromEmail(email: choreAssigneeUsernameLabel.text!, callback: {(uid) -> Void in
                    print("the uid is:\(uid ?? "Error: nil UID")")
                    if let uid = uid {
                        self.database.addNotification(notification: newNotif)
                    } else {
                        
                    }
                })*/
                
                var result : ReturnValue<Bool> = ExpectedExecution<Bool>()
                
                //add charge if nudged 3 times
                if self.timesNudged == 3 {
                    
                    let charge = Charge(takeFromUID: "houseFund", giveToUID: self.currentChoreAssigneeUID!, houseID: currentHouseID!, amount: 5, message: "Charged $5 for being nudged 3 times for incomplete chore, \(choreTitleLabel.text!).")
                    result = database.createCharge(charge: charge)
                    if result.returned_error {
                        raiseAlert(title : "Couldn't complete charge with house fund")
                    }
                    if !result.returned_error {
                        raiseAlert(title : "\(self.choreAssigneeUsernameLabel.text!) charged for receiving 3 nudges for incomplete chore, \(choreTitleLabel.text!).")
                    }
                }
            
                    let notifFrom = Notification(houseID: currentHouseID!, UIDsInvolved: [self.currentChoreAssigneeUID!], type: "Charge", description: "You've been nudged 3 times for not completing chore, \(choreTitleLabel.text!)! You are now charged $5")
                    database.addNotification(notification: notifFrom)
                }
            
        }
        //let timeDifference = self.database.getTimeDifferenceAsString(startDate: currentDate, endDate: dateLastNudged)
    }
    
    func getSelectedImageOrText(wasSuccessful: Bool, imageURL: String?, text: String?) {
        print("getSelectedImageOrText called")
        if wasSuccessful {
            database.completeChore(choreID: currentChoreID!, completionDescription: text, downloadURL: imageURL)
            
        } else {
            print("error uploading image")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue identifier : \(segue.identifier)")
        if segue.identifier == "getImageToCompeteChore"{
            let destinationController = segue.destination as! ImagePickerOrTextController
            let imageSettings = imagePickerSettings(onCompleteSegueIdentifier: "unwind",
                                                    writeShouldGetTextFromDeafultStoryboard: true,
                                                    bucketStorageName: "chore_images")
            
            imageSettings.setDefualtWritePage(writeButtonLabelText: "Complete chore with description",
                                              writePageInputMessagePrompt: "Enter a descirption of the chore you completed")
            assert(imageSettings.areValid())
            destinationController.settings = imageSettings
        }
    }

}
