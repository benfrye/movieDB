//
//  HomeViewController.swift
//  movieDB
//
//  Created by Ben Frye on 8/11/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class HomeViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UISearchBarDelegate
{
    
    private enum TableSections: Int {
        case NewReleases
        case ComingSoon
        case Popular
        case SectionCount
    }

    @IBOutlet weak var tableView: UITableView!
    var tableViewDataSource: [UICollectionView]?
    let searchBar = UISearchBar()
    let searchViewController = SearchViewController()
    
    var newReleasesDataSource: [Movie]?
    var comingSoonDataSource: [Movie]?
    var popularDataSource: [Movie]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureNavBar()
        configureTableView()
        configureSearchView()
    }
    
    func configureNavBar() {
        
        edgesForExtendedLayout = UIRectEdge.None
        
        searchBar.delegate = self
        searchBar.placeholder = "Search Movies"
        navigationItem.titleView = searchBar
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: String(CollectionViewTableViewCell), bundle: nil), forCellReuseIdentifier: String(CollectionViewTableViewCell))
        tableView.registerNib(UINib(nibName: String(SimpleHeaderView), bundle: nil), forHeaderFooterViewReuseIdentifier: String(SimpleHeaderView))
        
        updateNewReleases()
        updateComingSoon()
        updatePopular()
    }
    
    func configureSearchView() {
        
        addChildViewController(searchViewController)
        
        let searchView = searchViewController.view
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)
        
        let trailingConstraint = NSLayoutConstraint(
            item: searchView,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: searchView.superview,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1.0,
            constant: 0.0)
        
        let leadingConstraint = NSLayoutConstraint(
            item: searchView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: searchView.superview,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1.0,
            constant: 0.0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: searchView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: tableView,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: 0.0)
        
        let heightConstraint = NSLayoutConstraint(
            item: searchView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: view.frame.size.height)
        
        searchView.superview?.addConstraint(trailingConstraint)
        searchView.superview?.addConstraint(leadingConstraint)
        searchView.superview?.addConstraint(bottomConstraint)
        searchView.addConstraint(heightConstraint)
        searchViewController.openingConstraint = bottomConstraint
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
        return 39.0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 128.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 128.0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(String(CollectionViewTableViewCell), forIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier(String(SimpleHeaderView))
    }
    
// MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? SimpleHeaderView {
            
            view.separatorView.hidden = true
            
            if let switchSection = TableSections(rawValue: section) {
                switch switchSection {
                case .NewReleases:
                    view.titleLabel.text = "New Releases"
                case .ComingSoon:
                    view.titleLabel.text = "Coming Soon"
                case .Popular:
                    view.titleLabel.text = "Popular"
                default:
                    break
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? CollectionViewTableViewCell {
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
        }
    }
    
// MARK: UICollectionViewDataSource Methods
    
    func dataSourceForCollectionView(collectionView: UICollectionView) -> [Movie]? {
        
        let pointInTable = collectionView.convertPoint(collectionView.bounds.origin, toView: self.tableView)
        if
            let indexPath = self.tableView.indexPathForRowAtPoint(pointInTable),
            let switchSection = TableSections(rawValue: indexPath.section)
        {
            switch switchSection {
            case .NewReleases:
                return newReleasesDataSource
            case .Popular:
                return popularDataSource
            case .ComingSoon:
                return comingSoonDataSource
            default:
                return nil
            }
        }

        return nil
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(String(MovieCollectionViewCell), forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if
            let cell = cell as? MovieCollectionViewCell,
            let dataSource = dataSourceForCollectionView(collectionView)
        {
            cell.movie = dataSource[indexPath.row]
            dataSource[indexPath.row].poster { (posterImage) -> Void in
                
                //don't change the image if this cell has been recycled
                if let movie = cell.movie where movie == dataSource[indexPath.row] {
                    
                    if let posterImage = posterImage {
                        
                        cell.movieImageView.image = posterImage
                        
                    } else {
                        
                        cell.defaultLabel.text = dataSource[indexPath.row].title
                        cell.defaultLabel.hidden = false
                    }
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let dataSource = dataSourceForCollectionView(collectionView) {
            return dataSource.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let dataSource = dataSourceForCollectionView(collectionView) {
            
            let movie = dataSource[indexPath.row]
            movie.fullyCache({ () -> Void in
                let movieViewController = MovieViewController()
                movieViewController.movie = movie
                self.navigationController?.pushViewController(movieViewController, animated: true)
            })
        }
    }
    
// MARK: UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchViewController.loadSearch(searchBar.text)
        searchViewController.openSearchView()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            searchBar.resignFirstResponder()
        }
    }
}
