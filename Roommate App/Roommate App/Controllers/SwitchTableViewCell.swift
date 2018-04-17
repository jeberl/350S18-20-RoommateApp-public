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
    
    // function is called when switch is changed
    @IBAction func switchClicked(_ sender: UISwitch) {
        if sender.isOn {
            // If in da haus is turned on, get device's latitude and longitude
            let deviceLatitude = locManager.location?.coordinate.latitude
            let deviceLongitude = locManager.location?.coordinate.longitude
            print("Devices lat = \(deviceLatitude!) and lon = \(deviceLongitude!)")
            let houseAddressClosure = { (address: String?) -> Void in
                // Get string street address from database call
                let streetAddress = address ?? ""
                let geocoder = CLGeocoder()
                // Call built in function to get latitude and longitude from string address
                geocoder.geocodeAddressString(streetAddress, completionHandler: {(placemarks, error) -> Void in
                    if ((error) != nil){
                        // If we get an error, print it
                        print("Error", error ?? "")
                    }
                    if let placemark = placemarks?.first {
                        let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                        // Get latitude and longitude of house
                        let lat = coordinates.latitude
                        let lon = coordinates.longitude
                        print("House latitude = \(lat)")
                        print("House longitude = \(lon)")
                        // Calculate distance between house and device
                        let latDif = abs(lat - deviceLatitude!)
                        let lonDif = abs(lon - deviceLongitude!)
                        print("latitude difference = \(latDif)")
                        print("longitude difference = \(lonDif)")
                        // If device is within 0.0001 km (about 36 feet), allow user to indicate that they are home
                        if latDif < 0.0001 && lonDif < 0.0001 {
                            print("You are in da haus!  Switching on!")
                            self.database.userInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
                        } else {
                            print("You are too far away from home!  Switching back off!")
                            sender.isOn = false
                            // Send alert to user
                            /*let alert = UIAlertController(title: "You are to far away from home!",
                                                          message: "Switching back off to out of da haus",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true,
                                                                                        completion: nil)*/
                        }
                    }
                })
            }
            self.database.getHouseAddress(houseID: currentHouseID!, callback: houseAddressClosure)
        } else {
            print("In da haus switched off!")
            database.userNotInHouse(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Default switch to being what the user's in_da_haus status is in the database
        let inDaHausClosure = { (isHome : Bool) -> Void in
            if isHome {
                self.inDaHausSwitch.isOn = true
            } else {
                self.inDaHausSwitch.isOn = false
            }
        }
        self.database.isUserHome(uid: (Auth.auth().currentUser?.uid)!, houseID: currentHouseID!,
                                 callback: inDaHausClosure)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
