//
//  ActivitiyStructTest.swift
//  LearnalizeTests
//
//  Created by Media Davarkhah on 3/11/1401 AP.
//

import XCTest

class ActivitiyStructTest: XCTestCase {
    var sut: Activity!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       
        sut = Activity(uid: "291iuwehjsk", name: "Physics 101", description: "no background needed", participantsLimit: 9)
        
       
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    // start of functionality test cases
    func test_initialization() {
        let uid = Authentication.shared.getCurrentUserUid()
        XCTAssertEqual(sut.uid, "291iuwehjsk")
        XCTAssertEqual(sut.name, "Physics 101")
        XCTAssertEqual(sut.description, "no background needed")
        XCTAssertEqual(sut.participantsLimit, 9)
        
        
        XCTAssertEqual(sut.hostId, uid)
    }
    
    
    // read chapter test network calls

    func test_create_Activity() {
        
    }
    func test_end_Activity() {
        
    }
    
    
    // end of test cases
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
