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
    

    @objc func fireTimer() {
        if self.readyTick > 0 {
            self.messageLbl.text = "Get Ready"
            self.title = "\(self.readyTick)"
            let progressTick = 5 - (self.readyTick - 1)
            let progress: Float = Float(progressTick) / Float(5)
            self.progressBar.setProgress(progress, animated: true)
            self.readyTick -= 1
        } else {
            if self.intervalTick > 0 {
                self.messageLbl.text = "\(self.currentInterval!.action.rawValue)"
                self.title = "\(self.intervalTick)"
                let progressTick = self.currentInterval!.duration - (self.intervalTick - 1)
                let progress: Float = Float(progressTick) / Float(self.currentInterval!.duration)
                print(progress)
                self.progressBar.setProgress(progress, animated: true)
                self.intervalTick -= 1
            } else {
                if self.intervals.count > 0 {
                    self.progressBar.progress = 0
                    self.currentInterval = self.intervals[0]
                    self.progressBar.tintColor = currentInterval?.action.color
                    self.intervalTick = self.currentInterval!.duration
                    self.intervals.remove(at: 0)
                    self.intervalTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                    self.title = "\(self.intervalTick)"
                    self.messageLbl.text = "\(self.currentInterval!.action.rawValue)"
                    self.intervalTick -= 1
                    let progress: Float = Float(1) / Float(self.currentInterval!.duration)
                    self.progressBar.setProgress(progress, animated: true)
                } else {
                    self.progressBar.setProgress(1, animated: true)
                    self.title = "\(self.intervalTick)"
                    self.messageLbl.text = "Session Completed 💪"
                    print(">>> timer ended")
                    self.timer?.invalidate()
                    self.timerIsRunning = false
                }
            }
        }
    }

    @IBAction func timerControlBtnClick(_ sender: Any) {
        if !self.timerIsRunning {
            self.readyTick = 5
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            self.timerControlBtn.title = "Pause"
        } else {
            self.timer?.invalidate()
            self.timerControlBtn.title = "Start"
        }
        self.timerIsRunning = !self.timerIsRunning
    }
    
    @IBAction func shareBtnClick(_ sender: Any) {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
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
