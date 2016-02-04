//
//  MovieModelTests.swift
//  movieDB
//
//  Created by Ben Frye on 2/4/16.
//  Copyright © 2016 benhamine. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import movieDB

class MovieModelTests: XCTestCase {
    
    var testMovieJSON: JSON = []

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        testMovieJSON = []
    }

    private func loadTestMovieData() {
        
        if let path = NSBundle(forClass: self.dynamicType).pathForResource("TestMovieData", ofType: "json") {
            
            if let jsonData = NSData(contentsOfFile:path) {
                
                let jsonResult = JSON.init(data: jsonData)
                testMovieJSON = jsonResult
            }
        }
    }
    
// MARK: Tests
    
    func testProcessMovieData_returnsEmptyArray() {
        
        let testMovieArray = Movie.processMovieData(testMovieJSON)
        XCTAssert(testMovieArray.count == 0)
    }
    
    func testProcessMovieData_makesObjects() {
        
        self.loadTestMovieData()
        let testMovieArray = Movie.processMovieData(testMovieJSON)
        XCTAssert(testMovieArray.count == 3)
    }
    
    func testProcessMovieData_makesValidMovieObject() {
        
        self.loadTestMovieData()
        let testMovieArray = Movie.processMovieData(testMovieJSON)
        let testMovie = testMovieArray[0]
        let actualReleaseDate = NSDateFormatterCache.formatter("yyyy-MM-dd").dateFromString("2015-12-25")
        
        XCTAssert(testMovie.releaseDate == actualReleaseDate)
        XCTAssert(testMovie.movieID == 281957)
        XCTAssert(testMovie.title == "The Revenant")
        XCTAssert(testMovie.plotDescription == "In the 1820s, a frontiersman, Hugh Glass, sets out on a path of vengeance against those who left him for dead after a bear mauling.")
        XCTAssert(testMovie.posterPath == "/oXUWEc5i3wYyFnL1Ycu8ppxxPvs.jpg")
    }

}
