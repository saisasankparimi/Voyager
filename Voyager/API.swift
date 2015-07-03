//
//  API.swift
//  Voyager
//
//  Created by Sai Sasank Parimi on 6/14/15.
//  Copyright (c) 2015 Sasank. All rights reserved.
//

import Foundation


class API {
    
    
    
    
    class func getData(url : NSURL, postCompleted : (succeeded: Bool, msg: NSDictionary) -> ()) {
        
        
       
        
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        
        let session = NSURLSession.sharedSession()
        var err: NSError?
        
        var task = session.dataTaskWithRequest(request, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            
            var json : AnyObject?
            var jsonObject = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            
            var jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSArray
            
            if jsonObject == nil{
                
                json = jsonArray
                
            }else{
                
                json = jsonObject
            }
            
            
            var msg = "No message"
            
            // if error show a alert
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                postCompleted(succeeded: false, msg:["value": NSLocalizedString("errorConnectionMessage", comment: "error message for the alert")])
                
            }
                // if success
            else {
                
                if let parseJSON: AnyObject = json {
                    
                    postCompleted(succeeded: true, msg:["value": parseJSON])
                    
                }
                
                
            }
        })
        
        task.resume()
    }

}
