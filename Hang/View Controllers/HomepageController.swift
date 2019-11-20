//
//  HomepageController.swift
//  Hang
//
//  Created by Dominic Egginton on 18/11/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

class HomepageController: UIViewController {
    
    @IBOutlet weak var sessionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup sessionTableView
        sessionTableView.delegate = self
        sessionTableView.dataSource = self
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        print("addBtnClicked")
    }
}

extension HomepageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)
        return cell
    }
    
    
}

