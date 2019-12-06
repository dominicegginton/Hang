//
//  SettingsViewController.swift
//  Hang
//
//  Created by Dominic Egginton on 06/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openInfo(_ sender: Any) {
        let url = URL(string: "https://www.climbing.com/skills/copy-of-tech-tips-contact-2/")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true)
    }
    

}
