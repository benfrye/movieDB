//
//  SearchMovieTableViewController.swift
//  movieDB
//
//  Created by Ben Frye on 8/4/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SearchMovieTableViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter = NSDateFormatter()
    var dataSource: [Movie]?

    override func viewDidLoad() {
        
        searchBar.delegate = self
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        setupTableView()
        
        super.viewDidLoad()
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: ImageTitleSubtitleTableViewCell.className, bundle: nil), forCellReuseIdentifier: ImageTitleSubtitleTableViewCell.className)
    }
    
    
// MARK: UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            
            MovieImporter.sharedInstance.searchTitle(text, completion: { (movieArray) -> Void in
                
                searchBar.resignFirstResponder()
                self.dataSource = movieArray
                self.tableView.reloadData()
            })
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            dataSource = []
            tableView.reloadData()
        }
    }
    
// MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let movieArray = self.dataSource {
            
            return movieArray.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if
            let cell = tableView.dequeueReusableCellWithIdentifier(ImageTitleSubtitleTableViewCell.className) as? ImageTitleSubtitleTableViewCell,
            let dataSource = dataSource
        {
            let movie = dataSource[indexPath.row]
            
            //Title
            cell.titleLabel.text = movie.title
            
            //Poster Image
            movie.poster({ (posterImage) -> Void in
                //don't change the image if this cell has been recycled
                if cell.titleLabel.text == movie.title {
                    cell.thumbnailImageView.image = posterImage
                }
            })
            
            //Release Date
            if let releaseDate = movie.releaseDate {
                
                cell.subtitleLabel.text = self.dateFormatter.stringFromDate(releaseDate)
            }
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
    }
    
// MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 113.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 113.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let dataSource = dataSource {
            
            let movieViewController = MovieViewController()
            movieViewController.movie = dataSource[indexPath.row]
            navigationController?.pushViewController(movieViewController, animated: true)
        }
    }
}

