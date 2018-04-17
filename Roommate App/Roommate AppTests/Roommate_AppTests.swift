//
//  Roommate_AppTests.swift
//  Roommate AppTests
//
//  Created by Elena Iaconis on 2/9/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import XCTest
import UIKit
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
    
    
    func barColorFromAmount(amount: Double) -> Void {
        let range = 100
        let cutEnds = (max(-1 * range, min(range, Int(amount))) + range) / 2
        let G : Int = (255 * cutEnds) / range
        let R : Int = (255 * (100 - cutEnds)) / range
        print(amount)
        print(R)
        print(G)
    }
    
    func testColor0(){
        barColorFromAmount(amount: 0)
        barColorFromAmount(amount: 75)
        barColorFromAmount(amount: 25)
        barColorFromAmount(amount: 105)
        barColorFromAmount(amount: -25)
        barColorFromAmount(amount: -75)
        barColorFromAmount(amount: -101)
    }
    
    func testColor75(){
        
    }

    func testColor150(){
        let color = barColorFromAmount(amount: 150)
    }

    func testColorNeg75(){
        let color = barColorFromAmount(amount: -75)
    }

    func testColorNeg150(){
        let color = barColorFromAmount(amount: -105)
    }
    
    func testParseStringToItems() {
        let s = "aaaa1234b1.23ccccwrwrg4vbee"
        var items = ReceiptParser.getInstance().parseStringToItems(read: s)
        items = items.filter({ (item) -> Bool in
            return item.1 > 0
        })
        XCTAssert(items.count == 3)
        XCTAssert(items[0].0 == "aaaa")
        XCTAssert(items[0].1 == 1234.0)
        XCTAssert(items[1].0 == "b")
        XCTAssert(items[1].1 == 1.23)
        XCTAssert(items[2].0 == "ccccwrwrg")
        XCTAssert(items[2].1 == 4.0)
    }
    
//    func testUserHasCorrectInitial (){
//        //let error = database!.getUserModelFromCurrentUser(view: UIViewController(), callback: { (user) in
//        //    print("created initial user")
//        //    self.intitalUser = user
//        //    XCTAssertEqual(user.email, test_email_addresses[0])
//        //    XCTAssertEqual(user.nickname, test_email_addresses[0])
//        //    XCTAssertEqual(user.houses, [])
//        //    XCTAssertEqual(user.phoneNumber, nil)
//
//        //})
//        //if error.returned_error {
//        //    XCTFail()
//        //}
//
//    }
//
//    func testAddUserExists() {
//        //Use XCTAssert and related functions to verify your tests produce the correct results.
//        //self.data.createUser(email: "test1@test.com", password: "1234")
//        //self.data.createUserModelFromEmail(email: "test1@test.com")
//    }
//
//
//    func testDeleteUser() {
//        //signInUser(number: 0)
//        //data.createHouse(newHouse: House()
//    }
//
//    func testDeleteUserRemovedFromAllHouses() {
//        XCTFail("To Implement")
//    }
//
//    func testDeleteUserNoSuchUserError() {
//        XCTFail("To Implement")
//    }
//
//    func testGetSetUserGlobalNickname() {
//        XCTFail("To Implement")
//    }
//
//    func testGetGlobalNicknameNoUserError() {
//        XCTFail("To Implement")
//    }
//
//    func testSetGlobalNicknameNoUserError() {
//        XCTFail("To Implement")
//    }
//    func testCreateHouse() {
//        XCTFail("To Implement")
//    }
//
//    func testAddEmailAlreadyUserReutrnsError() {
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
////        data.CreateHouse(HouseID: "H1")
////        data.CreateUser(email: "test1@test.com")
////        data.CreateUser(email: "test2@test.com")
////        data.CreateUser(email: "test3@test.com")
//    }
//
//    func testAuthentication() {
//        XCTFail("To Implement")
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//    /*func testAddingChoreToDatabase() {
//        let chore : ChoreAJ = ChoreAJ(chore_title: "Testing timestamp", assignor: "brooke@me.com", assignee: "brookeb@me.com", time_assigned: getTimestampAsString(), houseID: "abcabcabc", description: "testing with new time stamp")
//        database.createChore(chore: chore)
//    }*/
//
//    func testGettingUIDFromEmail() {
//        let userEmail : String = "brookeb@me.com"
//        var userID : String?
//        let getUIDClosure = { (returnedID : String?) -> Void in
//            userID = returnedID
//            XCTAssertEqual("h57nygSu5qeuRgOL2VU9RYZziIi2", userID)
//        }
//        database.getUIDFromEmail(email: userEmail, callback: getUIDClosure)
//        //XCTAssertEqual("brookeb@me&com", userID)
//        //XCTAssertEqual("h57nygSu5qeuRgOL2VU9RYZziIi2", userID)
//        while (userID == nil) {
//
//        }
//        print("userID in test = \(userID)")
//    }
//
//
//    /*func testAddingChargeToDatabase() {
//        let charge : Charge = Charge(from_user: "brooke@me.com", to_user: "brookeb@me.com", houseID: "xxxxxx", timestamp: getTimestampAsString(), amount: 10.00, message: "testing adding charge to database")
//    func testAddingChargeToDatabase() {
//        let amt : Double = 10.00
//        let charge : Charge = Charge(from_user: "brooke@me.com", to_user: "brookeb@me.com", houseID: "asdfasdf", timestamp: getTimestampAsString(), amount: amt, message: "test timestamp")
//
//        database.createCharge(charge: charge)
//    }*/
//
    func testCreateHouse() {
        let house : House = House(houseName: "Test House", address: "1 Test St,Philadelphia,PA,19104", houseUsers: [], owner: "brooke@email.com", incompleteChores: [], completeChores: [], recentCharges: [], recentInteractions: [])
        database.createHouse(house: house)
    }
    
    func testUpdatUserInDaHaus() {
        database.userNotInHouse(uid: "j31tDO7e8xXjXFjvNnRiYNVOtuL2", houseID: "LAAEbmoaXXmL42BI_QG")
        //database.ref.child("houses/-LAAEbmoaXXmL42BI_QG/house_users/j31tDO7e8xXjXFjvNnRiYNVOtuL2/in_da_haus").setValue(true)
    }
    
    
//    func testFormattingFullTimeStamp() {
//        let str1 = getTimestampAsString()
//        let str2 = "2018-04-01 16:25:05"
//        XCTAssertTrue(str1 > str2)
//    }
//
//    /*
//     COPIED OVER FROM OTHER FILES FOR TESTING PURPOSES
//     Gets the current time stamp and returns it as a string
//     Input: N/A
//     Output: String representation of timestamp
//     */
//    func getTimestampAsString() -> String {
//        let formatter = DateFormatter()
//
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let timeStamp = formatter.string(from: Date())
//        print(timeStamp)
//        return timeStamp
//    }
}
