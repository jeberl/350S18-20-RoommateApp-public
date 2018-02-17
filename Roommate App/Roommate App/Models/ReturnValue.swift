//
//  Error.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 2/16/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation

class ReturnValue<T> {
    
    let returned_error : Bool
    let error_message : String?
    let error_number : Int
    let data : T?
    
    init(error returned_error: Bool, data : T? = nil, error_message : String? = nil, error_number : Int? = nil) {
        self.returned_error = true
        self.error_message = returned_error ? error_message : nil
        self.error_number = returned_error ? error_number! : 0
        self.data = returned_error ? nil : data
    }
    
    func getErrorDescription() -> String {
        switch (self.error_number) {
            case 0: return "No Error"
            case 10: return "No Such User"
            case 11: return "User Must Be Owner of House"
            case 12: return "User Must Be Member of House"
            case 13: return "Email Address Already Associated With Another Account"
            case 20: return "No Such House"
            case 30: return "No Such Charge"
            case 100: return "Unimplemented Function"
            default: return "Unspecified Error"
        }
        
    }
}

class ExpectedExecution<T>: ReturnValue<T> {
    init() {
        super.init(error: false, error_number: 0)
    }
}

class NoSuchUserError<T>: ReturnValue<T> {
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

class UnimplementedFunctionError<T>: ReturnValue<T> {
    init() {
        super.init(error: true, error_number: 100)
    }
}
