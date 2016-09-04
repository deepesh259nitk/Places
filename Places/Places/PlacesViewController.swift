//
//  ViewController.swift
//  Places
//
//  Created by ITRMG on 2016-04-09.
//  Copyright © 2016 djrecker. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class PlacesViewController: UITableViewController, CLLocationManagerDelegate {
    
    var places = [placesDataObject]()
    var lat : Double?
    var long : Double?
    
    //for getting current location
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Ask for Authorisation from the User.
        self.locManager.requestAlwaysAuthorization()
        self.locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
            locManager.distanceFilter = 10
        }
        
        self.restAPICall()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Location Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = locValue.latitude
        self.long = locValue.longitude
    }
    
    
    // MARK: TableView Delegate Methods.
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 144.0
        tableView.rowHeight = UITableViewAutomaticDimension
        return 155.0
    }
    
    // MARK: RestAPI Calls.
    func restAPICall(){
        
        RestApiManager.sharedInstance.getPlacesTitle { (json: JSON) in
            
            self.places = []
            
            for places in json["response"]["venues"] {
                
                print(places.1["name"])
                print(places.1["contact"]["phone"])
                self.places.append(placesDataObject(json: places.1))
                
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                //self.tableView.reloadData()
            })
        }
    }

}

