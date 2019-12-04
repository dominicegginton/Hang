//
//  IntervalViewController.swift
//  Hang
//
//  Created by Dominic Egginton on 03/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

protocol UpdateIntervalDelagate {
    func updateInterval(with interval: Interval, at index: Int)
}

class IntervalViewController: UIViewController {
    
    // UI Outlets
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var actionTableView: UITableView!
    @IBOutlet weak var durationTxtBox: UITextField!
    
    // Update Interval Delegate
    public var updateIntervalDelagate: UpdateIntervalDelagate?
    
    // Interval ID
    public var intervalId: Int?
    public var interval: Interval?
    
    // Selected Action
    var selectedAction: Action?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Action Table View
        self.actionTableView.delegate = self
        self.actionTableView.dataSource = self

        // Seup UI
        self.durationLbl.layer.masksToBounds = true
        self.durationLbl.layer.cornerRadius = 5
        self.actionTableView.alwaysBounceVertical = false
        
        if intervalId != nil {
            if let interval = self.interval {
                self.durationTxtBox.text = "\(interval.duration)"
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            saveInterval()
        }
    }
    
    // MARK: - Save Interval
    func saveInterval() {
        let duration: Int = Int(self.durationTxtBox.text!) ?? 0
        
        let interval: Interval = Interval(action: self.selectedAction, duration: duration)
        if let id = self.intervalId {
            self.updateIntervalDelagate?.updateInterval(with: interval, at: id)
        }
    }
}

extension IntervalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Action.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.actionTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath)
        cell.textLabel?.text = Action.allCases[indexPath.row].rawValue
        self.actionTableView.heightAnchor.constraint(equalToConstant: self.actionTableView.contentSize.height).isActive = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for selection in 0..<self.actionTableView.numberOfSections {
            for row in 0..<self.actionTableView.numberOfRows(inSection: selection) {
                let cell = self.actionTableView.cellForRow(at: IndexPath(row: row, section: selection))
                cell!.accessoryType = .none
                cell?.selectionStyle = .none
            }
        }
        let actionCell = self.actionTableView.cellForRow(at: indexPath)
        actionCell?.accessoryType = .checkmark
        self.selectedAction = Action(rawValue: (actionCell?.textLabel!.text)!)
        self.title = actionCell?.textLabel!.text
    }
    
}
