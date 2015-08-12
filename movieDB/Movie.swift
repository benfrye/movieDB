//
//  Movie.swift
//  movieDB
//
//  Created by Ben Frye on 8/5/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

import Foundation
import UIKit

struct Review {
    let author: String
    let content: String
}

class Movie: NSObject {
    
    let movieID: Int
    let title: String
    let plotDescription: String?
    let releaseDate: NSDate?
    let posterPath: String?
    var cachedPoster: UIImage?
    var cachedBackdrop: UIImage?
    var cachedCrew: [Crew]?
    var cachedCast: [Cast]?
    var cachedDirector: Crew?
    var cachedWriters: [Crew]?
    var cachedReviews: [Review]?
    
    init(movieID: Int, title: String, plotDescription: String?, releaseDate: NSDate?, posterPath: String?) {
        
        self.movieID = movieID
        self.title = title
        self.plotDescription = plotDescription
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }
    
    func poster(completion: (UIImage?) -> Void) {
        
        if let posterImage = cachedPoster {
            
            completion(posterImage)
            
        } else if let posterPath = posterPath {
            
            MovieImporter.sharedInstance.imageForPath(posterPath, completion: { (posterImage) -> Void in
                
                self.cachedPoster = posterImage
                completion(posterImage)
            })
            
        } else {
            
            completion(nil)
        }
    }
    
    func backdrop(completion: (UIImage?) -> Void) {
        
        if let backdropImage = cachedBackdrop {
            
            completion(backdropImage)
            
        } else {
            
            MovieImporter.sharedInstance.backdropForMovieID(movieID, completion: { (backdropImage) -> Void in
                
                self.cachedBackdrop = backdropImage
                completion(backdropImage)
            })
        }
    }
    
    func populateCastAndCrew(completion: () -> Void) {
        
        MovieImporter.sharedInstance.castAndCrewForMovieID(movieID) { (cast, crew) -> Void in
            self.cachedCast = cast
            self.cachedCrew = crew
            completion()
        }
    }
    
    func crew(completion: ([Crew]?) -> Void) {
        
        if let cachedCrew = cachedCrew {
            completion(cachedCrew)
        } else {
            populateCastAndCrew({ () -> Void in
                self.cacheSpecialCrew(nil)
                completion(self.cachedCrew)
            })
        }
    }
    
    func specialCrew(completion: ([Crew]?) -> Void) {
        
        if
            let cachedDirector = cachedDirector,
            let cachedWriters = cachedWriters
        {
            var specialCrew = [cachedDirector]
            specialCrew += cachedWriters
            completion(specialCrew)
        } else {
            cacheSpecialCrew({ () -> Void in
                if
                    let cachedDirector = self.cachedDirector,
                    let cachedWriters = self.cachedWriters
                {
                    var specialCrew = [cachedDirector]
                    specialCrew += cachedWriters
                    completion(specialCrew)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    func cast(completion: ([Cast]?) -> Void) {
        
        if let cachedCast = cachedCast {
            completion(cachedCast)
        } else {
            populateCastAndCrew({ () -> Void in
                completion(self.cachedCast)
            })
        }
    }
    
    func cacheSpecialCrew(completion: (() -> Void)?) {
        
        crew({ (crewArray) -> Void in
            if let crewArray = crewArray {
                
                var writers = [Crew]()
                for crewMember in crewArray{
                    
                    if crewMember.job == "Director" {
                        self.cachedDirector = crewMember
                    } else if crewMember.job == "Screenplay" {
                        writers.append(crewMember)
                    }
                    
                }
                self.cachedWriters = writers
                if let completion = completion {
                    completion()
                }
            }
        })
    }
    
    func reviews(completion: ([Review]?) -> Void) {
        
        if let cachedReviews = cachedReviews {
            
            completion(cachedReviews)
            
        } else {

            MovieImporter.sharedInstance.reviewsForMovieID(movieID) { (reviews) -> Void in
                self.cachedReviews = reviews
                completion(reviews)
            }
        }
    }
}