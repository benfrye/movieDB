//
//  Movie.swift
//  movieDB
//
//  Created by Ben Frye on 8/5/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct Review {
    let author: String
    let content: String
    
    static func processReviewData(JSONData: JSON) -> [Review] {
        
        var reviews = [Review]()
        for (_, subJson) in JSONData["results"] {
            let review = Review(
                author: subJson["author"].stringValue,
                content: subJson["content"].stringValue)
            reviews.append(review)
        }
        return reviews
    }
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
    var cachedSimilarMovies: [Movie]?
    
    init(movieID: Int, title: String, plotDescription: String?, releaseDate: NSDate?, posterPath: String?) {
        
        self.movieID = movieID
        self.title = title
        self.plotDescription = plotDescription
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }
    
    static func processMovieData(JSONData: JSON) -> [Movie] {
        
        var movieArray = [Movie]()
        for (_, subJson) in JSONData["results"] {
            
            if
                let movieID = subJson["id"].int,
                let title = subJson["title"].string
            {
                var releaseDate: NSDate?
                if let dateString = subJson["release_date"].string {
                    releaseDate = NSDateFormatterCache.formatter("yyyy-MM-dd").dateFromString(dateString)
                }
                
                let movie = Movie(
                    movieID: movieID,
                    title: title,
                    plotDescription: subJson["overview"].string,
                    releaseDate: releaseDate,
                    posterPath: subJson["poster_path"].string)
                
                movieArray.append(movie)
            }
        }
        
        return movieArray
    }
    
    func fullyCache(completion: () -> Void) {

        var completionCalled = false
        let cachables: [Any] = [cachedPoster, cachedBackdrop, cachedCrew, cachedCast, cachedReviews, cachedSimilarMovies]
        
        var cached = 0
        poster { (_) -> Void in
            cached++
            if cached == cachables.count && !completionCalled {
                completionCalled = true
                completion()
            }
        }
        
        backdrop { (_) -> Void in
            cached++
            if cached == cachables.count &&  !completionCalled {
                completionCalled = true
                completion()
            }
        }
        
        crew { (_) -> Void in
            cached++
            if cached == cachables.count &&  !completionCalled {
                completionCalled = true
                completion()
            }
        }
        
        cast { (_) -> Void in
            cached++
            if cached == cachables.count &&  !completionCalled {
                completionCalled = true
                completion()
            }
        }
        
        reviews { (_) -> Void in
            cached++
            if cached == cachables.count &&  !completionCalled {
                completionCalled = true
                completion()
            }
        }
        
        similarMovies { (_) -> Void in
            cached++
            if cached == cachables.count &&  !completionCalled {
                completionCalled = true
                completion()
            }
        }
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
    
    private func populateCastAndCrew(completion: () -> Void) {
        
        MovieImporter.sharedInstance.castAndCrewForMovieID(movieID) { (cast, crew) -> Void in
            self.cachedCast = cast
            self.cachedCrew = crew
            completion()
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
            
        }
        else
        {
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
    
    func cacheSpecialCrew(completion: (() -> Void)?) {
        
        crew({ (crewArray) -> Void in
            if let crewArray = crewArray {
                
                var writers = [Crew]()
                for crewMember in crewArray{
                    
                    switch crewMember.job {
                    case "Director":
                        self.cachedDirector = crewMember
                    case "Screenplay":
                        writers.append(crewMember)
                    default:
                        continue
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
    
    func similarMovies(completion: ([Movie]?) -> Void) {
        
        if let cachedSimilarMovies = cachedSimilarMovies {
            
            completion(cachedSimilarMovies)
            
        } else {
            
            MovieImporter.sharedInstance.similarMoviesForMovieID(movieID, completion: { (movies) -> Void in
                self.cachedSimilarMovies = movies
                completion(movies)
            })
        }
    }
    
    //TODO: NEEDS IMPLEMENTATION
    func videos(completion: ([Any]?) -> Void) {
        MovieImporter.sharedInstance.videosForMovieID(movieID) { () -> Void in
            
        }
    }
}