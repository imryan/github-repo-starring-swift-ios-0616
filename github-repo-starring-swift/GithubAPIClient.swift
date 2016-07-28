//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "\(GH_API_URL)/repositories?client_id=\(GH_CLIENT_ID)&client_secret=\(GH_CLIENT_SECRET)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }.resume()
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: (Bool) -> ()) {
        let urlString = "\(GH_API_URL)/user/starred/\(fullName)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "GET"
        request.addValue(GH_TOKEN, forHTTPHeaderField: "Authorization")
        
        session.dataTaskWithRequest(request) { (data, response, error) in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("No-go")
                return
            }
            
            if responseValue.statusCode == 204 {
                completion(true)
            } else {
                completion(false)
            }
            
        }.resume()
    }
    
    class func toggleStarForRepository(repository: GithubRepository, completion: (Bool) -> ()) {
        GithubAPIClient.checkIfRepositoryIsStarred(repository.fullName) { (starred) in
            if starred {
                starRepository(repository.fullName, completion: {
                    completion(true)
                })
            } else {
                unStarRepository(repository.fullName, completion: {
                    completion(false)
                })
            }
        }
    }
    
    class func starRepository(fullName: String, completion: () -> ()) {
        let urlString = "\(GH_API_URL)/user/starred/\(fullName)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "PUT"
        request.addValue(GH_TOKEN, forHTTPHeaderField: "Authorization")
        
        session.dataTaskWithRequest(request) { (data, response, error) in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("No-go")
                return
            }
            
            if responseValue.statusCode == 204 {
                completion()
            }
            
        }.resume()
    }
    
    class func unStarRepository(fullName: String, completion: () -> ()) {
        let urlString = "\(GH_API_URL)/user/starred/\(fullName)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "PUT"
        request.addValue(GH_TOKEN, forHTTPHeaderField: "Authorization")
        
        session.dataTaskWithRequest(request) { (data, response, error) in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("No-go")
                return
            }
            
            if responseValue.statusCode == 204 {
                completion()
            }
            
        }.resume()
    }
}
