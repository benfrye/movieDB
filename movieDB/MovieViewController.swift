//
//  MovieViewController.swift
//  movieDB
//
//  Created by Ben Frye on 8/10/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum TableSections: Int {
        case HeaderSection
        case DetailSection
        case CrewSection
        case CastSection
        case SectionCount
    }
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter = NSDateFormatter()
    var movie: Movie?
    var castDataSource: [Cast]?
    var crewDataSource: [Crew]?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        configureView()
    }
    
    func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNib(UINib(nibName: ClearHeaderTableViewCell.className, bundle: nil), forCellReuseIdentifier: ClearHeaderTableViewCell.className)
        tableView.registerNib(UINib(nibName: MovieDescriptionTableViewCell.className, bundle: nil), forCellReuseIdentifier: MovieDescriptionTableViewCell.className)
        tableView.registerNib(UINib(nibName: CrewTableViewCell.className, bundle: nil), forCellReuseIdentifier: CrewTableViewCell.className)
        
        tableView.registerNib(UINib(nibName: SimpleHeaderView.className, bundle: nil), forHeaderFooterViewReuseIdentifier: SimpleHeaderView.className)
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
        }
    }
    
// MARK: UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int?
        
        switch section {
        case TableSections.HeaderSection.rawValue:
            numberOfRows = 1
            
        case TableSections.DetailSection.rawValue:
            numberOfRows = 1
            
        case TableSections.CastSection.rawValue:
            numberOfRows = self.castDataSource?.count
            
        case TableSections.CrewSection.rawValue:
            numberOfRows = self.crewDataSource?.count
            
        default:
            numberOfRows = 0
        }
        
        if let numberOfRows = numberOfRows {
            return numberOfRows
        }
        return 0
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.whiteColor()
        
        switch indexPath.section {
        case TableSections.HeaderSection.rawValue:
            if let headerCell = tableView.dequeueReusableCellWithIdentifier(ClearHeaderTableViewCell.className) {
                cell = headerCell
            }
            
        case TableSections.DetailSection.rawValue:
            if let detailCell = tableView.dequeueReusableCellWithIdentifier(MovieDescriptionTableViewCell.className) as? MovieDescriptionTableViewCell {

                if let releaseDate = movie?.releaseDate {
                    detailCell.dateLabel.text = dateFormatter.stringFromDate(releaseDate)
                }
                detailCell.titleLabel.text = movie?.title
                detailCell.descriptionLabel.text = movie?.plotDescription
                cell = detailCell
            }
            
        case TableSections.CastSection.rawValue:
            if let castCell = tableView.dequeueReusableCellWithIdentifier(CrewTableViewCell.className) as? CrewTableViewCell {
                
                if let dataSource = castDataSource {
                    
                    let castMember = dataSource[indexPath.row]
                    castCell.nameLabel.text = castMember.name
                    castCell.jobLabel.text = castMember.characterName
                    castMember.profileImage({ (profileImage) -> Void in
                        
                        if
                            castCell.nameLabel.text == castMember.name,
                            let profileImage = profileImage
                        {
                            castCell.profileImageView.image = profileImage
                        }
                        else
                        {
                            castCell.noPhotoLabel.hidden = false
                        }
                        
                    })
                    cell = castCell
                }
            }
            
        case TableSections.CrewSection.rawValue:
            if let crewCell = tableView.dequeueReusableCellWithIdentifier(CrewTableViewCell.className) as? CrewTableViewCell {
                if let dataSource = crewDataSource {
                    
                    let crewMember = dataSource[indexPath.row]
                    crewMember.profileImage({ (profileImage) -> Void in
                        
                        crewCell.nameLabel.text = crewMember.name
                        crewCell.jobLabel.text = crewMember.job
                        if
                            crewCell.nameLabel.text == crewMember.name,
                            let profileImage = profileImage
                        {
                            crewCell.profileImageView.image = profileImage
                        }
                        else
                        {
                            crewCell.noPhotoLabel.hidden = false
                        }
                    })
                    cell = crewCell
                }
            }
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView: UIView?
        
        switch section {
        case TableSections.CrewSection.rawValue:
            if let simpleHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SimpleHeaderView.className) as? SimpleHeaderView {
                simpleHeaderView.titleLabel.text = "Crew"
                headerView = simpleHeaderView
            }
        case TableSections.CastSection.rawValue:
            if let simpleHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(SimpleHeaderView.className) as? SimpleHeaderView {
                simpleHeaderView.titleLabel.text = "Cast"
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
        case TableSections.HeaderSection.rawValue:
            return 225.0
            
        case TableSections.DetailSection.rawValue:
            return UITableViewAutomaticDimension
            
        case TableSections.CastSection.rawValue:
            return 100.0
            
        case TableSections.CrewSection.rawValue:
            return 100.0
            
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case TableSections.CastSection.rawValue, TableSections.CrewSection.rawValue:
            
            if let view = self.tableView(tableView, viewForHeaderInSection: section) {
                
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
        return false
    }

}
