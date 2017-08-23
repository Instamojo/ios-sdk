//
//  PaymentView.swift
//  Instamojo
//
//  Created by Sukanya Raj on 27/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    var juspaySafeBrowser = JuspaySafeBrowser()
    var params: BrowserParams!
    var cancelled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.logDebug(tag: "Juspay Request", message: "Juspay Request Starting juspay safe browser payment")
        self.juspaySafeBrowser.startpaymentWithJuspay(in: self.view, withParameters: self.params) { (status, error, _) in
            let transactionStatus = TransactionStatus()
            if (!status) {
                transactionStatus.paymentID = "TransactionID"
                let nsError = error! as NSError
                if (nsError.code == 101) {
                    self.cancelled = true
                    transactionStatus.paymentStatus = JPCANCELLED
                    UserDefaults.standard.setValue(true, forKey: "USER-CANCELLED")
                    UserDefaults.standard.setValue(nil, forKey: "ON-REDIRECT-URL")
                    let controllers = self.navigationController?.viewControllers
                    for vc in controllers! {
                        if vc is PaymentOptionsView {
                            _ = self.navigationController?.popToViewController(vc as! PaymentOptionsView, animated: true)
                        }
                        if(Instamojo.isNavigationStack() == false ){
                            vc.dismiss(animated: true, completion: nil)
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "INSTAMOJO"), object: nil)
                } else {
                    transactionStatus.paymentStatus = JPUNKNOWNSTATUS
                }
            }
            JPLoger.sharedInstance().logPaymentStatus(transactionStatus)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    //the navigationShouldPopOnBackButton method to check if controller is allowed to pop.
    override func navigationShouldPopOnBackButton() -> Bool {
        self.juspaySafeBrowser.backButtonPressed()
        return self.juspaySafeBrowser.isControllerAllowedToPop
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //To renable interactive pop gesture.
        if !cancelled {
            UserDefaults.standard.setValue(nil, forKey: "USER-CANCELLED")
            UserDefaults.standard.setValue(true, forKey: "ON-REDIRECT-URL")
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is PaymentOptionsView {
                    _ = self.navigationController?.popToViewController(vc as! PaymentOptionsView, animated: true)
                }
                if(Instamojo.isNavigationStack() == false ){
                    vc.dismiss(animated: true, completion: nil)
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "INSTAMOJO"), object: nil)
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}
