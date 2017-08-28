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
    static var isNavigation: Bool = true
    /**
     * Initizalise Instamojo
     *
     */
    public class func setup() {
        instance = true
        Logger.enableLog(enable: true)
        Urls.setBaseUrl(baseUrl: Constants.DefaultBaseUrl)
    }

    public class func enableLog(option: Bool) {
        if initiliazed() {
            Logger.enableLog(enable: option)
        } else {
            return
        }
    }

    /**
     * Sets the base url for all network calls
     *
     * @param url String
     */
    public class func setBaseUrl(url: String) {
        Urls.setBaseUrl(baseUrl: url)
    }

    private class func initiliazed() -> Bool {
        if Instamojo.instance {
            return true
        } else {
            return false
        }
    }
    
    public class func isNavigationStack() -> Bool {
        if Instamojo.isNavigation {
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

    /**
     * Invoke Pre Created Payment UI
     *
     * @param order Order
     */
    //@available(*, deprecated:1.0.10, message:"no longer needed")
    public class func invokePaymentOptionsView(order: Order) {
        self.resetDefaults()
        let storyBoard: UIStoryboard = Constants.getStoryboardInstance()
        if let viewController: PaymentOptionsView = storyBoard.instantiateViewController(withIdentifier: Constants.PaymentOptionsViewController) as? PaymentOptionsView {
            viewController.order = order
            let window: UIWindow? = UIApplication.shared.keyWindow
            let rootClass = window?.rootViewController
            if rootClass is UINavigationController {
                isNavigation = true
                let navController: UINavigationController? = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)
                navController?.pushViewController(viewController, animated: true)
            } else {
                viewController.isBackButtonNeeded = false
                isNavigation = false
                let vc = window?.rootViewController
                let navController = UINavigationController(rootViewController: viewController)
                navController.navigationBar.isTranslucent = false
                vc?.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    /**
     * Invoke Pre Created Payment UI by passing loaded viewcontroller in scenario with multiple navigation or tab bar with navigation within
     *
     * @param order Order
     */
    public class func invokePaymentOptionsView(order: Order, controller: UIViewController) {
        self.resetDefaults()
        let storyBoard: UIStoryboard = Constants.getStoryboardInstance()
        if let viewController: PaymentOptionsView = storyBoard.instantiateViewController(withIdentifier: Constants.PaymentOptionsViewController) as? PaymentOptionsView {
            viewController.order = order
            let window: UIWindow? = UIApplication.shared.keyWindow
            //let rootClass = window?.rootViewController
            if controller.navigationController != nil && controller.navigationController?.navigationBar.isHidden == false{
                isNavigation = true
                controller.navigationController?.pushViewController(viewController, animated: true);
            } else {
                viewController.isBackButtonNeeded = false
                isNavigation = false
                let vc = window?.rootViewController
                let navController = UINavigationController(rootViewController: viewController)
                navController.navigationBar.isTranslucent = false
                vc?.present(navController, animated: true, completion: nil)
            }
        }
    }
    /**
     * Invoke Payment For Custom UI
     *
     * @param params BrowserParams
     */
    public class func makePayment(params: BrowserParams) {
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
