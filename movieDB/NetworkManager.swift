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
    static let APIKey = "REPLACEWITHAPIKEY"
    static let sharedNetworkManager = NetworkManager() //Does this even need to be an object?
    static let APIVersion = "3"
    static let posterBaseRoute = "https://image.tmdb.org/t/p/w500"
    static let baseRoute = {
        return "https://api.themoviedb.org/\(APIVersion)"
    }()
    
    func submitJSONRequest(route: String, completion: ((Response<AnyObject, NSError>) -> Void)?) {
        
        self.submitJSONRequest(route, parameters: nil, completion: completion)
    }
    
    func submitJSONRequest(route: String, parameters: Dictionary<String, String>?, completion: ((Response<AnyObject, NSError>) -> Void)?) {
        
        var mutableParameters: Dictionary<String, String> = [:]
        if let parameters = parameters {
           mutableParameters = parameters
        }
        
        mutableParameters.updateValue(NetworkManager.APIKey, forKey: "api_key")
        Alamofire.request(.GET, route, parameters: mutableParameters)
            .responseJSON {response in
                
                if let completion = completion {
                    completion(response)
                }
        }
    }
    
    
    func submitRequest(route: String, completion: ((NSURLRequest?, NSHTTPURLResponse?, AnyObject?) -> Void)?) {
        
        self.submitRequest(route, parameters: nil, completion: completion)
    }
    
    func submitRequest(route: String, parameters: Dictionary<String, String>?, completion: ((NSURLRequest?, NSHTTPURLResponse?, AnyObject?) -> Void)?) {
        
        var mutableParameters: Dictionary<String, String> = [:]
        if let parameters = parameters {
            mutableParameters = parameters
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
