//
//  Instamojo.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation
import UIKit

public class Instamojo : NSObject{
    
    static var instance : Bool = false;
    
    /**
     * Sets the base url for all network calls
     *
     * @param baseUrl URl
     */
    public override class func initialize(){
        instance = true;
        Logger.setLogLevel(level: true);
        Urls.setBaseUrl(baseUrl: Constants.DEFAULT_BASE_URL);
    }
    
    public class func setLogLevel(level : Bool){
        if initiliazed() {
            Logger.setLogLevel(level: level)
        }else{
            return;
        }
    }
    
    /**
     * Sets the base url for all network calls
     *
     * @param baseUrl URl
     */
    public class func setBaseUrl(url : String){
        if initiliazed() {
            Urls.setBaseUrl(baseUrl: url)
        }else{
            return;
        }
    }
    
    private class func initiliazed() -> Bool{
        if Instamojo.instance {
            return true;
        }else{
            return false;
        }
    }
    
    
    public class func invokePaymentOptionsView(order : Order){
        let storyBoard:UIStoryboard = Constants.getStoryboardInstance()
        let viewController : PaymentOptionsView = storyBoard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_VIEW_CONTROLLER) as! PaymentOptionsView
        viewController.order = order
        let window: UIWindow? = UIApplication.shared.keyWindow
        let rootClass = window?.rootViewController;
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
