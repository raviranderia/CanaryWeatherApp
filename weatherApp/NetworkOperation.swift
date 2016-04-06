//
//  NetworkOperation.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation

//class is a reference type

class NetworkOperation {
    
    
    lazy var configuration : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session : NSURLSession = NSURLSession(configuration: self.configuration)
    let queryURL : NSURL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    

    init(url : NSURL) {
        
        self.queryURL = url
    }
    


    
    

    
    func downloadJSONFromURL(completion : JSONDictionaryCompletion?){
        
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                
                switch(httpResponse.statusCode) {
                case 200:
                    
                    do {
                    let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        completion!(jsonDictionary as? [String : AnyObject])
                    }catch {
                        print("error")
                        
                    }
                default : print("GET request not successful. HTTP status code : \(httpResponse.statusCode)")
                    completion!(nil)
                }
                
                
            }else{
                print("Error : Not a valid HTTP Response")
                completion!(nil)
            }
            
        }
        dataTask.resume()
    }

}