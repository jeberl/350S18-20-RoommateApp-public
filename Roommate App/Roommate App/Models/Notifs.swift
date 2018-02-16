//
//  Notifs.swift
//  
//
//  Created by Elena Iaconis on 2/16/18.
//

import Foundation

struct Notifs {
    
    let uid: String // think this is just a Firebase specific thing, not sure
    let house_name: String
    let users_involved: [String]
    let contents: String

    init(uid: String, house_name: String, users_involved:[String], contents: String) {
        self.uid = uid
        self.house_name = house_name
        self.users_involved = users_involved
        self.contents = contents
    }
}
