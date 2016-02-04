//
//  MovieImporterTests.swift
//  movieDB
//
//  Created by Ben Frye on 2/3/16.
//  Copyright © 2016 benhamine. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import movieDB

class MovieImporterTests: XCTestCase {

    var TestJSON: JSON = []
    let dateFormatter = NSDateFormatter()
    
    override func setUp() {
        super.setUp()
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        TestJSON = []
    }
    
    private func loadTestData() {
        
        if let path = NSBundle(forClass: self.dynamicType).pathForResource("TestMovieData", ofType: "json") {
            
            if let jsonData = NSData(contentsOfFile:path) {
                
                let jsonResult = JSON.init(data: jsonData)
                TestJSON = jsonResult
            }
        }
    }
    
    func testProcessMovieDataReturnsEmptyArray() {
        
        let testMovieArray = MovieImporter.sharedInstance.processMovieData(TestJSON)
        XCTAssert(testMovieArray.count == 0)
        
    }
    
    func testProcessMovieDataMakesObjects() {
        
        self.loadTestData()
        let testMovieArray = MovieImporter.sharedInstance.processMovieData(TestJSON)
        XCTAssert(testMovieArray.count == 3)
        
    }
    
    func testProcessMovieDataMakesValidMovieObject() {

        self.loadTestData()
        let testMovieArray = MovieImporter.sharedInstance.processMovieData(TestJSON)
        let testMovie = testMovieArray[0]
        let actualReleaseDate = self.dateFormatter.dateFromString("2015-12-25")
        
        XCTAssert(testMovie.releaseDate == actualReleaseDate)
        XCTAssert(testMovie.movieID == 281957)
        XCTAssert(testMovie.title == "The Revenant")
        XCTAssert(testMovie.plotDescription == "In the 1820s, a frontiersman, Hugh Glass, sets out on a path of vengeance against those who left him for dead after a bear mauling.")
        XCTAssert(testMovie.posterPath == "/oXUWEc5i3wYyFnL1Ycu8ppxxPvs.jpg")
        
    }

}
