//
//  ContactViewController.swift
//  NYS Challenge App
//
//  Created by Fikri Karadereli on 24.07.2018.
//  Copyright © 2018 Fikri Karadereli. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
    // IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    
    
    //MARK: - IBAction Methods
    /***************************************************************/
    
    @IBAction func sendEmail(_ sender: Any) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        if !isValidEmail(email: emailTextField.text!) {

            let alertView = UIAlertController(title: "Geçersiz Email", message: "Tekrar Deneyin", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            self.present(alertView, animated:true, completion:nil)
  
        } else if !isValidPhoneNumber(phoneNumber: phoneNumberTextField.text!) {
            
            let alertView = UIAlertController(title: "Geçersiz Telefon Numarası", message: "Tekrar Deneyin", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            self.present(alertView, animated:true, completion:nil)
            
        } else { // Everything is OK

            let toRecipients = ["gokhan.gokova@neyasis.com"]
            let mailComposeVC = MFMailComposeViewController()
            
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(toRecipients)
            mailComposeVC.setSubject(nameTextField.text!)
            mailComposeVC.setMessageBody("Ad: \(nameTextField.text!) \n\nEmail: \(emailTextField.text!) \n\nDoğum Tarihi: \(birthdayTextField.text!) \n\nTelefon Numarası: \(phoneNumberTextField.text!) \n\nMesaj: \(messageTextField.text!)", isHTML: false)
            
            self.present(mailComposeVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    
    
    //MARK: - Helper Methods
    /***************************************************************/
    
    func isValidEmail(email: String?) -> Bool {

        guard email != nil else { return false }

        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: email)
    }

    func isValidPhoneNumber(phoneNumber: String?) -> Bool {
        
        guard phoneNumber != nil else { return false }

        //let regEx = "^((\\+)|(00))[0-9]{6,14}$"
        //let regEx = "[235689][0-9]{6}([0-9]{3})?"
        //let regEx = "^[0-9]{10}$"
        
        let regEx = "(?\\d{3})?\\s\\d{3}-\\d{4}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: phoneNumber)
    }
    
    
    //MARK: - MFMailComposeViewController Delegate Methods
    /***************************************************************/
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.failed.rawValue:
            print("Failed")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}
