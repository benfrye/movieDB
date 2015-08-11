//
//  SimpleHeaderView.swift
//  movieDB
//
//  Created by Ben Frye on 8/10/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class SimpleHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    static let className = "SimpleHeaderView" // FIXME: Need to find a nicer way of doing this

}
