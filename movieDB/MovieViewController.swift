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
    
    private enum TableSections: Int {
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
        movie?.videos({ (_: [Any]?) -> Void in
            
        })
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
        
        let numberOfRows: Int?
        
        if let switchSection = TableSections(rawValue: section) {
            
            switch switchSection {
            case .Cast:
                numberOfRows = self.castDataSource?.count
            case .Crew:
                numberOfRows = self.crewDataSource?.count
            default:
                numberOfRows = 1
            }
            
            if let numberOfRows = numberOfRows {
                return numberOfRows
            }
        }
        return 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.contentView.backgroundColor = UIColor.whiteColor()
        
        if let switchSection = TableSections(rawValue: indexPath.section) {
           
            switch switchSection {
            case .Header:
                if let headerCell = tableView.dequeueReusableCellWithIdentifier(ClearHeaderTableViewCell.className) {
                    cell = headerCell
                }
                
            case .Detail:
                if let detailCell = tableView.dequeueReusableCellWithIdentifier(MovieDescriptionTableViewCell.className) {
                    cell = detailCell
                }
                
            case .Reviews:
                if let reviewCell = tableView.dequeueReusableCellWithIdentifier(SimpleChevronTableViewCell.className) {
                    cell = reviewCell
                }
                
            case .Cast:
                if let castCell = tableView.dequeueReusableCellWithIdentifier(ImageTitleSubtitleTableViewCell.className) {
                    cell = castCell
                }
                
            case .Crew:
                if let crewCell = tableView.dequeueReusableCellWithIdentifier(ImageTitleSubtitleTableViewCell.className) {
                    cell = crewCell
                }
                
            case .SimilarMovies:
                if let similarMoviesCell = tableView.dequeueReusableCellWithIdentifier(CollectionViewTableViewCell.className) {
                    cell = similarMoviesCell
                }
                
            default:
                break
            }

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView: UIView? = nil
        
        if let switchSection = TableSections(rawValue: section) {
            
            switch switchSection {
            case .Crew:
                if let simpleHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SimpleHeaderView.className) {
                    headerView = simpleHeaderView
                }
                
            case .Cast:
                if let simpleHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SimpleHeaderView.className) {
                    headerView = simpleHeaderView
                }
                
            case .SimilarMovies:
                if let simpleHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SimpleHeaderView.className) {
                    headerView = simpleHeaderView
                }
                
            default:
                break
            }
        }
        
        return headerView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TableSections.SectionCount.rawValue
    }
    
// MARK: UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let switchSection = TableSections(rawValue: indexPath.section) {
            
            switch switchSection {
            case .Header:
                break
                
            case .Detail:
                if let cell = cell as? MovieDescriptionTableViewCell {
                    
                    if let releaseDate = movie?.releaseDate {
                        cell.dateLabel.text = dateFormatter.stringFromDate(releaseDate)
                    }
                    cell.titleLabel.text = movie?.title
                    cell.descriptionLabel.text = movie?.plotDescription
                }
                
            case .Reviews:
                if let cell = cell as? SimpleChevronTableViewCell {
                    
                    cell.titleLabel.text = "Reviews"
                    cell.setSelectable(false)
                    movie?.reviews({ (reviews) -> Void in
                        if let reviews = reviews where reviews.count > 0 {
                            cell.setSelectable(true)
                        }
                    })
                }
                
            case .Cast:
                if
                    let cell = cell as? ImageTitleSubtitleTableViewCell,
                    let dataSource = castDataSource
                {
                    let castMember = dataSource[indexPath.row]
                    cell.titleLabel.text = castMember.name
                    cell.subtitleLabel.text = castMember.characterName
                    castMember.profileImage({ (profileImage) -> Void in
                        
                        //don't change the image if this cell has been recycled
                        if
                            cell.titleLabel.text == castMember.name,
                            let profileImage = profileImage
                        {
                            cell.thumbnailImageView.image = profileImage
                        }
                        else
                        {
                            cell.noPhotoLabel.hidden = false
                        }
                        
                    })
                }
                
            case .Crew:
                if
                    let cell = cell as? ImageTitleSubtitleTableViewCell,
                    let dataSource = crewDataSource
                {
                    let crewMember = dataSource[indexPath.row]
                    cell.titleLabel.text = crewMember.name
                    cell.subtitleLabel.text = crewMember.job
                    crewMember.profileImage({ (profileImage) -> Void in
                        
                        //don't change the image if this cell has been recycled
                        if
                            cell.titleLabel.text == crewMember.name,
                            let profileImage = profileImage
                        {
                            cell.thumbnailImageView.image = profileImage
                        }
                        else
                        {
                            cell.noPhotoLabel.hidden = false
                        }
                    })
                }
                
            case .SimilarMovies:
                if let cell = cell as? CollectionViewTableViewCell {
                    similarMoviesCollectionView = cell.collectionView
                    similarMoviesCollectionView!.delegate = self
                    similarMoviesCollectionView!.dataSource = self
                }
                
            default:
                break
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let switchSection = TableSections(rawValue: section) {
            
            switch switchSection {
            case .Crew:
                if let simpleHeaderView = view as? SimpleHeaderView {
                    simpleHeaderView.titleLabel.text = "Crew"
                }
                
            case .Cast:
                if let simpleHeaderView = view as? SimpleHeaderView {
                    simpleHeaderView.titleLabel.text = "Cast"
                }
                
            case .SimilarMovies:
                if let simpleHeaderView = view as? SimpleHeaderView {
                    simpleHeaderView.separatorView.hidden = true
                    simpleHeaderView.titleLabel.text = "Similar Movies"
                }
                
            default:
                break
            }
        }
    }
    
    func heightForSection(section: Int) -> CGFloat {
        
        if let switchSection = TableSections(rawValue: section) {
            
            switch switchSection {
            case .Header:
                if let _ = movie?.cachedBackdrop {
                    return 225.0
                }
                
            case .Cast:
                if let cast = movie?.cachedCast where cast.count > 0 {
                    return 100.0
                }
                
            case .Crew:
                if let crew = movie?.cachedCrew where crew.count > 0 {
                    return 100.0
                }
                
            case .SimilarMovies:
                if let similarMovies = movie?.cachedSimilarMovies where similarMovies.count > 0 {
                    return 128.0
                }
                
            default:
                return UITableViewAutomaticDimension
            }

        }
        
        return 0.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if let switchSection = TableSections(rawValue: section) {
            
            switch switchSection {
            case .Cast:
                if
                    let cast = movie?.cachedCast where cast.count > 0,
                    let view = self.tableView(tableView, viewForHeaderInSection: section)
                {
                    
                    let size = view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                    return size.height
                }
                
            case .Crew:
                if
                    let crew = movie?.cachedCrew where crew.count > 0,
                    let view = self.tableView(tableView, viewForHeaderInSection: section)
                {
                    
                    let size = view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                    return size.height
                }
                
            case .SimilarMovies:
                if
                    let similarMovies = movie?.cachedSimilarMovies where similarMovies.count > 0,
                    let view = self.tableView(tableView, viewForHeaderInSection: section)
                {
                    let size = view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
                    return size.height
                }
                
            default:
                break
            }
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
        
        if let switchSection = TableSections(rawValue: indexPath.section) {
         
            switch switchSection {
            case .Reviews:
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                let reviewViewController = ReviewViewController()
                reviewViewController.movie = self.movie
                navigationController?.pushViewController(reviewViewController, animated: true)
                
            default:
                break
                
            }
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
        return collectionView.dequeueReusableCellWithReuseIdentifier(MovieCollectionViewCell.className, forIndexPath: indexPath)
    }
    
// MARK: UICollectionViewDelegate Methods
    
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
}
