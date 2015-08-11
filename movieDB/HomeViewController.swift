//
//  HomeViewController.swift
//  movieDB
//
//  Created by Ben Frye on 8/11/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    enum TableSections: Int {
        case NewReleases
        case ComingSoon
        case Popular
        case SectionCount
    }

    @IBOutlet weak var tableView: UITableView!
    var tableViewDataSource: [UICollectionView]?
    
    var newReleasesDataSource: [Movie]?
    var comingSoonDataSource: [Movie]?
    var popularDataSource: [Movie]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: CollectionViewTableViewCell.className, bundle: nil), forCellReuseIdentifier: CollectionViewTableViewCell.className)
        tableView.registerNib(UINib(nibName: SimpleHeaderView.className, bundle: nil), forHeaderFooterViewReuseIdentifier: SimpleHeaderView.className)
        
        updateNewReleases()
        updateComingSoon()
        updatePopular()
    }
    
    func updateNewReleases() {
        
        MovieImporter.sharedInstance.newReleases { (movieArray) -> Void in
            self.newReleasesDataSource = movieArray
            self.tableView.reloadSections(NSIndexSet(index: TableSections.NewReleases.rawValue), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func updateComingSoon() {
        
        MovieImporter.sharedInstance.comingSoon { (movieArray) -> Void in
            self.comingSoonDataSource = movieArray
            self.tableView.reloadSections(NSIndexSet(index: TableSections.ComingSoon.rawValue), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func updatePopular() {
        
        MovieImporter.sharedInstance.popularFilms { (movieArray) -> Void in
            self.popularDataSource = movieArray
            self.tableView.reloadSections(NSIndexSet(index: TableSections.Popular.rawValue), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
// MARK: UITableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableSections.SectionCount.rawValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 39
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 128
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let collectionViewTableViewCell = tableView.dequeueReusableCellWithIdentifier(CollectionViewTableViewCell.className) as? CollectionViewTableViewCell{
            
            collectionViewTableViewCell.collectionView.delegate = self
            collectionViewTableViewCell.collectionView.dataSource = self
            collectionViewTableViewCell.collectionView.registerNib(UINib(nibName: MovieCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.className)
            
            return collectionViewTableViewCell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SimpleHeaderView.className) as? SimpleHeaderView {
            
            headerView.separatorView.hidden = true
            
            switch section {
            case TableSections.NewReleases.rawValue:
                headerView.titleLabel.text = "New Releases"
                
            case TableSections.ComingSoon.rawValue:
                headerView.titleLabel.text = "Coming Soon"
                
            case TableSections.Popular.rawValue:
                headerView.titleLabel.text = "Popular"
                
            default:
                break
            }
            
            return headerView
        }
        return nil
    }
    
// MARK: UICollectionViewDataSource Methods
    
    func dataSourceForCollectionView(collectionView: UICollectionView) -> [Movie]? {
        
        let pointInTable = collectionView.convertPoint(collectionView.bounds.origin, toView: self.tableView)
        if let indexPath = self.tableView.indexPathForRowAtPoint(pointInTable) {
            
            switch indexPath.section {
            case TableSections.NewReleases.rawValue:
                return newReleasesDataSource
                
            case TableSections.Popular.rawValue:
                return popularDataSource
                
            case TableSections.ComingSoon.rawValue:
                return comingSoonDataSource
                
            default:
                return nil
            }
        }

        return nil
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(MovieCollectionViewCell.className, forIndexPath: indexPath) as? MovieCollectionViewCell
        
        if
            let dataSource = dataSourceForCollectionView(collectionView),
            let collectionViewCell = collectionViewCell
        {
            collectionViewCell.movie = dataSource[indexPath.row]
            dataSource[indexPath.row].poster { (posterImage) -> Void in
                
                if
                    let movie = collectionViewCell.movie where movie == dataSource[indexPath.row],
                    let posterImage = posterImage
                {
                    collectionViewCell.movieImageView.image = posterImage
                }
                else
                {
                    collectionViewCell.defaultLabel.text = dataSource[indexPath.row].title
                    collectionViewCell.defaultLabel.hidden = false
                }
            }
            return collectionViewCell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let dataSource = dataSourceForCollectionView(collectionView) {
            return dataSource.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let dataSource = dataSourceForCollectionView(collectionView) {
            
            let movieViewController = MovieViewController()
            movieViewController.movie = dataSource[indexPath.row]
            navigationController?.pushViewController(movieViewController, animated: true)
        }
    }
}
