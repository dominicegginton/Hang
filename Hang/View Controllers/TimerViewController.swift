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
    
    // Timer
    var timer: Timer?
    var timerIsRunning: Bool = false
    var currentInterval: Interval?
    var intervalTick: Int = 0
    var readyTick: Int = 5

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
        self.timerControlBtn.title = "Start"
        self.progressBar.progress = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            if self.timer != nil {
                self.timer?.invalidate()
            }
        }
    }
    
    // MARK:- Timer
    @objc func fireTimer() {
        // If ready state
        if self.readyTick > 0 {
            // Set ready message
            self.messageLbl.text = "Get Ready"
            // Set time
            self.title = "\(self.readyTick)"
            // Animate progress bar
            let progressTick = 5 - (self.readyTick - 1)
            let progress: Float = Float(progressTick) / Float(5)
            self.progressBar.setProgress(progress, animated: true)
            // Reduce ready tick
            self.readyTick -= 1
        } else {
            // if interval in ticking
            if self.intervalTick > 0 {
                // Set label
                self.messageLbl.text = "\(self.currentInterval!.action.rawValue)"
                // Set time
                self.title = "\(self.intervalTick)"
                // Animate progress bar
                let progressTick = self.currentInterval!.duration - (self.intervalTick - 1)
                let progress: Float = Float(progressTick) / Float(self.currentInterval!.duration)
                self.progressBar.setProgress(progress, animated: true)
                // Reduce progres tick
                self.intervalTick -= 1
            } else {
                // Porgress has reached 0
                if self.intervals.count > 0 {
                    // Set new current interval
                    self.currentInterval = self.intervals[0]
                    // Reset progress bar
                    self.progressBar.progress = 0
                    self.progressBar.tintColor = currentInterval?.action.color
                    // Reset interval tick
                    self.intervalTick = self.currentInterval!.duration
                    // Remove old interval
                    self.intervals.remove(at: 0)
                    // Remove current interval from tableview
                    self.intervalTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                    // Set time
                    self.title = "\(self.intervalTick)"
                    // Set interval message
                    self.messageLbl.text = "\(self.currentInterval!.action.rawValue)"
                    // Reduce interval tick
                    self.intervalTick -= 1
                    // Animate progress bar
                    let progress: Float = Float(1) / Float(self.currentInterval!.duration)
                    self.progressBar.setProgress(progress, animated: true)
                } else {
                    // Session Completed
                    self.progressBar.setProgress(1, animated: true)
                    self.title = "\(self.intervalTick)"
                    self.messageLbl.text = "Session Completed 💪"
                    // End timer
                    self.timer?.invalidate()
                    self.timerIsRunning = false
                }
            }
        }
    }

    @IBAction func timerControlBtnClick(_ sender: Any) {
        // If timer not running
        if !self.timerIsRunning {
            // Set ready to 5 seconds
            self.readyTick = 5
            // Start timer
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            self.timerControlBtn.title = "Pause"
        } else {
            // Stop timer
            self.timer?.invalidate()
            self.timerControlBtn.title = "Start"
        }
        // Set timerIsRunning to (if true then false, if flase then true)
        self.timerIsRunning = !self.timerIsRunning
    }
    
    // MARK:- Shere
    @IBAction func shareBtnClick(_ sender: Any) {
        // Set bounds
        let bounds = UIScreen.main.bounds
        // Take Screenshot
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Shere screenshot
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

// MARK: - Table View Controle.
extension TimerViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Set number of rows in selection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.intervals.count
    }

    // Create interval cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("IntervalTableViewCell", owner: self, options: nil)?.first as! IntervalTableViewCell
        // Configure the cell
        let interval = self.intervals[indexPath.row]
        cell.configureCell(interval: interval)
        return cell
    }
}
