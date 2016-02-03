//
//  ReviewTableViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/12/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    func configureWithReview(review: Review) {
        reviewLabel.text = review.content
        authorLabel.text = "-\(review.author)"
        layoutIfNeeded()
    }
    
}
