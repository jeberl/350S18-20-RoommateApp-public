//
//  SwitchTableViewCell.swift
//  Roommate App
//
//  Created by user136152 on 4/9/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import CoreLocation
import UIKit
import FirebaseAuth

class SwitchTableViewCell: UITableViewCell, CLLocationManagerDelegate {

    @IBOutlet weak var inDaHausSwitch: UISwitch!
    let database : DatabaseAccess = DatabaseAccess.getInstance()
    let locManager = CLLocationManager()
    
    @IBAction func switchClicked(_ sender: UISwitch) {
        print("I CHANGED")
        if sender.isOn {
            print("In da haus switched on!")
            database.userInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
        } else {
            print("In da haus switched off!")
            database.userNotInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
        }
    }
    /*@IBAction func hausSwitch(_ sender: UISwitch) {
        if sender.isOn {
            let deviceLatitude = locManager.location?.coordinate.latitude
            let deviceLongitude = locManager.location?.coordinate.longitude
            let houseAddressClosure = { (address: String?) -> Void in
                let streetAddress = address ?? ""
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(streetAddress, completionHandler: {(placemarks, error) -> Void in
                    if ((error) != nil){
                        print("Error", error ?? "")
                    }
                    if let placemark = placemarks?.first {
                        let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                        let lat = coordinates.latitude
                        let lon = coordinates.longitude
                        
                    }
                })
            }
            print("In da haus switched on!")
            database.userInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
        } else {
            print("In da haus switched off!")
            database.userNotInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
        }
    }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Default switch to being what the user's in_da_haus status is in the database
        let inDaHausClosure = { (isHome : Bool) -> Void in
            if isHome {
                print("In nib... isHome is true")
                self.inDaHausSwitch.isOn = true
            } else {
                self.inDaHausSwitch.isOn = false
                print("In nib... isHome is false")
            }
        }
        print("IN NIB")
        self.database.isUserHome(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!,
                                 callback: inDaHausClosure)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
