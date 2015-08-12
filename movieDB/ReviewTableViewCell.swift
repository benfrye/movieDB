//
//  ReviewTableViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/12/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    static let className = "ReviewTableViewCell" // FIXME: Need to find a nicer way of doing this

    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithReview(review: Review) {
        reviewLabel.text = review.content
        authorLabel.text = "-\(review.author)"
        layoutIfNeeded()
    }
    
}
