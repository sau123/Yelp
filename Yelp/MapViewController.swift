//
//  MapViewController.swift
//  Yelp
//
//  Created by Saumeel Gajera on 7/26/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import Alamofire


class MapViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    var locationManager : CLLocationManager!
    var businesses : [Business]!
    
    var json : JSON? = nil
    
    
    func putAnnotationForAddress(business : Business){
        let parameters : [String:String]? = ["address" : "\(business.address)"]

        Alamofire.request(.GET, "http://maps.google.com/maps/api/geocode/json", parameters: parameters).responseJSON{
            
            response in
            print("response result : ",response.result.value)
            self.json = JSON(response.result.value!)
            let lat = self.json!["results"][0]["geometry"]["location"]["lat"]
            
            let lng = self.json!["results"][0]["geometry"]["location"]["lng"]
            
            print("lat : ",lat)
            print("lng : ",lng)
            if lat.double != nil || lng.double != nil{
            let location2D = CLLocationCoordinate2D(latitude: lat.double!, longitude: lng.double!)
            self.addAnnotationAtCoordinate(location2D, name: business.name!)
            }
            
        }
        
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, name : String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for business in businesses{
            putAnnotationForAddress(business)
        }
        
        

        // manager ground work
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200 // the minimum the distance must move, before an update event is generated.
        locationManager.requestWhenInUseAuthorization()
        
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(centerLocation)                            // center around that location.

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
