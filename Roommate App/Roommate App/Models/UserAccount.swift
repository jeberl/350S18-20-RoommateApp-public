//
//  UserAccount.swift
//  Roommate App
//
//  Created by Elena Iaconis on 2/14/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct UserAccount {
    let uid: String // Stores the key for this user in firebase
    let email: String
    let nickname: String
    let houses: [String]
    let phoneNumber: String?
    
    init(uid: String, email: String, nickname: String, houses:[String], phoneNumber: String) {
        self.uid = uid
        self.email = email
        self.nickname = nickname
        self.houses = houses
        self.phoneNumber = phoneNumber
    }
    
    init(dict: NSDictionary) {
        self.uid = dict["uid"] as! String
        self.email = dict["email"] as! String
        self.nickname = (dict["nickname"] as? String) ?? ""
        
        if let houses = dict["houses"] as! [String]? {
            self.houses = houses
        } else {
            self.houses = []
        }
        
        self.phoneNumber = dict["phone_number"] as! String?
    }
}
