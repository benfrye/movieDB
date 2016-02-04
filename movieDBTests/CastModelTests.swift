//
//  CastModelTests.swift
//  movieDB
//
//  Created by Ben Frye on 2/4/16.
//  Copyright © 2016 benhamine. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import movieDB

class CastModelTests: XCTestCase {

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
    
    func testProcessCastData_returnsEmptyArray() {
        
        let testCastArray = Cast.processCastData(testCrewJSON)
        XCTAssert(testCastArray.count == 0)
    }
    
    func testProcessCastData_makesObjects() {
        
        self.loadTestCrewData()
        let testCastArray = Cast.processCastData(testCrewJSON)
        XCTAssert(testCastArray.count == 10)
    }
    
    func testProcessCastData_makesValidCrewObject() {
        
        self.loadTestCrewData()
        let testCastArray = Cast.processCastData(testCrewJSON)
        let testCastMember = testCastArray[0]
        
        XCTAssert(testCastMember.id == 56734)
        XCTAssert(testCastMember.characterName == "Cassie Sullivan")
        XCTAssert(testCastMember.name == "Chloë Grace Moretz")
        XCTAssert(testCastMember.order == 1)
        XCTAssert(testCastMember.profilePath == "/mVde2tB9TvR97LO7nferqTQq2nQ.jpg")
    }

}
