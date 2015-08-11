//
//  MovieTableCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/5/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

import UIKit

class MovieTableCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    
    static let className = "MovieTableCell" // FIXME: Need to find a nicer way of doing this
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.prepareForReuse()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
    
        super.prepareForReuse()
        self.posterImageView.image = nil
        self.titleLabel.text = ""
        self.releaseDateLabel.text = ""
        self.directorLabel.text = ""
    }
    
}
