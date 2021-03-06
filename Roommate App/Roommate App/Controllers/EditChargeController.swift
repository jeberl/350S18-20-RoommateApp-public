//
//  EditChargeController.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/29/18.
//  Copyright © 2018 Team 20. All rights reserved.
//
// Controls create charge page by taking in user input about the charge and creating it in the database
//

import UIKit
import FirebaseAuth

class EditChargeController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewImageTextPickerDestination {
    static let testParesedReciept : [RecieptItem] = [RecieptItem(description: "Tacos con carne",
                                                          totalCost: 14.15,
                                                          makePaymentToUIDs: ["HgQzv8QOVLMoyS4kkDB8mqeR1xy1"]),
                                              RecieptItem(description: "Nachos no meat",
                                                          totalCost: 12.00,
                                                          makePaymentToUIDs: ["HgQzv8QOVLMoyS4kkDB8mqeR1xy1"]),
                                              RecieptItem(description: "Churos",
                                                          totalCost: 7.50,
                                                          makePaymentToUIDs: ["HgQzv8QOVLMoyS4kkDB8mqeR1xy1"]),
                                              RecieptItem(description: "Burrito Grande",
                                                          totalCost: 12.50,
                                                          makePaymentToUIDs: ["HgQzv8QOVLMoyS4kkDB8mqeR1xy1"])]
    
   
    
    func getSelectedImageOrText(wasSuccessful: Bool, imageURL: String?, text: String?) {
        recieptItemsToEdit = EditChargeController.testParesedReciept
//        ImageStorage.getInstance().getImage(url: imageURL!, callback : { (image) in
//            let uid = Auth.auth().currentUser?.uid
//            ReceiptParser.getInstance().parseReceipt(image, paidByUIDs: <#T##[String]#>, { (parsedItems) in
//                recieptItemsToEdit = parsedItems
//            })
//        })
    }
    
    var selectedMembersUIDs : Set<String> = Set()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountTextFeild: UITextField!
    @IBOutlet weak var transactionDescriptionTextFeild: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextChargeButton: UIButton!
    @IBOutlet weak var submitChargeButton: UIButton!
    @IBOutlet weak var prevChargeButton: UIButton!
    
    var recieptItemsToEdit : [RecieptItem] = testParesedReciept
    var currentRecieptItemIndex : Int = 0
    var currentRecieptItem : RecieptItem {
        get {
            return recieptItemsToEdit[currentRecieptItemIndex]
        }
        set (item) {
            recieptItemsToEdit[currentRecieptItemIndex] = item
        }
    }
    var totalNumRecieptItems : Int {
        get {
            return recieptItemsToEdit.count
        }
    }
    var hasSeenAllRecieptItems : Bool = false
    
    var backgroundColors : [String: UIColor] = [ "Unavailible" : UIColor.lightGray,
                                                 "Submit" : UIColor.green,
                                                 "PrevNext" : UIColor.blue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Loading edit charges view controller")
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        amountTextFeild.keyboardType = UIKeyboardType.numberPad
        amountTextFeild.textAlignment = NSTextAlignment.right
        
        loadCurrentRecieptItem()
        
    }
    
    @IBAction func inputAmountTextEdit(_ sender: UITextField) {
        let newCents = getCentsFromTextField()
        amountTextFeild.text = getTextFromCents(cents: newCents);
    }
    
    private func loadCurrentRecieptItem() {
        if totalNumRecieptItems == 0 {
            returnPopup(title : "No Reciept Items Found", message: "Returning to balances page")
            return
        }
        titleLabel.text = "Edit Charge \(currentRecieptItemIndex + 1)/\(totalNumRecieptItems)"
        amountTextFeild.text = getTextFromCents(cents: Int(currentRecieptItem.cost * 100.0))
        transactionDescriptionTextFeild.text = currentRecieptItem.description
        selectedMembersUIDs.removeAll()
        selectedMembersUIDs = selectedMembersUIDs.union(currentRecieptItem.toChargeUIDs ?? [])
        if currentRecieptItemIndex + 1 == totalNumRecieptItems {
            hasSeenAllRecieptItems = true
        }

        updateButtonColors()
        tableView.reloadData()

        print("title: \(titleLabel.text), description: \(transactionDescriptionTextFeild.text), amount: \(amountTextFeild.text), selected uids: \(selectedMembersUIDs)")
        
    }
    
    private func canSendCharges() -> Bool {
        return hasSeenAllRecieptItems && !recieptItemsToEdit.contains(where: { (item) -> Bool in return !item.canSendCharges()})
    }
    
    private func updateButtonColors() {
        if canSendCharges() {
            submitChargeButton.backgroundColor = backgroundColors["Submit"]
            submitChargeButton.isUserInteractionEnabled = true
        } else {
            submitChargeButton.backgroundColor = backgroundColors["Unavailible"]
            submitChargeButton.isUserInteractionEnabled = false
        }
        if currentRecieptItemIndex < totalNumRecieptItems - 1 {
            nextChargeButton.backgroundColor = backgroundColors["PrevNext"]
            submitChargeButton.isUserInteractionEnabled = true
        } else {
            nextChargeButton.backgroundColor = backgroundColors["Unavailible"]
            submitChargeButton.isUserInteractionEnabled = false
        }
        if currentRecieptItemIndex > 0 {
            prevChargeButton.backgroundColor = backgroundColors["PrevNext"]
            submitChargeButton.isUserInteractionEnabled = true
        } else {
            prevChargeButton.backgroundColor = backgroundColors["Unavailible"]
            submitChargeButton.isUserInteractionEnabled = false
        }
    }
    
    private func getCentsFromTextField() -> Int {
        let text = amountTextFeild.text
        let numbers = text!.filter({ (char) -> Bool in
            return "0123456789".contains(char)
        })
        return Int(numbers)!
    }
    
    private func getTextFromCents(cents: Int) -> String {
        var decimal = String(cents % 100)
        if cents % 100 < 10 {
            decimal = "0\(decimal)"
        }
        return "$ \(cents / 100).\(decimal)"
    }
    
    @IBAction func submitAllChargesPressed() {
        if canSendCharges() {
            saveCurrentItem()
            let sendChargesPopup : (UIAlertAction) -> Void = { (_) in
                for item in self.recieptItemsToEdit {
                    let result = item.sendCharges()
                    if result.returned_error {
                        self.raiseError(title: "Error sending charge", message : result.error_message)
                    } else {
                        self.performSegue(withIdentifier: "unwindToHouseBalance", sender: self)
                    }
                }
            }
            let alert = UIAlertController(title: "Are you sure you want to submit these charges?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Not Yet", style: UIAlertActionStyle.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler : sendChargesPopup))
            present(alert, animated: true, completion: nil)
            
        } else {
            if !hasSeenAllRecieptItems {
                raiseError(title: "Cannot send charges", message : "You must view every charge before sending the charges")
            } else {
                raiseError(title: "Cannot send charges", message : "You must select someone to charge for every charge")
            }
        }
    }

    @IBAction func prevChargePressed(_ sender: UIButton) {
        saveCurrentItem()
        if currentRecieptItemIndex > 0 {
            currentRecieptItemIndex = currentRecieptItemIndex - 1
            loadCurrentRecieptItem()
            
        }
    }
    
    @IBAction func nextChargePressed(_ sender: UIButton) {
        saveCurrentItem()
        if currentRecieptItemIndex < totalNumRecieptItems - 1 {
            currentRecieptItemIndex = currentRecieptItemIndex + 1
            loadCurrentRecieptItem()
        }
    }
    
    @IBAction func deleteChargePressed(_ sender: UIButton) {
        recieptItemsToEdit.remove(at: currentRecieptItemIndex)
        currentRecieptItemIndex = min(currentRecieptItemIndex, totalNumRecieptItems - 1)
        loadCurrentRecieptItem()
    }
    
    func saveCurrentItem() {
        currentRecieptItem.description = transactionDescriptionTextFeild.text ?? ""
        currentRecieptItem.cost = Double(getCentsFromTextField()) / 100
        currentRecieptItem.toChargeUIDs = [String](selectedMembersUIDs)
    }
    
    
    
    func returnPopup(title : String, message : String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_) in
            self.performSegue(withIdentifier: "unwindToHouseBalance", sender: self)
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    func chargeNeedsMessageError() {
        raiseError(title : "Please enter a messgae for the charge")
    }
    
    func zeroAmoutError() {
        raiseError(title : "Amount must be greater than 0")
    }
    
    func chargeSelfError() {
        raiseError(title : "You cannot charge/Settle up with yourself")
    }
    
    func raiseError(title : String, message : String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func DisplayText(_ sender: UITextField) {
        let newCents = getCentsFromTextField()
        amountTextFeild.text = getTextFromCents(cents: newCents);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentHouseUIDtoNickname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseMemberCellEdit", for: indexPath)
        cell.textLabel?.text = currentHouseUIDtoNickname[currentHouseOrderedUIDs[indexPath.row]]
        if selectedMembersUIDs.contains(currentHouseOrderedUIDs[indexPath.row]) {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedMembersUIDs.contains(currentHouseOrderedUIDs[indexPath.row]) {
            selectedMembersUIDs.remove(currentHouseOrderedUIDs[indexPath.row])
        } else {
            selectedMembersUIDs.insert(currentHouseOrderedUIDs[indexPath.row])
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        updateButtonColors()
        print("selectedMembersUIDs = \(selectedMembersUIDs)")
    }
    
}
