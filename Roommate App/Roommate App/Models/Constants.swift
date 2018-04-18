//
//  Constants.swift
//  Roommate App
//
//  Created by Elena Iaconis on 4/17/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
