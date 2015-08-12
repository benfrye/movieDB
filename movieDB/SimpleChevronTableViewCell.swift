//
//  SimpleChevronTableViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/11/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class SimpleChevronTableViewCell: UITableViewCell {

    static let className = "SimpleChevronTableViewCell" // FIXME: Need to find a nicer way of doing this
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var isSelectable = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
    
    func setSelectable(selectable: Bool) {
        isSelectable = selectable
        if isSelectable {
            titleLabel.textColor = UIColor.blackColor()
        } else {
            titleLabel.textColor = UIColor.grayColor()
        }
    }
}
