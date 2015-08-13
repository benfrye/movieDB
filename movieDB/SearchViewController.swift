//
//  SearchViewController.swift
//  movieDB
//
//  Created by Ben Frye on 8/12/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slideView: UIView!
    var openingConstraint: NSLayoutConstraint?
    
    var searchTerm: String?
    let dateFormatter = NSDateFormatter()
    var dataSource: [Movie]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        configureGestures()
        configureTableView()
    }
    
    func configureGestures() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "searchViewGestureDidPan:")
        slideView.addGestureRecognizer(panGesture)
    }
    
    func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: ImageTitleSubtitleTableViewCell.className, bundle: nil), forCellReuseIdentifier: ImageTitleSubtitleTableViewCell.className)
    }
    
    func loadSearch(searchTerm: String?) {
        if let searchTerm = searchTerm {
            
            self.searchTerm = searchTerm
            MovieImporter.sharedInstance.searchTitle(searchTerm, completion: { (movieArray) -> Void in
                
                self.dataSource = movieArray
                self.tableView.reloadData()
            })
        }
    }
    
    func openSearchView() {

        view.layer.removeAllAnimations()
        
        guard let parentViewController = parentViewController else {
            return
        }
        
        let constant = openHeight() + parentViewController.topLayoutGuide.length
        
        UIView.animateWithDuration(
            0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                
                self.openingConstraint?.constant = constant
                self.view.layoutIfNeeded()
                
            }) { (finished) -> Void in
                
                self.viewDidAppear(true)
        }
        
        tableView.reloadData()
    }
    
    func closeSearchView() {
        
        view.layer.removeAllAnimations()

        UIView.animateWithDuration(
            0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                
                self.openingConstraint?.constant = 0
                self.view.layoutIfNeeded()
                
            }) { (finished) -> Void in
                
                self.viewDidDisappear(true)
        }
    }
    
    func searchViewGestureDidPan(gesture: UIPanGestureRecognizer) {
        
        guard let openingConstraint = openingConstraint else {
            return
        }
        
        var constant = openingConstraint.constant
        let min = openHeight()// + parentViewController.topLayoutGuide.length

        switch gesture.state {
        case UIGestureRecognizerState.Changed:
            let translation = gesture.translationInView(view)
            constant += translation.y
            if constant < 0 {
                
                constant = 0
                
            } else if (constant > min) {
                
                constant = min
            }
            
            openingConstraint.constant = constant
            gesture.setTranslation(CGPointZero, inView: view)
            
        case UIGestureRecognizerState.Ended:
            var finalConstant: CGFloat = 0.0
            let velocity = gesture.velocityInView(view).y
            
            if fabs(velocity) > 50.0 {
                
                if (velocity > 0.0) {
                    finalConstant = min;
                }
            } else if constant > (min / 2.0) {
                
                finalConstant = min;
            }
            
            
            let duration = 1.0
            let distance = constant - finalConstant
            let initialVelocity = velocity / distance
            
            UIView.animateWithDuration(
                duration,
                delay: 0.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: initialVelocity,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in
                    
                    openingConstraint.constant = finalConstant
                    self.view.layoutIfNeeded()
                    
                }, completion: nil)
            
        default:
            break
        }
    }

    
    func isOpen() -> Bool {
        
        if let openingConstraint = openingConstraint {
            return openingConstraint.constant != 0
        }
        return false
    }
    
    func openHeight() -> CGFloat {
        
        if let parentViewController = parentViewController {
            return (parentViewController.view.frame.size.height)
        }
        return 0.0;
    }

// MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let dataSource = dataSource {
            
            return dataSource.count
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
            
            let movie = dataSource[indexPath.row]
            movie.fullyCache({ () -> Void in
                let movieViewController = MovieViewController()
                movieViewController.movie = movie
                self.navigationController?.pushViewController(movieViewController, animated: true)
            })
        }
    }

}
