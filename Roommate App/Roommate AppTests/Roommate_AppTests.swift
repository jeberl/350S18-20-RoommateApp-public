//
//  Roommate_AppTests.swift
//  Roommate AppTests
//
//  Created by Elena Iaconis on 2/9/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import XCTest
import Firebase
import FirebaseDatabase
import FirebaseAuthUI

@testable import Roommate_App

let test_email_addresses: [String] = ["testinguser@test.com"]
let test_email_passwords: [String] = ["test123"]

class Roommate_AppTests: XCTestCase {
    
    var database : DatabaseAccess = DatabaseAccess.getInstance()
    var intitalUser : UserAccount?
    
    override func setUp() {
        super.setUp()
        //database = DatabaseAccess.getInstance()
        //database!.login(username: test_email_addresses[0], password: test_email_passwords[0], view : nil)
        //let error = database!.getUserModelFromCurrentUser(view: UIViewController(), callback: { (user) in
        //    print("created initial user")
        //    self.intitalUser = user
        //})
        //print(error.getErrorDescription())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testUserHasCorrectInitial (){
        //let error = database!.getUserModelFromCurrentUser(view: UIViewController(), callback: { (user) in
        //    print("created initial user")
        //    self.intitalUser = user
        //    XCTAssertEqual(user.email, test_email_addresses[0])
        //    XCTAssertEqual(user.nickname, test_email_addresses[0])
        //    XCTAssertEqual(user.houses, [])
        //    XCTAssertEqual(user.phoneNumber, nil)
    
        //})
        //if error.returned_error {
        //    XCTFail()
        //}

    }
    
    func testAddUserExists() {
        //Use XCTAssert and related functions to verify your tests produce the correct results.
        //self.data.createUser(email: "test1@test.com", password: "1234")
        //self.data.createUserModelFromEmail(email: "test1@test.com")
    }
 
    
    func testDeleteUser() {
        //signInUser(number: 0)
        //data.createHouse(newHouse: House()
    } 
    
    func testDeleteUserRemovedFromAllHouses() {
        XCTFail("To Implement")
    }
    
    func testDeleteUserNoSuchUserError() {
        XCTFail("To Implement")
    }
    
    func testGetSetUserGlobalNickname() {
        XCTFail("To Implement")
    }
    
    func testGetGlobalNicknameNoUserError() {
        XCTFail("To Implement")
    }
    
    func testSetGlobalNicknameNoUserError() {
        XCTFail("To Implement")
    }
    func testCreateHouse() {
        XCTFail("To Implement")
    }
    
    func testAddEmailAlreadyUserReutrnsError() {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        data.CreateHouse(HouseID: "H1")
//        data.CreateUser(email: "test1@test.com")
//        data.CreateUser(email: "test2@test.com")
//        data.CreateUser(email: "test3@test.com")
    }

    func testAuthentication() {
        XCTFail("To Implement")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddingChoreToDatabase() {
        let chore : ChoreAJ = ChoreAJ(chore_title: "Test Chore", assignor: "jesse@test", assignee: "brooke@test", time_assigned: NSDate(), house: "imiytlkvwiuvwpiuew", description: "testing adding to database")
        database.
    }
    
}
