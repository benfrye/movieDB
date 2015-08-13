//
//  CollectionViewTableViewCell.swift
//  movieDB
//
//  Created by Ben Frye on 8/11/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    static let className = "CollectionViewTableViewCell" // FIXME: Need to find a nicer way of doing this
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        collectionView.registerNib(UINib(nibName: MovieCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.className)
    }
    
}
