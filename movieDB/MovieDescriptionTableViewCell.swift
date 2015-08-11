//
//  MovieDescriptionTableViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/10/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class MovieDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let className = "MovieDescriptionTableViewCell" // FIXME: Need to find a nicer way of doing this
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
        self.dateLabel.text = ""
    }
    
}
