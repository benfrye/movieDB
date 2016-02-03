//
//  UIViewNibLoading.swift
//  movieDB
//
//  Created by Ben Frye on 2/3/16.
//  Copyright © 2016 benhamine. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}