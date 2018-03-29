//
//  CreateChargeController.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/29/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class CreateChargeController : UIViewController {

    var cents : Int = 0
    
    @IBOutlet weak var amountTextFeild: UITextField!
    @IBOutlet weak var chargePaySwitch: UISegmentedControl!
    @IBOutlet weak var houseMemberPicker: UIPickerView!
    @IBOutlet weak var transactionDescriptionTextFeild: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextFeild.keyboardType = UIKeyboardType.numberPad
        houseMemberPicker.reloadAllComponents()
    }
    
    private func getCentsFromText(text: String) -> Int {

    }
    
    private func getTextFromCents(cents: Int) -> String {
       return "$ \(cents / 100).\(cents % 100)"
    }
    
    @IBAction func DisplayText(_ sender: UITextField) {
        let newCents = getCentsFromText(amountTextFeild.text)
        
    }
}
