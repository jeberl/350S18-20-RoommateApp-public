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
    let formatted_email : String
    let nickname: String
    let houses: [String]
    let phoneNumber: String?
    
    init(uid: String, email: String, formattedEmail: String, nickname: String, houses:[String], phoneNumber: String) {
        self.uid = uid
        self.email = email
        self.formatted_email = formattedEmail
        self.nickname = nickname
        self.houses = houses
        self.phoneNumber = phoneNumber
    }
    
    init(dict: NSDictionary) {
        self.uid = dict["uid"] as! String
        self.email = dict["email"] as! String
        self.formatted_email = dict["formatted_email"] as! String
        self.nickname = (dict["nickname"] as? String) ?? ""
        
        if let houses = dict["houses"] as? NSDictionary {
            self.houses = houses.allKeys as? [String] ?? []
        } else {
            self.houses = []
        }
        
        self.phoneNumber = dict["phone_number"] as! String?
    }
}
