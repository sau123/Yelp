//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit



class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FilterViewControllerDelegate {
    
    var filteredData: [String]!
    var searchBar :UISearchBar!
    
    var searchTerm : String? = ""
    
    var sortMode : YelpSortMode? = .HighestRated
    var distanceMode : YelpDistanceMode? = .Twenty
    var categories : [String]? = []
    var deals : Bool? = false
    var businessDetailedView : Business?
    
//    var preferences: Preferences = Preferences() {
//        didSet {
//            Business.searchWithTerm(searchTerm!, distance: distanceMode, sort: sortMode, categories: categories, deals: deals) { (businesses: [Business]!, error: NSError!) -> Void in
//                self.businesses = businesses
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        self.searchBar.showsSearchResultsButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.translucent = false
        
        //        tableView.tableHeaderView = searchBar
        navigationItem.titleView = searchBar
        definesPresentationContext = true
        //        searchBar.showsCancelButton = true
        
        
//        Business.searchWithTerm(searchTerm!, completion: { (businesses: [Business]!, error: NSError!) -> Void in
//            
//            self.businesses = businesses
//            self.tableView.reloadData()
//            
//            for business in businesses {
//                print()
//                print(business.name!)
//                print(business.address!)
//                print(business.distance!)
//            }
//        })

        Business.searchWithTerm(searchTerm!, distance: distanceMode, sort: sortMode, categories: categories, deals: deals) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("cancel button clicked ")
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        print("entered search bar search button clicked")
        searchTerm = searchBar.text!
        if searchTerm != nil{
            Business.searchWithTerm(searchTerm!, distance: distanceMode, sort: sortMode, categories: categories, deals: deals) { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil{
            return businesses.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        
        businessDetailedView = cell.business
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "filtersSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.delegate = self
        }
        else if segue.identifier == "detailsSegue"{
            print("preparing for details page view controller !")
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailsViewController = navigationController.topViewController as! DetailsViewController
            let cell = sender as! BusinessCell!
            let indexPath = tableView.indexPathForCell(cell)
            businessDetailedView = businesses![indexPath!.row]

            detailsViewController.business = businessDetailedView
        }
        else if segue.identifier == "mapSegue" {
            print("preparing map view controller!")
            let navigationController = segue.destinationViewController as! UINavigationController
            let detailsViewController = navigationController.topViewController as! MapViewController
            
            detailsViewController.businesses = self.businesses
            
        }
//        filtersViewController.currentPrefs = self.preferences
//        self.preferences = filtersViewController.preferencesFromTableData()
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let sort = filters["sort"] as? Int
        let distance = filters["distance"] as? Int
        
        categories = filters["categories"] as? [String]
        deals = filters["deals"] as? Bool
        print("in did update, businessviewcontrlr deals :",deals!)
        
        switch sort! {
        case 0 :
            sortMode = YelpSortMode.BestMatched
        case 1 :
            sortMode = YelpSortMode.Distance
        case 2 :
            sortMode = YelpSortMode.HighestRated
        default :
            sortMode = YelpSortMode.BestMatched
        }
        
        switch distance! {
        case 0:
            distanceMode = YelpDistanceMode.PointThree
        case 1 :
            distanceMode = YelpDistanceMode.One
        case 2 :
            distanceMode = YelpDistanceMode.Five
        case 3 :
            distanceMode = YelpDistanceMode.Twenty
        default :
            distanceMode = YelpDistanceMode.PointThree
        }
        
        
        Business.searchWithTerm(searchTerm!, distance: distanceMode, sort: sortMode, categories: categories, deals: deals!){
            (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        
    }
    
    
}
