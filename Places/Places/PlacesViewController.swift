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

class PlacesViewController: UITableViewController, CLLocationManagerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var places = [placesDataObject]()
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var lat : Double?
    var long : Double?
    
    //for getting current location
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Near By Places"
        
        configureSearchController()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.allowsSelection = false
        
        // Ask for Authorisation from the User.
        self.locManager.requestAlwaysAuthorization()
        self.locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
            locManager.distanceFilter = 10
        }
        
        //self.restAPICall()
        
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
        return self.places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        let titleLabel = cell.viewWithTag(100) as! UILabel
        titleLabel.text = places[indexPath.row].title
        
        let addressLabel = cell.viewWithTag(103) as! UILabel
        addressLabel.text = places[indexPath.row].address
        
        let cityLabel = cell.viewWithTag(104) as! UILabel
        cityLabel.text =  places[indexPath.row].city
        
        let stateLabel = cell.viewWithTag(105) as! UILabel
        stateLabel.text = places[indexPath.row].state
        
        let milesLabel = cell.viewWithTag(101) as! UILabel
        milesLabel.text = places[indexPath.row].distance
        
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
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: Search Functions
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        self.tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //do whatever with searchController here.
        print("updateSearchResultsForSearchController got called")
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing called")
        self.shouldShowSearchResults = true
        self.tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked called")
        self.shouldShowSearchResults = false
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        print("text entered is \(searchBar.text)")
        
        //first create the url
        
        URLConstants.urlParams = ""
        
        if let searchStr = searchBar.text {
            
            if let lat = self.lat, lng = self.long {
                
                URLConstants.urlParams = "&ll=\(lat),\(lng)&query=\(searchStr)"
            }
            
        }
        
        URLConstants.finalURL = "\(URLConstants.getPlacesURL)\(URLConstants.urlParams)"
        
        self.restAPICall()
        searchController.searchBar.resignFirstResponder()
    }

}

