//
//  TopRatedTableViewCell.swift
//  Movies
//
//  Created by Maha Govindarajan on 2/7/16.
//  Copyright © 2016 Maha Govindarajan. All rights reserved.
//

import UIKit

class TopRatedTableViewCell: UITableViewCell {

    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
