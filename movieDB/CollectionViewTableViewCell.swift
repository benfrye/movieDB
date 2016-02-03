//
//  CollectionViewTableViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/11/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        collectionView.registerNib(UINib(nibName: String(MovieCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: String(MovieCollectionViewCell))
    }
    
}
