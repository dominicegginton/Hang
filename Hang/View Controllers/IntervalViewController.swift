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
    @IBOutlet weak var actionTableView: UITableView!
    @IBOutlet weak var durationStepper: UIStepper!
    @IBOutlet weak var durationLbl: UILabel!
    
    // Update Interval Delegate
    public var updateIntervalDelagate: UpdateIntervalDelagate?
    
    // Interval ID
    public var intervalId: Int?
    public var interval: Interval?
    
    // Selected Action
    var selectedAction: Action = .hang

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Action Table View
        self.actionTableView.delegate = self
        self.actionTableView.dataSource = self

        // Seup UI
        self.actionTableView.alwaysBounceVertical = false
        self.durationStepper.autorepeat = true
        self.durationStepper.value = 0
        self.durationStepper.maximumValue = 900
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            saveInterval()
        }
    }
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        let interval: Interval = Interval(action: self.selectedAction, duration: Int(sender.value))
        self.durationLbl.text = interval.time
    }
    
    
    // MARK: - Save Interval
    func saveInterval() {
        let duration: Int = Int(self.durationStepper.value)
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
        cell.selectionStyle = .none
        cell.backgroundColor = .secondarySystemBackground
        if indexPath.row == 0 && indexPath.section == 0 {
            cell.backgroundColor = UIColor.systemGreen
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for selection in 0..<self.actionTableView.numberOfSections {
            for row in 0..<self.actionTableView.numberOfRows(inSection: selection) {
                if let cell = self.actionTableView.cellForRow(at: IndexPath(row: row, section: selection)) {
                    cell.selectionStyle = .none
                    cell.backgroundColor = .secondarySystemBackground
                }
            }
        }
        if let actionCell = self.actionTableView.cellForRow(at: indexPath) {
            if let action = Action(rawValue: (actionCell.textLabel!.text!)) {
                actionCell.backgroundColor = action.color
                self.selectedAction = action
            }
        }
    }
    
}
