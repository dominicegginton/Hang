//
//  SessionController.swift
//  Hang
//
//  Created by Dominic Egginton on 02/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

protocol UpdateSessionDelagate {
    func updateSession(with note: Session, at index: Int)
}

class SessionViewController: UIViewController, UITextFieldDelegate, UpdateIntervalDelagate {
    
    // Update Session Delegate
    var updateSessionDelegate: UpdateSessionDelagate?
    
    // UI Outlets
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    @IBOutlet weak var sessionNameTxtBox: UITextField!
    @IBOutlet weak var intervalTableView: UITableView!
    
    // Session ID
    public var sessionId: Int?
    
    // Intervals
    public var intervals: [Interval] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id: Int = sessionId {
            if let session: Session = try? Sessions.instance.getSession(atIndex: id) {
                self.intervals = session.intervals
                self.sessionNameTxtBox.text = session.name
            }
        }
        
        // Setup UI
        self.doneBtn.isEnabled = false
        self.sessionNameTxtBox.delegate = self
        
        // Interval Table View Delegates
        self.intervalTableView.delegate = self
        self.intervalTableView.dataSource = self
        self.intervalTableView.reloadData()
        
        // Notification Observers for keyabord show and hide
        NotificationCenter.default.addObserver(self, selector: #selector(keybaordWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybaordWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            saveSession()
        }
    }
    
    // MARK: - Save Session
    func saveSession() {
        var sessionName = self.sessionNameTxtBox.text ?? "New Session"
        let sessionIntervals = self.intervals
        if sessionName == "" {
            sessionName = "New Session"
        }
        self.title = sessionName
        let session = Session(name: sessionName, intervals: sessionIntervals)
        if let id = self.sessionId {
            self.updateSessionDelegate?.updateSession(with: session, at: id)
        }
    }
    
    // MARK: - Keybaord
    func textFieldDidEndEditing(_ textField: UITextField) {
        // did finish editing
    }
    
    @objc func keybaordWillShow(_ notification: NSNotification) {
        print("showing keybaord")
        self.doneBtn.isEnabled = !self.doneBtn.isEnabled
    }
    
    @objc func keybaordWillHide(_ notification: NSNotification) {
        self.doneBtn.isEnabled = !self.doneBtn.isEnabled
    }
    
    @IBAction func dismissKeybaord(_ sender: UIBarButtonItem) {
        self.sessionNameTxtBox.resignFirstResponder()
    }
    
    // MARK: - Add Interval
    @IBAction func addInterval(_ sender: Any) {
        self.intervals.append(Interval(action: .hang, duration: 0))
        self.intervalTableView.reloadData()
        let indexPath = IndexPath(row: self.intervals.count - 1, section: 0)
        self.intervalTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        performSegue(withIdentifier: "intervalDetails", sender: self)
    }
    
    // MARK: - Update Interval
    func updateInterval(with interval: Interval, at index: Int) {
        self.intervals[index] = interval
        self.intervalTableView.reloadData()
        print(self.intervals)
        self.saveSession()
    }
    
    // MARK: - Reorder Button
    @IBAction func reOrderIntervalsBtnClick(_ sender: Any) {
        self.intervalTableView.isEditing = !self.intervalTableView.isEditing
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue with \(segue.identifier!) indentifier triggered")
        if segue.identifier == "intervalDetails" {
            if let indexPath = self.intervalTableView.indexPathForSelectedRow {
                print("found row \(indexPath.row)")
                if let intervalViewController = segue.destination as? IntervalViewController {
                    print("Interval Details controller found")
                    intervalViewController.intervalId = indexPath.row
                    intervalViewController.interval = self.intervals[indexPath.row]
                    intervalViewController.updateIntervalDelagate = self
                }
            }
        }
    }

}

extension SessionViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAtion = UIContextualAction(style: .normal, title: "Delete", handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
            print("delete \(indexPath)")
            self.intervals.remove(at: indexPath.row)
            self.intervalTableView.deleteRows(at: [indexPath], with: .automatic)
        })
        deleteAtion.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [deleteAtion])
    }
    
    // MARK: - Reorder TableView
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveInterval = self.intervals[sourceIndexPath.row]
        self.intervals.remove(at: sourceIndexPath.row)
        self.intervals.insert(moveInterval, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.intervalTableView.cellForRow(at: indexPath) {
            cell.selectionStyle = .none
        }
    }
    
}
