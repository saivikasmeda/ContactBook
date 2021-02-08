//
//  HomeTableViewCell.swift
//  DB_Project
//
//  Created by Student on 3/20/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

// This class creates the objects for each  row in hometableview contrller
class HomeTableViewCell: UITableViewCell {

    // UIcomponents objects of hometableviewcontroller
    @IBOutlet weak var imageLabelOutlet: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var NameOutlet: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageOutlet.layer.masksToBounds = true
        imageOutlet.layer.cornerRadius = imageOutlet.bounds.width/2
        imageOutlet.backgroundColor = UIColor.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
