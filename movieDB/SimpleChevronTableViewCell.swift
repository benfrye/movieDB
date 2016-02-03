//
//  SimpleChevronTableViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/11/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class SimpleChevronTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var isSelectable = true
    
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
