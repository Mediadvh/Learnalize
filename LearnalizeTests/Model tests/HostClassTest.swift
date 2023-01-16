//
//  HostClassTest.swift
//  LearnalizeTests
//
//  Created by Media Davarkhah on 3/11/1401 AP.
//

import XCTest

class HostClassTest: XCTestCase {

    var sut: Host!
    let user = User(fullName: "John Doe", picture: "pic", email: "John.doe@yahoo.com", password: "12345678910", username: "John_Doe", id: "")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = Host(user: user, cameraIsOn: false, whiteBoardIsOn: false, micIsOn: false)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_initialization() {
        XCTAssertEqual(sut.fullName, user.fullName)
        XCTAssertEqual(sut.picture, user.picture)
        XCTAssertEqual(sut.email, user.email)
        XCTAssertEqual(sut.password, user.password)
        XCTAssertEqual(sut.username, user.username)
        XCTAssertEqual(sut.id, user.id)
        XCTAssertEqual(sut.cameraIsOn, false)
        XCTAssertEqual(sut.whiteBoardIsOn, false)
        XCTAssertEqual(sut.micIsOn, false)
        
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
