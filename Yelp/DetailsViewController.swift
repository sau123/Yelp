//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Saumeel Gajera on 7/25/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var detailedImageView: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantDistance: UILabel!
    @IBOutlet weak var isClosedImage: UIImageView!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantCategories: UILabel!
    @IBOutlet weak var restaurantDescription: UILabel!
    
    var business : Business!
    
    override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
//        restaurantName.text = business.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantName.text = business.name
        restaurantAddress.text = business.address
        restaurantDistance.text = business.distance
        restaurantCategories.text = business.categories
        detailedImageView.setImageWithURL(business.imageURL!)
        restaurantDescription.text = business.descriptn
        
        let isClosedVal = business.isClosed!
        print("isclosed val : ",isClosedVal)
        if isClosedVal == false  {
            isClosedImage.setImageWithURL(NSURL(string: "https://image.freepik.com/free-icon/close-sign-for-door_318-60021.png")!)
        }else{
            isClosedImage.setImageWithURL(NSURL(string: "http://downloadicons.net/sites/default/files/shops-open-icon-65322.png")!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
