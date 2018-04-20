//
//  BusStopTableViewCell.swift
//  BusCatcher
//
//  Created by Akshay Ayyanchira on 4/20/18.
//  Copyright © 2018 Akshay Ayyanchira. All rights reserved.
//

import UIKit

class BusStopTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var busStopNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
