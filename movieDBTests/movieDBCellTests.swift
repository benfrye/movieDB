//
//  movieDBCellTests.swift
//  movieDB
//
//  Created by Ben Frye on 2/3/16.
//  Copyright © 2016 benhamine. All rights reserved.
//

import XCTest
@testable import movieDB

class movieDBCellTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReviewTableViewCellConfigures() {
        
        // configure test data
        let reviewAuthor = "John Smith"
        let reviewContent = "This movie rocked!"
        let review = Review(author: reviewAuthor, content: reviewContent)
        
        // configure cell
        let testCell = ReviewTableViewCell.loadFromNibNamed(String(ReviewTableViewCell)) as? ReviewTableViewCell
        testCell?.configureWithReview(review)
        
        // test
        XCTAssert(testCell?.authorLabel.text == "-\(reviewAuthor)")
        XCTAssert(testCell?.reviewLabel.text == reviewContent)
        
    }
    
}
