//
//  Roommate_AppTests.swift
//  Roommate AppTests
//
//  Created by Elena Iaconis on 2/9/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import XCTest
@testable import Roommate_App


class Roommate_AppTests: XCTestCase {
    
    let data : DatabaseAccess = DatabaseAccess()
    
    override init() {
        super.init()
    }


    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }
    
    func testAddUserExists() {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        self.data.createUser(email: "test1@test.com", password: "1234")
        XCTAssert(self.data.doesUserExist(email: "test1@test.com"))
    }

    func testAddUserEmailAlreadyUsedError() {
        XCTFail("To Implement")
    }
    
    func testDeleteUser() {
        XCTFail("To Implement")
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
    
}
