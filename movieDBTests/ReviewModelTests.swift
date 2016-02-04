//
//  ReviewModelTests.swift
//  movieDB
//
//  Created by Ben Frye on 2/4/16.
//  Copyright © 2016 benhamine. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import movieDB

class ReviewModelTests: XCTestCase {

    var testReviewJSON: JSON = []
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        testReviewJSON = []
    }
    
    private func loadTestReviewData() {
        
        if let path = NSBundle(forClass: self.dynamicType).pathForResource("TestReviewData", ofType: "json") {
            
            if let jsonData = NSData(contentsOfFile:path) {
                
                let jsonResult = JSON.init(data: jsonData)
                testReviewJSON = jsonResult
            }
        }
    }
    
    // MARK: Tests

    func testProcessReviewData_returnsEmptyArray() {
        
        let testReviewArray = Review.processReviewData(testReviewJSON)
        XCTAssert(testReviewArray.count == 0)
    }
    
    func testProcessReviewData_makesObjects() {
        
        self.loadTestReviewData()
        let testReviewArray = Review.processReviewData(testReviewJSON)
        XCTAssert(testReviewArray.count == 4)
    }
    
    func testProcessReviewData_makesValidReviewObject() {
        
        self.loadTestReviewData()
        let testReviewArray = Review.processReviewData(testReviewJSON)
        let testReview = testReviewArray[0]
        
        XCTAssert(testReview.author == "Phileas Fogg")
        XCTAssert(testReview.content == "Fabulous action movie. Lots of interesting characters. They don't make many movies like this. The whole movie from start to finish was entertaining I'm looking forward to seeing it again. I definitely recommend seeing it.")
    }
    
}
