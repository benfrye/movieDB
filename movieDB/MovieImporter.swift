//
//  MovieImporter.swift
//  movieDB
//
//  Created by Ben Frye on 8/4/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

import UIKit
import SwiftyJSON

class MovieImporter {
    
    static let sharedInstance = MovieImporter()
    
    var dateFormatter = NSDateFormatter()
    
    init() {
        
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func processMovieData(JSONData: JSON) -> [Movie] {
        
        var movieArray: [Movie] = []
        for (_, subJson) in JSONData["results"] {
            
            if
                let movieID = subJson["id"].int,
                let title = subJson["title"].string
            {
                    var releaseDate: NSDate?
                    if let dateString = subJson["release_date"].string {
                        releaseDate = self.dateFormatter.dateFromString(dateString)
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
    
    func processCastData(JSONData: JSON) -> [Cast]? {
        
        var cast : [Cast]?
        if JSONData["cast"].count > 0 {
            
            cast = []
            for (_, subJson) in JSONData["cast"] {
                
                let castMember = Cast(
                    id: subJson["id"].intValue,
                    name: subJson["name"].stringValue,
                    profilePath: subJson["profile_path"].stringValue,
                    order: subJson["order"].intValue,
                    characterName: subJson["character"].stringValue)
                cast?.append(castMember)
            }
        }
        return cast
    }
    
    func processCrewData(JSONData: JSON) -> [Crew]? {
        
        var crew: [Crew]?
        if JSONData["crew"].count > 0 {
            
            crew = []
            for (_, subJson) in JSONData["crew"] {
                let crewMember = Crew(
                    id: subJson["id"].intValue,
                    name: subJson["name"].stringValue,
                    profilePath: subJson["profile_path"].stringValue,
                    job: subJson["job"].stringValue,
                    department: subJson["department"].stringValue)
                crew?.append(crewMember)
            }
        }
        return crew
    }
    
    func processReviewData(JSONData: JSON) -> [Review]? {
        
        var reviews = [Review]()
        for (_, subJson) in JSONData["results"] {
            let review = Review(
                author: subJson["author"].stringValue,
                content: subJson["content"].stringValue)
            reviews.append(review)
        }
        return reviews
    }
    
    func submitMovieRequest(searchRoute: String, completion: ([Movie]) -> Void) {
        
        NetworkManager.sharedNetworkManager.submitJSONRequest(searchRoute) { (response) -> Void in
            
            if let data = response.result.value {
                
                let JSONData = JSON(data)
                let movieArray = self.processMovieData(JSONData)
                completion(movieArray)
                
            } else {
                completion([Movie]())
            }
        }
    }
    
    func popularFilms(completion: ([Movie]) -> Void) {
        let searchRoute = "\(NetworkManager.baseRoute)/movie/popular"
        submitMovieRequest(searchRoute, completion: completion)
    }
    
    func comingSoon(completion: ([Movie]) -> Void) {
        
        let searchRoute = "\(NetworkManager.baseRoute)/movie/upcoming"
        submitMovieRequest(searchRoute, completion: completion)
    }
    
    func newReleases(completion: ([Movie]) -> Void) {
        
        let searchRoute = "\(NetworkManager.baseRoute)/movie/now_playing"
        submitMovieRequest(searchRoute, completion: completion)
    }
    
    func similarMoviesForMovieID(movieID: Int, completion: ([Movie]) -> Void) {
        
        let searchRoute = "\(NetworkManager.baseRoute)/movie/\(movieID)/similar"
        submitMovieRequest(searchRoute, completion: completion)
    }
    
    func searchTitle(title: String, completion: ([Movie]) -> Void) {
        
        let searchRoute = "\(NetworkManager.baseRoute)/search/movie"
        let parameters = ["query": title]
        NetworkManager.sharedNetworkManager.submitJSONRequest(searchRoute, parameters: parameters) { (response) -> Void in
            
            if let data = response.result.value {
                
                let JSONData = JSON(data)
                let movieArray = self.processMovieData(JSONData)
                completion(movieArray)
                
            } else {
                completion([Movie]())
            }
        }
    }
    
    func imageForPath(imagePath: String, completion: (UIImage?) -> Void) {
        
        let searchRoute = "\(NetworkManager.posterBaseRoute)\(imagePath)"
        NetworkManager.sharedNetworkManager.submitRequest(searchRoute, completion: { (_, _, data) -> Void in
            if let data = data as? NSData {
                completion(UIImage(data: data, scale: 1.0))
            } else {
                completion(nil)
            }
        })
    }
    
    func backdropForMovieID(movieID: Int, completion: (UIImage?) -> Void) {
        
        let searchRoute = "\(NetworkManager.baseRoute)/movie/\(movieID)/images"
        NetworkManager.sharedNetworkManager.submitJSONRequest(searchRoute) { (response) -> Void in
            
            if
                let data = response.result.value,
                let backdrops = data["backdrops"] as? [NSDictionary] where backdrops.count > 0,
                let backdropURL = backdrops[0]["file_path"] as? String
            {
                self.imageForPath(backdropURL, completion: completion)
            }
            else
            {
                completion(nil)
            }
        }
    }
    
    func castAndCrewForMovieID(movieID: Int, completion: (cast: [Cast]?, crew: [Crew]?) -> Void) {
        let searchRoute = "\(NetworkManager.baseRoute)/movie/\(movieID)/credits"
        NetworkManager.sharedNetworkManager.submitJSONRequest(searchRoute) { (response) -> Void in
            
            if let data = response.result.value {
                let JSONData = JSON(data)
                let cast = self.processCastData(JSONData)
                let crew = self.processCrewData(JSONData)
                
                completion(cast: cast, crew: crew)
                
            } else {
                completion(cast: nil, crew: nil)
            }
        }
    }
    
    func reviewsForMovieID(movieID: Int, completion: ([Review]?) -> Void) {
        
        let searchRoute = "\(NetworkManager.baseRoute)/movie/\(movieID)/reviews"
        NetworkManager.sharedNetworkManager.submitJSONRequest(searchRoute) { (response) -> Void in
            
            if let data = response.result.value {
                
                let JSONData = JSON(data)
                let reviews = self.processReviewData(JSONData)
                completion(reviews)
                
            } else {
                
                completion(nil)
            }
        }
    }
    
    //TODO: NEEDS IMPLEMENTATION
    func videosForMovieID(movieID: Int, completion: () -> Void) {
        
        let searchRoute = "\(NetworkManager.baseRoute)/movie/\(movieID)/videos"
        NetworkManager.sharedNetworkManager.submitJSONRequest(searchRoute) { (response) -> Void in
            
            if let data = response.result.value {
                
                let JSONData = JSON(data)
                print(JSONData, separator: "", terminator: "")
            }
        }
    }
}
