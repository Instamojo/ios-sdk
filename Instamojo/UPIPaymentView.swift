//
//  UPIPaymentView.swift
//  Instamojo
//
//  Created by Sukanya Raj on 07/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class UPIPaymentView: UIViewController, UPICallBack, UITextFieldDelegate {

    @IBOutlet weak var alertMessageView: UIView!
    @IBOutlet weak var vpaDetailsView: UIView!
    @IBOutlet weak var vpa: UITextField!
    var order: Order!
    var upiSubmissionResponse: UPISubmissionResponse!
    var spinner: Spinner!
    var continueCheck: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let verifyPaymentButton = UIBarButtonItem(
            title: Constants.UpiTitle,
            style: .plain,
            target: self,
            action: #selector(verifyPayment(sender:))
        )
        self.navigationItem.setRightBarButton(verifyPaymentButton, animated: false)
        self.upiSubmissionResponse = UPISubmissionResponse()
        spinner = Spinner(text: Constants.SpinnerText)
        spinner.hide()
        self.view.addSubview(spinner)
        self.vpa.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.vpa.resignFirstResponder()
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if continueCheck {
            UserDefaults.standard.setValue(true, forKey: "USER-CANCELLED-ON-VERIFY")
            UserDefaults.standard.setValue(nil, forKey: "USER-CANCELLED")
            UserDefaults.standard.setValue(nil, forKey: "ON-REDIRECT-URL")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        continueCheck = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func verifyPayment(sender: UIBarButtonItem) {
        let virturalPaymentAddress = self.vpa.text
        if (virturalPaymentAddress?.contains("@"))! {
            self.vpa.resignFirstResponder()
            self.spinner.show()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            let request = Request.init(order: self.order, virtualPaymentAddress: virturalPaymentAddress!, upiCallBack: self)
            request.execute()
        } else {
            self.showAlert(title: "Invalid VPA", errorMessage: "Please enter a valid VPA. Example mohit@icici")
        }
    }

    func onSubmission(upiSubmissionResponse: UPISubmissionResponse, exception: String) {
        DispatchQueue.main.async {
            self.spinner.hide()
            if !exception.isEmpty && upiSubmissionResponse.statusCode != Constants.PendingPayment {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.showAlert(title: "Payment Response", errorMessage: exception)
            } else {
                self.continueCheck = true
                self.vpaDetailsView.isHidden = true
                self.alertMessageView.isHidden = false
                self.upiSubmissionResponse = upiSubmissionResponse
                self.checkForStatusTransaction()
            }
        }
    }

    func checkForStatusTransaction() {
        self.spinner.setText(text: "Checking status..")
        self.spinner.show()
        let request = Request.init(order: self.order, upiSubmissionResponse: self.upiSubmissionResponse, upiCallback: self)
        request.execute()
    }

    func onStatusCheckComplete(paymentComplete: Bool, status: Int) {
        DispatchQueue.main.async {
            self.spinner.hide()
            if status == Constants.FailedPayment {
                 self.continueCheck = false
                 self.onPaymentStatusComplete(message: "Payment Cancelled")
            } else if status == Constants.PendingPayment {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if self.continueCheck {
                        // check transaction status 2 seconds later
                        self.checkForStatusTransaction()
                    }
                }
            } else if status == Constants.PaymentError {
                self.continueCheck = false
                self.onPaymentStatusComplete(message:"Error while making UPI Status Check request")
            } else {
                self.continueCheck = false
                self.onPaymentStatusComplete(message: "Payment Completed")
            }
        }
    }
    
    func onPaymentStatusComplete(message: String) {
        let alert = UIAlertController(title: "Payment Status", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(_) in
            UserDefaults.standard.setValue(true, forKey: "ON-REDIRECT-URL")
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is PaymentOptionsView {
                    _ = self.navigationController?.popToViewController(vc as! PaymentOptionsView, animated: true)
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "JUSPAY"), object: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, errorMessage: String) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
