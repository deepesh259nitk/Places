//
//  placesDataObject.swift
//  Places
//
//  Created by ITRMG on 2016-16-08.
//  Copyright © 2016 djrecker. All rights reserved.
//

import Foundation
import SwiftyJSON

class placesDataObject {
    
    var title: String!
    var phone : String!
    var formattedPhone : String!
    var address : String!
    var lat : Double?
    var long : Double?
    var postalCode : String!
    var city : String!
    var state : String!
    var distance : String!

    
    required init(json: JSON) {
        
        title = json["name"].stringValue
        phone = json["contact"]["phone"].stringValue
        formattedPhone = json["contact"]["formattedPhone"].stringValue
        address = json["location"]["address"].stringValue
        lat = json["location"]["lat"].doubleValue
        long = json["location"]["lng"].doubleValue
        postalCode = json["location"]["postalCode"].stringValue
        city = json["location"]["city"].stringValue
        state = json["location"]["state"].stringValue
        
        // NOTE :- For below conversion it is assumed that FourSquare API are returning back distance in mts. which is then converted to miles.
        
        distance = String(format:"%0.2f miles", json["location"]["distance"].doubleValue * 0.000621371)

    }
}