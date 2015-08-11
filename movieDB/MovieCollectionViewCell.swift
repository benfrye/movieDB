//
//  MovieCollectionViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/7/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var defaultLabel: UILabel!
    var movie: Movie?
    
    static let className = "MovieCollectionViewCell" // FIXME: Need to find a nicer way of doing this
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        
        movieImageView.image = nil
        defaultLabel.text = ""
        defaultLabel.hidden = true
    }

}
