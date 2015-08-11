//
//  ImageTitleSubtitleTableViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/5/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

import UIKit

class ImageTitleSubtitleTableViewCell: UITableViewCell {

    @IBOutlet weak var noPhotoLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    static let className = "ImageTitleSubtitleTableViewCell" // FIXME: Need to find a nicer way of doing this
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.prepareForReuse()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
    
        super.prepareForReuse()
        self.thumbnailImageView.image = nil
        self.noPhotoLabel.hidden = false
        self.titleLabel.text = ""
        self.subtitleLabel.text = ""
    }
    
}
