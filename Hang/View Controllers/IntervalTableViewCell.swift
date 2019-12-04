//
//  ActivityTableViewCell.swift
//  Hang
//
//  Created by Dominic Egginton on 02/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

class IntervalTableViewCell: UITableViewCell {
    
    // UI Outlets
    @IBOutlet weak var actionLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Setup UI
        self.durationLbl.layer.masksToBounds = true
        self.durationLbl.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureCell(interval: Interval) {
        self.actionLbl.text = "\(String(describing: interval.action))"
        self.durationLbl.text = "\(interval.duration)"
    }
    
}
