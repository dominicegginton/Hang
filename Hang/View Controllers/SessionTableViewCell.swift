//
//  SessionTableViewCell.swift
//  Hang
//
//  Created by Dominic Egginton on 20/11/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {
    
    public var session: Session?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // UI Setup
        self.totalDurationLabel.layer.masksToBounds = true
        self.totalDurationLabel.layer.cornerRadius = 5
        if let session = self.session {
            self.nameLabel.text = session.name
            self.totalDurationLabel.text = "\(session.totalDuration)"
        }
    }
    
    public func configureCell(session: Session) {
        self.nameLabel.text = session.name
        self.totalDurationLabel.text = session.time
        self.nameLabel.accessibilityIdentifier = "sessionLbl"
        self.totalDurationLabel.accessibilityIdentifier = "totalDurationLbl"
    }
    
}
