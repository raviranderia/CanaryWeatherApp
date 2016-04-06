//
//  ForecastCollectionViewCell.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var iconImageOutlet: UIImageView!
    @IBOutlet var dayLabelOutlet: UILabel!
    @IBOutlet var summaryLabelOutlet: UILabel!
    @IBOutlet var minMaxTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        self.contentView.bounds = containerView.bounds
        self.summaryLabelOutlet.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.summaryLabelOutlet.autoresizingMask = UIViewAutoresizing.FlexibleWidth
    }
    
}
