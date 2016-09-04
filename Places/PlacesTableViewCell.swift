//
//  PlacesTableViewCell.swift
//  Places
//
//  Created by ITRMG on 2016-04-09.
//  Copyright © 2016 djrecker. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placesName: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var webSiteBtn: UIButton!
   
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func locationBtnTapped(sender: AnyObject) {
        
        print("location button tag \(sender.tag)")
        
    }
    
    @IBAction func webBtnTapped(sender: AnyObject) {
        
        print("web button tag \(sender.tag)")
    }
    
    @IBAction func callBtnTapped(sender: AnyObject) {
        
        print("call button tag \(sender.tag)")
    }

}
