//
//  Error.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 2/16/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation
import UIKit

class ReturnValue<T> : Error {
    
    let returned_error : Bool
    let error_message : String?
    let error_number : Int
    let data : T?
    var localizedDescription: String? = nil
    
    
    
    
    init(error returned_error: Bool, data : T? = nil, error_message : String = "", error_number : Int? = nil) {
        self.returned_error = returned_error
        self.error_message = returned_error ? error_message : nil
        self.error_number = returned_error ? error_number! : 0
        self.data = returned_error ? nil : data
        self.localizedDescription = getErrorDescription()
    }
    
    func getErrorDescription() -> String {
        switch (self.error_number) {
            case 0: return "No Error"
            case 10: return "No Such User"
            case 11: return "User Must Be Owner of House"
            case 12: return "User Must Be Member of House"
            case 13: return "Email Address Already Associated With Another Account"
            case 14: return "Proboblem Initializing User Account"
            case 20: return "No Such House"
            case 30: return "No Such Charge"
            case 50: return "Firebase Error"
            case 100: return "Unimplemented Function"
        default: return "Unspecified Error: " + (self.error_message ?? "")
        }
        
    }
    
    func raiseErrorAlert(with_title title: String, view: UIViewController) {
        print("raising error alert: \(self.getErrorDescription)")
        let alert = UIAlertController(title: title,
                                      message: self.getErrorDescription() ,
                                      preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue",
                                           style: .default)
        alert.addAction(continueAction)
        view.present(alert, animated: true, completion: nil)
    }
}

class ExpectedExecution<T>: ReturnValue<T> {
    init() {
        super.init(error: false, error_number: 0)
    }
}

class NoSuchUserError<T>: ReturnValue<T>{
    init() {
        super.init(error: true, error_number: 10)
    }
}

class UserNotOwnerOfHouseError<T>: ReturnValue<T> {
    init() {
        super.init(error: true, error_number: 11)
    }
}

class UserNotMemberofHouseError<T>: ReturnValue<T> {
    init() {
        super.init(error: true, error_number: 12)
    }
}

class InternalUserInitError<T>: ReturnValue<T> {
    init() {
        super.init(error: true, error_number: 14)
    }
}

class NoSuchHouseError<T>: ReturnValue<T> {
    init() {
        super.init(error: true, error_number: 20)
    }
}

class NoSuchChargeError<T>: ReturnValue<T> {
    init() {
        super.init(error: true, error_number: 30)
    }
}

class FirebaseError<T>: ReturnValue<T> {
    init(error_message : String = "") {
        super.init(error: true, error_message: error_message, error_number: 50)
    }
}

class UnimplementedFunctionError<T>: ReturnValue<T> {
    init() {
        super.init(error: true, error_number: 100)
    }
}
