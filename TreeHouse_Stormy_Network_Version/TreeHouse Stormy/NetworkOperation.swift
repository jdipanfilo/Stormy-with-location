//
//  NetworkOperation.swift
//  TreeHouse Stormy
//
//  Created by John DiPanfilo on 8/9/15.
//  Copyright (c) 2015 bc9000. All rights reserved.
//

import Foundation

class NetworkOperation {
    //Lazy var allow more control over init and memory management
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryUrl: NSURL
    
    typealias JSONDictionaryCompletion = ([String : AnyObject]?) -> Void

    init (url: NSURL) {
        self.queryUrl = url
    }
    
    func downloadJSONFromUrl (completion: JSONDictionaryCompletion) {
        let request = NSURLRequest(URL: queryUrl)
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            //1.Check HTTP response for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                switch (httpResponse.statusCode) {
                case 200:
                    //2. Create JSON object with data
                    let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject]
                    completion(jsonDictionary)
                default:
                    println("Get request was not successful. HTTP Status code \(httpResponse.statusCode)")
                }
                
            } else {
                println("Error: Not a valid HTTP response.")
            }
            
            
        }
        dataTask.resume()
    }

}