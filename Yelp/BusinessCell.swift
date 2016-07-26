//
//  BusinessCell.swift
//  Yelp
//
//  Created by Saumeel Gajera on 7/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var reviewsImageLabel: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var business : Business! {
        didSet{
            nameLabel.text = business.name
            thumbImageView.setImageWithURL(business.imageURL!)
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            distanceLabel.text = business.distance
            reviewsImageLabel.setImageWithURL(business.ratingImageURL!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
