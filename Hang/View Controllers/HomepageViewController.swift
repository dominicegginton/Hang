//
//  HomepageController.swift
//  Hang
//
//  Created by Dominic Egginton on 18/11/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController, UpdateSessionDelagate {
    
    // UI Outlets
    @IBOutlet weak var sessionTableView: UITableView!
    
    // IndexPathForEdit
    var sessionTableViewSelection: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup sessionTableView
        sessionTableView.delegate = self
        sessionTableView.dataSource = self
    }
    
    // MARK: - New Session
    @IBAction func newSession(_ sender: Any) {
        // Create new session
        let newSession = Session(name: "", intervals: [])
        // Add new session to Sessions
        try? Sessions.instance.add(session: newSession)
        // Reload Sessions Table
        self.sessionTableView.reloadData()
        // Select New Session in Table
        let indexPath = IndexPath(row: Sessions.instance.count - 1, section: 0)
        self.sessionTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        // Perform Segue to Session Details
        performSegue(withIdentifier: "sessionDetails", sender: nil)
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Session Timer
        if segue.identifier == "sessionTimer" {
            if let indexPath = self.sessionTableView.indexPathForSelectedRow {
                if let timerViewController = segue.destination as? TimerViewController {
                    timerViewController.sessionId = indexPath.row
                }
            }
        }
        // Session Details
        else if segue.identifier == "sessionDetails" {
            // If selected with no edit
            if let indexPath = self.sessionTableView.indexPathForSelectedRow {
                if let sessionViewController = segue.destination as? SessionViewController {
                    print("Session Details controller found")
                    sessionViewController.sessionId = indexPath.row
                    sessionViewController.updateSessionDelegate = self
                }
            }
            // If selceted with edit
            else if let indexPath = self.sessionTableViewSelection {
                if let sessionViewController = segue.destination as? SessionViewController {
                    print("Session Details controller found")
                    sessionViewController.sessionId = indexPath.row
                    sessionViewController.updateSessionDelegate = self
                }
            }
        }
    }
    
    // MARK: - Update Session
    func updateSession(with session: Session, at index: Int) {
        // Update session
        try? Sessions.instance.update(session: session, atIndex: index)
        // Release Data
        self.sessionTableView.reloadData()
    }
    
}

// MARK: - Table View Delegate and Data Source

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of rows the table should fill. 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Sessions.instance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SessionTableViewCell", owner: self, options: nil)?.first as! SessionTableViewCell
        // Configure the cell
        // Add Accessibility Identifier
         cell.accessibilityIdentifier = "sessionCell/\(indexPath.row)"
        do {
            cell.configureCell(session: try Sessions.instance.getSession(atIndex: indexPath.row))
        } catch {
            print("Error loading session")
        }
        return cell
    }
    
    // Leading Swipe Actions
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Edit Btn
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            // Select tableView Cell
            self.sessionTableViewSelection = indexPath
            // Perform segue to Session Details Page
            self.performSegue(withIdentifier: "sessionDetails", sender: self)
            success(true)
        })
        editAction.backgroundColor = UIColor.systemIndigo
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    // Tralining Swipe Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Delete Btn
        let deleteAtion = UIContextualAction(style: .destructive, title: "Delete", handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
            do {
                // Remove session
                try Sessions.instance.remove(atIndex: indexPath.row)
                // Remove Session from tableview
                self.sessionTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                // Error
                print(">>> error deleting session")
                success(false)
            }
            success(true)
        })
        deleteAtion.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [deleteAtion])
    }
    
    // If table view row is clicked, take to session details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "sessionTimer", sender: self)
    }
    
}

