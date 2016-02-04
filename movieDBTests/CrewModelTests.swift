//
//  CrewModelTests.swift
//  movieDB
//
//  Created by Ben Frye on 2/4/16.
//  Copyright © 2016 benhamine. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import movieDB

class CrewModelTests: XCTestCase {
    var testCrewJSON: JSON = []
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        testCrewJSON = []
    }
    
    private func loadTestCrewData() {
        
        if let path = NSBundle(forClass: self.dynamicType).pathForResource("TestCrewData", ofType: "json") {
            
            if let jsonData = NSData(contentsOfFile:path) {
                
                let jsonResult = JSON.init(data: jsonData)
                testCrewJSON = jsonResult
            }
        }
    }
    
    // MARK: Tests
    
    func testProcessCrewData_returnsEmptyArray() {
        
        let testCrewArray = Crew.processCrewData(testCrewJSON)
        XCTAssert(testCrewArray.count == 0)
    }
    
    func testProcessCrewData_makesObjects() {
        
        self.loadTestCrewData()
        let testCrewArray = Crew.processCrewData(testCrewJSON)
        XCTAssert(testCrewArray.count == 10)
    }
    
    func testProcessCrewData_makesValidCrewObject() {
        
        self.loadTestCrewData()
        let testCrewArray = Crew.processCrewData(testCrewJSON)
        let testCrewMember = testCrewArray[0]
        
        XCTAssert(testCrewMember.id == 111588)
        XCTAssert(testCrewMember.department == "Directing")
        XCTAssert(testCrewMember.name == "J Blakeson")
        XCTAssert(testCrewMember.job == "Director")
        XCTAssert(testCrewMember.profilePath == "/uioDLhI4kXUeNZPgBOv7gWvwG1q.jpg")
    }
    
}
