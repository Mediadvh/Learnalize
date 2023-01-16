//
//  UserClassTest.swift
//  LearnalizeTests
//
//  Created by Media Davarkhah on 2/28/1401 AP.
//

import XCTest

class UserClassTest: XCTestCase {
    
    func initializationTest() throws {
        let testUser = User(fullName: "John Doe", picture: "pic", email: "John.doe@yahoo.com", password: "12345678910", username: "John_Doe", id: "")
        
        XCTAssertEqual(testUser.fullName, "John Doe")
        XCTAssertEqual(testUser.picture, "pic")
        XCTAssertEqual(testUser.email, "John.doe@yahoo.com")
        XCTAssertEqual(testUser.password, "12345678910")
        XCTAssertEqual(testUser.username, "John_Doe")
        
    }
    
     
    
    
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
           
            
        }
    }

}
