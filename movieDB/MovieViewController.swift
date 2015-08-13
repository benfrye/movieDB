//
//  MovieViewController.swift
//  movieDB
//
//  Created by Ben Frye on 8/10/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class MovieViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate
{
    
    enum TableSections: Int {
        case Header
        case Detail
        case Reviews
        case Crew
        case Cast
        case SimilarMovies
        case SectionCount
    }
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var similarMoviesCollectionView: UICollectionView?
    
    let dateFormatter = NSDateFormatter()
    var movie: Movie?
    var castDataSource: [Cast]?
    var crewDataSource: [Crew]?
    var similarMoviesDataSource: [Movie]?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        configureView()
    }
    
    func configureView() {
        
        edgesForExtendedLayout = UIRectEdge.None
        configureTableView()
        
        if let movie = movie {
            
            movie.backdrop({ (backdropImage) -> Void in
                self.backdropImageView.image = backdropImage
            })
            
            movie.cast({ (cast) -> Void in
                self.castDataSource = cast
                self.tableView.reloadData()
            })
            
            movie.specialCrew({ (crew) -> Void in
                self.crewDataSource = crew
                self.tableView.reloadData()
            })
            
            movie.similarMovies({ (similarMovies) -> Void in
                self.similarMoviesDataSource = similarMovies
                self.tableView.reloadData()
                self.similarMoviesCollectionView?.reloadData()
            })
        }
    }
    
    func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: SimpleHeaderView.className, bundle: nil), forHeaderFooterViewReuseIdentifier: SimpleHeaderView.className)
        
        tableView.registerNib(UINib(nibName: ClearHeaderTableViewCell.className, bundle: nil), forCellReuseIdentifier: ClearHeaderTableViewCell.className)
        tableView.registerNib(UINib(nibName: MovieDescriptionTableViewCell.className, bundle: nil), forCellReuseIdentifier: MovieDescriptionTableViewCell.className)
        tableView.registerNib(UINib(nibName: SimpleChevronTableViewCell.className, bundle: nil), forCellReuseIdentifier: SimpleChevronTableViewCell.className)
        tableView.registerNib(UINib(nibName: ImageTitleSubtitleTableViewCell.className, bundle: nil), forCellReuseIdentifier: ImageTitleSubtitleTableViewCell.className)
        tableView.registerNib(UINib(nibName: CollectionViewTableViewCell.className, bundle: nil), forCellReuseIdentifier: CollectionViewTableViewCell.className)
    }
    
// MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int?
        
        switch section {
            
        case TableSections.Cast.rawValue:
            numberOfRows = self.castDataSource?.count
            
        case TableSections.Crew.rawValue:
            numberOfRows = self.crewDataSource?.count
            
        default:
            numberOfRows = 1
        }
        
        if let numberOfRows = numberOfRows {
            return numberOfRows
        }
        return 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.contentView.backgroundColor = UIColor.whiteColor()
        
        switch indexPath.section {
        case TableSections.Header.rawValue:
            if let headerCell = tableView.dequeueReusableCellWithIdentifier(ClearHeaderTableViewCell.className) {
                cell = headerCell
            }
            
        case TableSections.Detail.rawValue:
            if let detailCell = tableView.dequeueReusableCellWithIdentifier(MovieDescriptionTableViewCell.className) as? MovieDescriptionTableViewCell {

                if let releaseDate = movie?.releaseDate {
                    detailCell.dateLabel.text = dateFormatter.stringFromDate(releaseDate)
                }
                detailCell.titleLabel.text = movie?.title
                detailCell.descriptionLabel.text = movie?.plotDescription
                cell = detailCell
            }
            
        case TableSections.Reviews.rawValue:
            if let reviewCell = tableView.dequeueReusableCellWithIdentifier(SimpleChevronTableViewCell.className) as? SimpleChevronTableViewCell {
                
                reviewCell.titleLabel.text = "Reviews"
                reviewCell.setSelectable(false)
                movie?.reviews({ (reviews) -> Void in
                    if let reviews = reviews where reviews.count > 0 {
                        reviewCell.setSelectable(true)
                    }
                })
                
                cell = reviewCell
            }
            
        case TableSections.Cast.rawValue:
            if
                let castCell = tableView.dequeueReusableCellWithIdentifier(ImageTitleSubtitleTableViewCell.className) as? ImageTitleSubtitleTableViewCell,
                let dataSource = castDataSource
            {
                let castMember = dataSource[indexPath.row]
                castCell.titleLabel.text = castMember.name
                castCell.subtitleLabel.text = castMember.characterName
                castMember.profileImage({ (profileImage) -> Void in
                    
                    //don't change the image if this cell has been recycled
                    if
                        castCell.titleLabel.text == castMember.name,
                        let profileImage = profileImage
                    {
                        castCell.thumbnailImageView.image = profileImage
                    }
                    else
                    {
                        castCell.noPhotoLabel.hidden = false
                    }
                    
                })
                cell = castCell
            }
            
        case TableSections.Crew.rawValue:
            if
                let crewCell = tableView.dequeueReusableCellWithIdentifier(ImageTitleSubtitleTableViewCell.className) as? ImageTitleSubtitleTableViewCell,
                let dataSource = crewDataSource
            {
                let crewMember = dataSource[indexPath.row]
                crewCell.titleLabel.text = crewMember.name
                crewCell.subtitleLabel.text = crewMember.job
                crewMember.profileImage({ (profileImage) -> Void in
                    
                    //don't change the image if this cell has been recycled
                    if
                        crewCell.titleLabel.text == crewMember.name,
                        let profileImage = profileImage
                    {
                        crewCell.thumbnailImageView.image = profileImage
                    }
                    else
                    {
                        crewCell.noPhotoLabel.hidden = false
                    }
                })
                cell = crewCell
            }
            
        case TableSections.SimilarMovies.rawValue:
            if let similarMoviesCell = tableView.dequeueReusableCellWithIdentifier(CollectionViewTableViewCell.className) as? CollectionViewTableViewCell {
                similarMoviesCollectionView = similarMoviesCell.collectionView
                similarMoviesCollectionView!.delegate = self
                similarMoviesCollectionView!.dataSource = self
                cell = similarMoviesCell
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView: UIView?
        
        switch section {
        case TableSections.Crew.rawValue:
            if let simpleHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SimpleHeaderView.className) as? SimpleHeaderView {
                simpleHeaderView.titleLabel.text = "Crew"
                headerView = simpleHeaderView
            }
            
        case TableSections.Cast.rawValue:
            if let simpleHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SimpleHeaderView.className) as? SimpleHeaderView {
                simpleHeaderView.titleLabel.text = "Cast"
                headerView = simpleHeaderView
            }
            
        case TableSections.SimilarMovies.rawValue:
            if let simpleHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SimpleHeaderView.className) as? SimpleHeaderView {
                simpleHeaderView.separatorView.hidden = true
                simpleHeaderView.titleLabel.text = "Similar Movies"
                headerView = simpleHeaderView
            }
            
        default:
            headerView = nil
        }
        
        return headerView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableSections.SectionCount.rawValue
    }
    
// MARK: UITableViewDelegate Methods
    
    func heightForSection(section: Int) -> CGFloat {
        
        switch section {
        case TableSections.Header.rawValue:
            if
                let movie = movie,
                let _ = movie.cachedBackdrop
            {
                return 225.0
            }
            
        case TableSections.Cast.rawValue:
            if
                let movie = movie,
                let cast = movie.cachedCast where cast.count > 0
            {
                return 100.0
            }
            
        case TableSections.Crew.rawValue:
            if
                let movie = movie,
                let crew = movie.cachedCrew where crew.count > 0
            {
                return 100.0
            }
            
        case TableSections.SimilarMovies.rawValue:
            if
                let movie = movie,
                let similarMovies = movie.cachedSimilarMovies where similarMovies.count > 0
            {
                return 128.0
            }
            
        default:
            return UITableViewAutomaticDimension
        }
        
        return 0.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case TableSections.Cast.rawValue:
            if
                let movie = movie,
                let cast = movie.cachedCast where cast.count > 0,
                let view = self.tableView(tableView, viewForHeaderInSection: section)
            {
                
                let size = view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                return size.height
            }
            
        case TableSections.Crew.rawValue:
            if
                let movie = movie,
                let crew = movie.cachedCrew where crew.count > 0,
                let view = self.tableView(tableView, viewForHeaderInSection: section)
            {
                
                let size = view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                return size.height
            }
            
        case TableSections.SimilarMovies.rawValue:
            if
                let movie = movie,
                let similarMovies = movie.cachedSimilarMovies where similarMovies.count > 0,
                let view = self.tableView(tableView, viewForHeaderInSection: section)
            {
                let size = view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                return size.height
            }
            
        default:
            break
        }
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightForSection(indexPath.section)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return heightForSection(indexPath.section)
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        switch indexPath.section {
        case TableSections.Reviews.rawValue:
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? SimpleChevronTableViewCell where cell.isSelectable {
                return true
            } else {
                break
            }
            
        default:
            break
        }
        
        return false
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
            
        case TableSections.Reviews.rawValue:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let reviewViewController = ReviewViewController()
            reviewViewController.movie = self.movie
            navigationController?.pushViewController(reviewViewController, animated: true)
            
        default:
            break
            
        }
    }
    
// UICollectionViewDataSource Methods
    
    func dataSourceForCollectionView(collectionView: UICollectionView) -> [Movie]? {
        
        let pointInTable = collectionView.convertPoint(collectionView.bounds.origin, toView: self.tableView)
        if let indexPath = self.tableView.indexPathForRowAtPoint(pointInTable) {
            
            switch indexPath.section {
            case TableSections.SimilarMovies.rawValue:
                return similarMoviesDataSource
                
            default:
                return nil
            }
        }
        
        return nil
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let dataSource = dataSourceForCollectionView(collectionView) {
            return dataSource.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if
            let dataSource = dataSourceForCollectionView(collectionView),
            let collectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(MovieCollectionViewCell.className, forIndexPath: indexPath) as? MovieCollectionViewCell
        {
            collectionViewCell.movie = dataSource[indexPath.row]
            dataSource[indexPath.row].poster { (posterImage) -> Void in
                
                //don't change the image if this cell has been recycled
                if let movie = collectionViewCell.movie where movie == dataSource[indexPath.row] {
                    
                    if let posterImage = posterImage {
                        
                        collectionViewCell.movieImageView.image = posterImage
                        
                    } else {
                        
                        collectionViewCell.defaultLabel.text = dataSource[indexPath.row].title
                        collectionViewCell.defaultLabel.hidden = false
                    }
                }
            }
            return collectionViewCell
        }
        
        return UICollectionViewCell()
    }
}
