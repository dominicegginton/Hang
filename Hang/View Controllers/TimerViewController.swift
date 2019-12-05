//
//  TimerController.swift
//  Hang
//
//  Created by Dominic Egginton on 02/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    // UI Outles
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var timerControlBtn: UIBarButtonItem!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var intervalTableView: UITableView!
    
    // Session ID
    public var sessionId: Int?
    public var intervals: [Interval] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = sessionId {
            do {
                let session = try Sessions.instance.getSession(atIndex: id)
                self.intervals = session.intervals
            } catch {
                print(">>> error loading session")
            }
        }
        
        // Interval tableView Deleagte and Data Source
        self.intervalTableView.delegate = self
        self.intervalTableView.dataSource = self
        self.intervalTableView.allowsSelection = false
        self.intervalTableView.reloadData()
        
        // Setup UI
        self.title = "00:00"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.intervals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("IntervalTableViewCell", owner: self, options: nil)?.first as! IntervalTableViewCell
        // Configure the cell...
        let interval = self.intervals[indexPath.row]
        cell.configureCell(interval: interval)
        return cell
    }
}
