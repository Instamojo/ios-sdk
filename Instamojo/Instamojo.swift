//
//  Instamojo.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation
import UIKit

public class Instamojo: NSObject {

    static var instance: Bool = false

    /**
     * Sets the base url for all network calls
     *
     * @param baseUrl URl
     */
    public override class func initialize() {
        instance = true
        Logger.enableLog(enable: true)
        Urls.setBaseUrl(baseUrl: Constants.DefaultBaseUrl)
    }

    public class func enableLog(enable: Bool) {
        if initiliazed() {
            Logger.enableLog(enable: enable)
        } else {
            return
        }
    }

    /**
     * Sets the base url for all network calls
     *
     * @param baseUrl URl
     */
    public class func setBaseUrl(url: String) {
        if initiliazed() {
            Urls.setBaseUrl(baseUrl: url)
        } else {
            return
        }
    }

    private class func initiliazed() -> Bool {
        if Instamojo.instance {
            return true
        } else {
            return false
        }
    }

    private class func resetDefaults() {
        UserDefaults.standard.setValue(nil, forKey: "USER-CANCELLED-ON-VERIFY")
        UserDefaults.standard.setValue(nil, forKey: "USER-CANCELLED")
        UserDefaults.standard.setValue(nil, forKey: "ON-REDIRECT-URL")
    }

    public class func invokePaymentOptionsView(order: Order) {
        self.resetDefaults()
        let storyBoard: UIStoryboard = Constants.getStoryboardInstance()
        if let viewController: PaymentOptionsView = storyBoard.instantiateViewController(withIdentifier: Constants.PaymentOptionsViewController) as? PaymentOptionsView {
            viewController.order = order
            let window: UIWindow? = UIApplication.shared.keyWindow
            let rootClass = window?.rootViewController
            if rootClass is UINavigationController {
                let navController: UINavigationController? = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)
                navController?.pushViewController(viewController, animated: true)
            } else {
                let navController = UINavigationController(rootViewController: (window?.rootViewController)!)
                window?.rootViewController = nil
                window?.frame = UIScreen.main.bounds
                window?.rootViewController = navController
                navController.pushViewController(viewController, animated: true)
            }
        }
    }
    
    public class func makePayment(params: BrowserParams){
        self.resetDefaults()
        let storyBoard: UIStoryboard = Constants.getStoryboardInstance()
        let viewController = storyBoard.instantiateViewController(withIdentifier: Constants.PaymentOptionsJuspayViewController) as! PaymentViewController
        viewController.params = params
        let window: UIWindow? = UIApplication.shared.keyWindow
        let rootClass = window?.rootViewController
        if rootClass is UINavigationController {
            let navController: UINavigationController? = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)
            navController?.pushViewController(viewController, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: (window?.rootViewController)!)
            window?.rootViewController = nil
            window?.frame = UIScreen.main.bounds
            window?.rootViewController = navController
            navController.pushViewController(viewController, animated: true)
        }
    }
    
}
