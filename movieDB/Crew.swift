//
//  Crew.swift
//  movieDB
//
//  Created by Ben Frye on 8/10/15.
//  Copyright © 2015 benhamine. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Member {
    let id: Int
    let name: String
    let profilePath: String?
    var cachedProfileImage: UIImage?
    
    init (id: Int, name: String, profilePath: String?) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
    }
    
    func profileImage(completion: (UIImage?) -> Void ) {
        
        if let profileImage = cachedProfileImage {
            
            completion(profileImage)
            
        } else if let profilePath = profilePath {
            
            MovieImporter.sharedInstance.imageForPath(profilePath, completion: { (profileImage) -> Void in
                
                self.cachedProfileImage = profileImage
                completion(profileImage)
            })
            
        } else {
            
            completion(nil)
            
        }
    }
}

class Crew:Member {
    let job: String
    let department: String
    
    init (id: Int, name: String, profilePath: String?, job: String, department: String) {
        
        self.job = job
        self.department = department
        
        super.init(id: id, name: name, profilePath: profilePath)
    }
    
    static func processCrewData(JSONData: JSON) -> [Crew] {
        
        var crew = [Crew]()
        if JSONData["crew"].count > 0 {
            
            for (_, subJson) in JSONData["crew"] {
                let crewMember = Crew(
                    id: subJson["id"].intValue,
                    name: subJson["name"].stringValue,
                    profilePath: subJson["profile_path"].stringValue,
                    job: subJson["job"].stringValue,
                    department: subJson["department"].stringValue)
                crew.append(crewMember)
            }
        }
        return crew
    }
}

class Cast:Member {
    let order: Int
    let characterName: String?
    
    init (id: Int, name: String, profilePath: String?, order: Int, characterName: String?) {
        
        self.order = order
        self.characterName = characterName
        
        super.init(id: id, name: name, profilePath: profilePath)
    }
    
    static func processCastData(JSONData: JSON) -> [Cast] {
        
        var cast = [Cast]()
        if JSONData["cast"].count > 0 {
            
            for (_, subJson) in JSONData["cast"] {
                
                let castMember = Cast(
                    id: subJson["id"].intValue,
                    name: subJson["name"].stringValue,
                    profilePath: subJson["profile_path"].stringValue,
                    order: subJson["order"].intValue,
                    characterName: subJson["character"].stringValue)
                cast.append(castMember)
            }
        }
        return cast
    }
}