//
//  SettingsViewController.swift
//  Hang
//
//  Created by Dominic Egginton on 06/12/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openInfo(_ sender: Any) {
        let url = URL(string: "https://www.climbing.com/skills/copy-of-tech-tips-contact-2/")
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true)
    }
    
    @IBAction func sendEmailBtnClick(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let emailTitle = "Hang: Feature Request / Bug Report 🐞"
            let emailBody = ""
            let destinationEamil = ["dominic.egginton@gmail.com"]
            let mail: MFMailComposeViewController = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(emailTitle)
            mail.setMessageBody(emailBody, isHTML: false)
            mail.setToRecipients(destinationEamil)
            self.present(mail, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Email Can No Opened", message: "Have you setup email on your device?", preferredStyle: .actionSheet)
            let alertOkay = UIAlertAction(title: "OKay", style: .destructive, handler: nil)
            alert.addAction(alertOkay)
            present(alert, animated: true, completion: nil)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
            case MFMailComposeResult.cancelled:
                controller.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Feedback is Always Welcome", message: "Are yuo sure you want to cancle your feedback?", preferredStyle: .actionSheet)
                let alertNo = UIAlertAction(title: "Provide Feedback", style: .default, handler: self.sendEmailBtnClick(_:))
                alert.addAction(alertNo)
                let alertYes = UIAlertAction(title: "Im Sure", style: .destructive, handler: nil)
                alert.addAction(alertYes)
                present(alert, animated: true, completion: nil)
            case MFMailComposeResult.saved:
                print("Saved")
            case MFMailComposeResult.sent:
                controller.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Thank You For Your Feedback", message: "Your feedback will help to make this app better", preferredStyle: .actionSheet)
                let alertNo = UIAlertAction(title: "No Problem", style: .default, handler: self.sendEmailBtnClick(_:))
                alert.addAction(alertNo)
                present(alert, animated: true, completion: nil)
            case MFMailComposeResult.failed:
                print("Error: \(String(describing: error?.localizedDescription))")
            default:
                break
        }
        controller.dismiss(animated: true, completion: nil)
    }

}
