//
//  RestAPIManager.swift
//  Places
//
//  Created by ITRMG on 2016-16-08.
//  Copyright © 2016 djrecker. All rights reserved.
//

import SwiftyJSON

class RestApiManager: NSObject {

    typealias ServiceResponse = (JSON, NSError?) -> Void
    
    static let sharedInstance = RestApiManager()
    
    //MARK: get API Methods
    
    func getPlacesTitle(onCompletion: (JSON) -> Void) {
        
        let route = URLConstants.tempUrl
        print("route now is \(route)")
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    // MARK: Perform a GET Request
    private func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        print(path)
        let request = NSMutableURLRequest(URL: NSURL(string: path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                onCompletion(json, error)
            } else {
                onCompletion(nil, error)
            }
        })
        task.resume()
    }

}