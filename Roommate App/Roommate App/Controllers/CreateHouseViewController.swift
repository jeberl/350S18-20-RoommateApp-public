//
//  CreateHouseViewController.swift
//  Roommate App
//
//  Created by Ajani Motta on 2/22/18.
//  Copyright © 2018 Team 20. All rights reserved.
//
// Controller for creating house page.  Takes in user input for house information and creates
// a house in the database
//

import UIKit
import FirebaseAuth

class CreateHouseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var houseNameTextField: UITextField!
    @IBOutlet weak var houseStreetAddressTextField: UITextField!
    @IBOutlet weak var homieUsernameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var statePickerView: UIPickerView!
    
    var currentUser : UserAccount?
    var homies: [String] = []
    var database: DatabaseAccess = DatabaseAccess.getInstance()
    var newHome : House!
    var selectedStateAbbrev : String = ""
    var stateAbbreviations: [String] = []
    let stateDictionary: [String : String] = [
        "AK" : "Alaska",
        "AL" : "Alabama",
        "AR" : "Arkansas",
        "AS" : "American Samoa",
        "AZ" : "Arizona",
        "CA" : "California",
        "CO" : "Colorado",
        "CT" : "Connecticut",
        "DC" : "District of Columbia",
        "DE" : "Delaware",
        "FL" : "Florida",
        "GA" : "Georgia",
        "GU" : "Guam",
        "HI" : "Hawaii",
        "IA" : "Iowa",
        "ID" : "Idaho",
        "IL" : "Illinois",
        "IN" : "Indiana",
        "KS" : "Kansas",
        "KY" : "Kentucky",
        "LA" : "Louisiana",
        "MA" : "Massachusetts",
        "MD" : "Maryland",
        "ME" : "Maine",
        "MI" : "Michigan",
        "MN" : "Minnesota",
        "MO" : "Missouri",
        "MS" : "Mississippi",
        "MT" : "Montana",
        "NC" : "North Carolina",
        "ND" : " North Dakota",
        "NE" : "Nebraska",
        "NH" : "New Hampshire",
        "NJ" : "New Jersey",
        "NM" : "New Mexico",
        "NV" : "Nevada",
        "NY" : "New York",
        "OH" : "Ohio",
        "OK" : "Oklahoma",
        "OR" : "Oregon",
        "PA" : "Pennsylvania",
        "PR" : "Puerto Rico",
        "RI" : "Rhode Island",
        "SC" : "South Carolina",
        "SD" : "South Dakota",
        "TN" : "Tennessee",
        "TX" : "Texas",
        "UT" : "Utah",
        "VA" : "Virginia",
        "VI" : "Virgin Islands",
        "VT" : "Vermont",
        "WA" : "Washington",
        "WI" : "Wisconsin",
        "WV" : "West Virginia",
        "WY" : "Wyoming"]
    
    let layer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        database = DatabaseAccess.getInstance()
        zipCodeTextField.keyboardType = UIKeyboardType.numberPad
        
        // set up picker view to grab state abbreviations
        statePickerView.isHidden = false
        statePickerView.delegate = self
        statePickerView.dataSource = self
        
        
        for (abbreviation, name) in stateDictionary {
            self.stateAbbreviations.append(abbreviation)
        }
        
       self.stateAbbreviations.sort(){ $0 < $1 }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var alert = UIAlertController(title: "No name entered.",
                                      message: "Please try again",
                                      preferredStyle: .alert)
        if homieUsernameTextField!.text == "" {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        if let homie = homieUsernameTextField!.text {
            self.homies.append(homie)
            homieUsernameTextField.text = ""
            alert = UIAlertController(title: "Homie Added",
                                          message: "Homie Added!" ,
                                          preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // rotates gradient background when phone is put in landscape
    override func viewDidLayoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        layer.frame = self.view.bounds
        CATransaction.commit()
    }
    
    @IBAction func buildHomeButtonPressed(_ sender: Any) {
        //handle invalid characters inputted for house name
        let houseName = houseNameTextField!.text
        if ((houseName?.contains("."))! || (houseName?.contains("$"))! ||
        (houseName?.contains("["))! || (houseName?.contains("]"))! ||
            (houseName?.contains("#"))!){
            let alert = UIAlertController(title: "Invalid characters included in house name",
                                          message: "Invalid house name. Please do not include '.', '$', '#', '[', or  ']' in the house name." ,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            houseNameTextField!.text = ""
            return
        }
        //handle empty input for street address
        var address = houseStreetAddressTextField!.text
        if houseStreetAddressTextField!.text == "" {
            let alert = UIAlertController(title: "No address entered.",
                                          message: "Please try again",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        //handle empty input for city
        let city = cityTextField!.text
        if cityTextField!.text == "" {
            let alert = UIAlertController(title: "No city entered.",
                                          message: "Please try again",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        //handle empty input for zip code
        let zipCode = zipCodeTextField!.text
        if zipCodeTextField!.text == "" {
            let alert = UIAlertController(title: "No zip code entered.",
                                          message: "Please try again",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        address = "\(address!), \(city!), \(self.selectedStateAbbrev) \(zipCode!)"
        print("ADDRESS = \(address)")
        
        // Create new house object to add to database
        var newHome = House(houseName: houseName!, address : address!, houseUsers: homies, owner: Auth.auth().currentUser!.email!, incompleteChores: [], completeChores: [], recentCharges: [], recentInteractions: [])
        self.newHome = self.database.createHouse(house: newHome)
    }
    
    // Only need one section in table because only displaying chores
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //set number of components in dropdown to choose state
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent section: Int) -> Int {
        return self.stateAbbreviations.count
    }
    
    //set title for each component in dropdown
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.stateAbbreviations[row]
    }
    
    // assign behavior for choice of state
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let stateAbbrev = self.stateAbbreviations[row] as String
        self.selectedStateAbbrev = stateAbbrev
        if let fullStateName = self.stateDictionary[self.stateAbbreviations[row]] {
            print("You chose \(fullStateName)")
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
