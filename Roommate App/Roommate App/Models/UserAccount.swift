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

    let uid: String // think this is just a Firebase specific thing, not sure
    let email: String
    let nickname: String
    let houses: [String]
    let phoneNumber: Int?
    
    init(uid: String, email: String, nickname: String, houses:[String], phoneNumber: Int) {
        self.uid = uid
        self.email = email
        self.nickname = nickname
        self.houses = houses
        self.phoneNumber = phoneNumber
    }
}
