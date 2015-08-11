//
//  NetworkManager.swift
//  movieDB
//
//  Created by Ben Frye on 8/4/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager
{
    static let sharedNetworkManager = NetworkManager()
    static let APIKey = "REPLACEWITHAPIKEY"
    static let APIVersion = "3"
    static let posterBaseRoute = "https://image.tmdb.org/t/p/w500"
    static let baseRoute = {
        return "https://api.themoviedb.org/\(APIVersion)"
    }()
    
    func submitJSONRequest(route: String, completion: ((NSURLRequest?, NSHTTPURLResponse?, Result<AnyObject>) -> Void)?) {
        
        self.submitJSONRequest(route, parameters: nil, completion: completion)
    }
    
    func submitJSONRequest(route: String, parameters: Dictionary<String, String>?, completion: ((NSURLRequest?, NSHTTPURLResponse?, Result<AnyObject>) -> Void)?) {
        
        var mutableParameters: Dictionary<String, String> = [:]
        if parameters != nil
        {
           mutableParameters = parameters!
        }
        
        mutableParameters.updateValue(NetworkManager.APIKey, forKey: "api_key")
        Alamofire.request(.GET, route, parameters: mutableParameters)
            .responseJSON {request, response, data in
                
                if let completion = completion {
                    completion(request, response, data)
                }
        }
    }
    
    
    func submitRequest(route: String, completion: ((NSURLRequest?, NSHTTPURLResponse?, AnyObject?) -> Void)?) {
        
        self.submitRequest(route, parameters: nil, completion: completion)
    }
    
    func submitRequest(route: String, parameters: Dictionary<String, String>?, completion: ((NSURLRequest?, NSHTTPURLResponse?, AnyObject?) -> Void)?) {
        
        var mutableParameters: Dictionary<String, String> = [:]
        if parameters != nil
        {
            mutableParameters = parameters!
        }
        
        mutableParameters.updateValue(NetworkManager.APIKey, forKey: "api_key")
        Alamofire.request(.GET, route, parameters: mutableParameters)
            .response {request, response, data, error in
                
                if let completion = completion {
                    completion(request, response, data)
                }
        }
    }
}
