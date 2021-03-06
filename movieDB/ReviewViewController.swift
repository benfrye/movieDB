//
//  ReviewViewController.swift
//  movieDB
//
//  Created by Ben Frye on 8/12/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movie: Movie?
    var dataSource: [Review]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Reviews"
        configureTableView()
    }
    
    func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerNib(UINib(nibName:String(ReviewTableViewCell), bundle: nil), forCellReuseIdentifier: String(ReviewTableViewCell))
        
        if let movie = movie {
            movie.reviews({ (reviews) -> Void in
                self.dataSource = reviews
                self.tableView.reloadData()
            })
        }
    }
    
// MARK: UITableViewDataSource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(String(ReviewTableViewCell), forIndexPath: indexPath)
    }
    
// MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if
            let reviewCell = cell as? ReviewTableViewCell,
            let dataSource = dataSource
        {
            reviewCell.configureWithReview(dataSource[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false;
    }
}
