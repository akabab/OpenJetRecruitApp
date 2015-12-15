//
//  HTTP.swift
//  OpenJetRecruitApp
//
//  Created by Yoann Cribier on 15/12/15.
//  Copyright © 2015 Yoann Cribier. All rights reserved.
//

import Foundation

class HTTP {
    
    class func sendRequest(request: NSMutableURLRequest, callback: (data: String, response: NSURLResponse?, error: String?) -> Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                callback(data: "", response: nil, error: (error!.localizedDescription) as String)
                return
            }
            
            if let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                callback(data: dataString as String, response: response, error: nil)
            }
            
        })
        
        task.resume()
    }
    
    class func formatGetRequest(url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        return request
    }
    
    class func formatPostRequest(url: String, params: [String:String]?) -> NSMutableURLRequest {
        
        func dictionaryToQueryString(dict: [String : String]) -> String {
            var parts = [String]()
            for (key, value) in dict {
                let part: String = key + "=" + value
                parts.append(part);
            }
            return parts.joinWithSeparator("&")
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        if params != nil {
            let paramsString = dictionaryToQueryString(params!)
            request.HTTPBody = paramsString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        }
        
        return request
    }
    
}