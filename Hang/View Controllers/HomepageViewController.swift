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
    
    var sessionTableViewSelection: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup sessionTableView
        sessionTableView.delegate = self
        sessionTableView.dataSource = self
    }
    
    @IBAction func newSession(_ sender: Any) {
        let newSession = Session(name: "", intervals: [])
        Sessions.instance.add(session: newSession)
        self.sessionTableView.reloadData()
        let indexPath = IndexPath(row: Sessions.instance.count - 1, section: 0)
        self.sessionTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        performSegue(withIdentifier: "sessionDetails", sender: nil)
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue with \(segue.identifier!) indentifier triggered")
        if segue.identifier == "sessionTimer" {
            if let indexPath = self.sessionTableView.indexPathForSelectedRow {
                print("found row \(indexPath.row)")
                if let timerViewController = segue.destination as? TimerViewController {
                    print("Session Timer controller found")
                    timerViewController.sessionId = indexPath.row
                }
            }
        } else if segue.identifier == "sessionDetails" {
            if let indexPath = self.sessionTableView.indexPathForSelectedRow {
                print("found row \(indexPath.row)")
                if let sessionViewController = segue.destination as? SessionViewController {
                    print("Session Details controller found")
                    sessionViewController.sessionId = indexPath.row
                    sessionViewController.updateSessionDelegate = self
                }
            } else if let indexPath = self.sessionTableViewSelection {
                print("found row \(indexPath.row) with sessionTableViewSelection")
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
        try? Sessions.instance.update(session: session, atIndex: index)
        self.sessionTableView.reloadData()
    }
    
}

// MARK: - Table View Delegate and Data Source

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Sessions.instance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SessionTableViewCell", owner: self, options: nil)?.first as! SessionTableViewCell
        // Configure the cell...
        
        do {
            cell.configureCell(session: try Sessions.instance.getSession(atIndex: indexPath.row))
        } catch {
            print("Error loading session")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.sessionTableViewSelection = indexPath
            self.performSegue(withIdentifier: "sessionDetails", sender: self)
            success(true)
        })
        editAction.backgroundColor = UIColor.systemIndigo
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAtion = UIContextualAction(style: .destructive, title: "Delete", handler: { (action: UIContextualAction, view: UIView, success :(Bool) -> Void) in
            print("delete \(indexPath)")
            do {
                try Sessions.instance.remove(atIndex: indexPath.row)
                self.sessionTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print(">>> error deleting session")
                success(false)
            }
            success(true)
        })
        deleteAtion.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [deleteAtion])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "sessionTimer", sender: self)
    }
    
}

