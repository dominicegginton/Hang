//
//  TimerController.swift
//  Hang
//
//  Created by Dominic Egginton on 02/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    public var sessionId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = try? Sessions.instance.getSession(atIndex: self.sessionId!).name
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
