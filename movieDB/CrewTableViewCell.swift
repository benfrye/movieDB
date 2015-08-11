//
//  CrewTableViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/10/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class CrewTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var noPhotoLabel: UILabel!
    
    static let className = "CrewTableViewCell" // FIXME: Need to find a nicer way of doing this
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        noPhotoLabel.hidden = true
        profileImageView.image = nil
        nameLabel.text = ""
        jobLabel.text = ""
    }
    
}
