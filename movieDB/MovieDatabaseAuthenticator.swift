//
//  MovieDatabaseAuthenticator.swift
//  movieDB
//
//  Created by Ben Frye on 8/5/15.
//  Copyright (c) 2015 benhamine. All rights reserved.
//

import UIKit
import SwiftyJSON

struct AuthenticationToken {
    let requestToken: String
    let expirationDate: NSDate
}

class MovieDatabaseAuthenticator {
    
    static let sharedAuthenticator = MovieDatabaseAuthenticator()
    static var sessionID : String?
    
    private func authenticate(completion: (AuthenticationToken) -> Void) {

        let authenticationRoute = "\(NetworkManager.baseRoute)/authentication/token/new"
        NetworkManager.sharedNetworkManager.submitJSONRequest(authenticationRoute, completion: { (response) -> Void in
            
            if let data = response.result.value {
                
                let JSONData = JSON(data)
                if let requestToken = JSONData["request_token"].string,
                    let expirationDateString = JSONData["expires_at"].string,
                    let expirationDate = NSDateFormatterCache.formatter("yyyy-MM-dd HH:mm:ss zzz").dateFromString(expirationDateString) {

                        completion(AuthenticationToken(requestToken: requestToken, expirationDate: expirationDate))
                }
            }
        })
    }
    
    private func createSession(authenticationToken: AuthenticationToken) {
        
        let sessionRoute = "\(NetworkManager.baseRoute)/authentication/session/new"
        let parameters = [ "request_token": authenticationToken.requestToken ]
        NetworkManager.sharedNetworkManager.submitJSONRequest(sessionRoute, parameters: parameters) { (response) -> Void in
            if let data = response.result.value,
               let session_id = data["session_id"] as? String {
                
                MovieDatabaseAuthenticator.sessionID = session_id
            }
        }
    }
    
    func validateLogin(username: String, password: String, completion: (success: Bool) -> Void) {

        self.authenticate { (token) -> Void in
            
            let validationRoute = "\(NetworkManager.baseRoute)/authentication/token/validate_with_login"
            let parameters = [
                "request_token": token.requestToken,
                "username": username,
                "password": password,
                ]
            NetworkManager.sharedNetworkManager.submitJSONRequest(validationRoute, parameters: parameters, completion: { (response) -> Void in
                
                guard
                    let data = response.result.value,
                    let success = data["success"] as? Int
                else {
                    print("Error validating login", separator: "", terminator: "")
                    completion(success: false)
                    return
                }
                
                if success == 1 {
                    self.createSession(token)
                    completion(success: true)
                } else {
                    completion(success: false)
                }
            })
        }
    }
   
}
