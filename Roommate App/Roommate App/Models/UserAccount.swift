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
    let formattedEmail : String
    let nickname: String
    let houses: [String]
    let incompleteChores: [String]
    let completeChores: [String]
    let phoneNumber: String?
    
    init(uid: String, email: String, formattedEmail: String, nickname: String, houses: [String], incompleteChores: [String], completeChores: [String], phoneNumber: String) {
        self.uid = uid
        self.email = email
        self.formattedEmail = formattedEmail
        self.nickname = nickname
        self.houses = houses
        self.incompleteChores = incompleteChores
        self.completeChores = completeChores
        self.phoneNumber = phoneNumber
    }
    
    init(dict: NSDictionary) {
        self.uid = dict["uid"] as! String
        self.email = dict["email"] as! String
        self.formattedEmail = dict["formatted_email"] as! String
        self.nickname = (dict["nickname"] as? String) ?? ""
        
        if let houses = dict["houses"] as? NSDictionary {
            self.houses = houses.allKeys as? [String] ?? []
        } else {
            self.houses = []
        }
        
        if let incompleteChores = dict["incompleteChores"] as? NSDictionary {
            self.incompleteChores = incompleteChores.allKeys as? [String] ?? []
        } else {
            self.incompleteChores = []
        }
        
        if let completeChores = dict["completeChores"] as? NSDictionary {
            self.completeChores = completeChores.allKeys as? [String] ?? []
        } else {
            self.completeChores = []
        }
        
        self.phoneNumber = dict["phone_number"] as! String?
    }
}
