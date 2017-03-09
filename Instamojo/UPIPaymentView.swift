//
//  UPIPaymentView.swift
//  Instamojo
//
//  Created by Sukanya Raj on 07/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class UPIPaymentView: UIViewController, UPICallBack {

    @IBOutlet weak var alertMessageView: UIView!
    @IBOutlet weak var vpaDetailsView: UIView!
    @IBOutlet weak var vpa: UITextField!
    var order: Order!
    var upiSubmissionResponse: UPISubmissionResponse!
    var spinner: Spinner!
    var continueCheck: Bool = true

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
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        continueCheck = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func verifyPayment(sender: UIBarButtonItem) {
        self.spinner.show()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let request = Request.init(order: self.order, virtualPaymentAddress: self.vpa.text!, upiCallBack: self)
        request.execute()
    }

    func onSubmission(upiSubmissionResponse: UPISubmissionResponse, exception: String) {
        DispatchQueue.main.async {
            self.spinner.hide()
            if !exception.isEmpty && upiSubmissionResponse.statusCode != Constants.PendingPayment {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.showAlert(errorMessage: "Please Try Again")
            } else {
                self.vpaDetailsView.isHidden = true
                self.alertMessageView.isHidden = false
                self.title = Constants.UpiTitle
                self.upiSubmissionResponse = upiSubmissionResponse
                self.checkForStatusTransaction()
            }
        }
    }

    func checkForStatusTransaction() {
        let request = Request.init(order: self.order, upiSubmissionResponse: self.upiSubmissionResponse, upiCallback: self)
        request.execute()
    }

    func onStatusCheckComplete(paymentComplete: Bool, exception: String) {
        DispatchQueue.main.async {
            if !exception.isEmpty && !paymentComplete {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if self.continueCheck {
                        // check transaction status 2 seconds later
                        self.checkForStatusTransaction()
                    }
                }
            } else {
                self.showAlert(errorMessage: "Payment complete. Finishing activity...")
            }
        }
    }

    func showAlert(errorMessage: String) {
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(_) in
            if !self.continueCheck {
                 _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
