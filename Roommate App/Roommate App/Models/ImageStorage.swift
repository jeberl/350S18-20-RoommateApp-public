//
//  ImageStorage.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/18/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation



import Firebase
import FirebaseDatabase
import FirebaseAuthUI

class ImageStorage  {

    static var instance : ImageStorage? = nil
    var storage : Storage!
    
    private init(){
        //Ensure app has been configured
        let _ = DatabaseAccess.getInstance()
        
        //Set Storage
        storage = Storage.storage()
    }
    
    public static func getInstance() -> ImageStorage {
        if instance == nil {
            instance = ImageStorage()
        }
        return instance!
    }
    
    func uploadChoreImage(image : UIImage) -> String? {
        return nil
    }
}
