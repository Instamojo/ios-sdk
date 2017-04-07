//
//  Order.swift
//  Instamojo
//
//  Created by Sukanya Raj on 14/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class Order: NSObject {

    public var id: String?
    public var transactionID: String?
    public var buyerName: String?
    public var buyerEmail: String?
    public var buyerPhone: String?
    public var amount: String?
    public var orderDescription: String?
    public var currency: String?
    public var redirectionUrl: String?
    public var webhook: String?
    public var mode: String?
    public var authToken: String?
    public var resourceURI: String?
    public var clientID: String?
    public var cardOptions: CardOptions!
    public var netBankingOptions: NetBankingOptions!
    public var emiOptions: EMIOptions!
    public var walletOptions: WalletOptions!
    public var upiOptions: UPIOptions!

   public init(authToken: String, transactionID: String, buyerName: String, buyerEmail: String, buyerPhone: String, amount: String, description: String, webhook: String ) {
        self.authToken = authToken
        self.transactionID = transactionID
        self.buyerName = buyerName
        self.buyerEmail = buyerEmail
        self.buyerPhone = buyerPhone
        self.amount = amount
        self.currency = "INR"
        self.mode = "IOS_SDK"
        self.redirectionUrl = Urls.getDefaultRedirectUrl()
        self.orderDescription = description
        self.webhook = webhook
        if Urls.getBaseUrl().contains("test") {
           self.clientID = Constants.TestClientId
        } else {
            self.clientID = Constants.ProdClientId
        }
    }

    public func isValid() -> (validity: Bool, error: String) {
        let space = ","
        return (isValidName().validity && isValidEmail().validity && isValidPhone().validity && isValidAmount().validity && isValidWebhook().validity && isValidDescription().validity  && isValidTransactionID().validity, isValidName().error + space + isValidEmail().error + space + isValidPhone().error + space + isValidAmount().error + space + isValidWebhook().error + space + isValidTransactionID().error)
    }

    public func isValid() -> Bool {
        return isValidName().validity && isValidEmail().validity && isValidPhone().validity && isValidAmount().validity && isValidWebhook().validity && isValidDescription().validity && isValidRedirectURL().validity && isValidTransactionID().validity
    }

    /**
     * @return false if the buyer name is empty or has greater than 100 characters. Else true.
     */
    public func isValidName() -> (validity: Bool, error: String) {
        if (self.buyerName?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Required")
        } else if ((self.buyerName?.characters.count)! > 100) {
            return (false, "The buyer name is greater than 100 characters")
        } else {
             return (true, "Valid Name")
        }
    }

    //Tuples are not supported by Objective-C
    public func isValidName() -> NSDictionary {
        let dictonary = NSMutableDictionary()
        if (self.buyerName?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            dictonary.setValue("Required", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else if ((self.buyerName?.characters.count)! > 100) {
            dictonary.setValue("The buyer name is greater than 100 characters", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else {
            dictonary.setValue("Valid Name", forKey: "error")
            dictonary.setValue(true, forKey: "validity")
            return dictonary
        }
    }

    /**
     * @return false if the buyer email is empty or has greater than 75 characters. Else true.
     */
    public func isValidEmail() -> (validity: Bool, error: String) {
        if  (self.buyerEmail?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Required")
        } else if (self.buyerEmail?.characters.count)! > 75 {
            return (false, "The buyer email is greater than 75 characters")
        } else if !validateEmail(email: self.buyerEmail!) {
             return (false, "Invalid Email")
        } else {
             return (true, "Valid Email")
        }
    }

    public func isValidEmail() -> NSDictionary {
        let dictonary = NSMutableDictionary()
        if  (self.buyerEmail?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            dictonary.setValue("Required", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else if (self.buyerEmail?.characters.count)! > 75 {
            dictonary.setValue("The buyer email is greater than 75 characters", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else if !validateEmail(email: self.buyerEmail!) {
            dictonary.setValue("Invalid Email", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else {
            dictonary.setValue("Valid Email", forKey: "error")
            dictonary.setValue(true, forKey: "validity")
            return dictonary
        }
    }

    func validateEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    /**
     * @return false if the phone number is empty. Else true.
     */
    public func isValidPhone() -> (validity: Bool, error: String) {
        if (self.buyerPhone?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Required")
        } else {
            return (true, "Valid Phone Number")
        }
    }

    public func isValidPhone() -> NSDictionary {
        let dictonary = NSMutableDictionary()
        if (self.buyerPhone?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            dictonary.setValue("Required", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else {
            dictonary.setValue("Valid Phone Number", forKey: "error")
            dictonary.setValue(true, forKey: "validity")
            return dictonary
        }
    }

    /**
     * @return false if the amount is empty or less than Rs. 9 or has more than 2 decimal places.
     */
    public func isValidAmount() -> (validity: Bool, error: String) {
        if (self.amount?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Required")
        } else {
            let amountArray = self.amount?.components(separatedBy: ".")
            if amountArray?.count != 2 {
                 return (false, "Invalid Amount")
            } else {
                let amount = Int((amountArray?[0])!)
                if amount! < 9 {
                    return (false, "Invalid Amount")
                } else {
                    return (true, "Valid Amount")
                }
            }
        }
    }

    public func isValidAmount() -> NSDictionary {
        let dictonary = NSMutableDictionary()
        if (self.amount?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            dictonary.setValue("Required", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else {
            let amountArray = self.amount?.components(separatedBy: ".")
            if amountArray?.count != 2 {
                dictonary.setValue("Invalid Amount", forKey: "error")
                dictonary.setValue(false, forKey: "validity")
                return dictonary
            } else {
                let amount = Int((amountArray?[0])!)
                if amount! < 9 {
                    dictonary.setValue("Invalid Amount", forKey: "error")
                    dictonary.setValue(false, forKey: "validity")
                    return dictonary
                } else {
                    dictonary.setValue("Valid Amount", forKey: "error")
                    dictonary.setValue(true, forKey: "validity")
                    return dictonary
                }
            }
        }
    }

    /**
     * @return false if the description is empty or has greater than 255 characters. Else true.
     */
    public func isValidDescription()-> (validity: Bool, error: String) {
        if (self.orderDescription?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Required")
        } else if (self.orderDescription?.characters.count)! > 255 {
            return (true, "Description is greater than 255 characters")
        } else {
            return (true, "Valid Description")
        }
    }

    public func isValidDescription() -> NSDictionary {
        let dictonary = NSMutableDictionary()
        if (self.orderDescription?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            dictonary.setValue("Required", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else if (self.orderDescription?.characters.count)! > 255 {
            dictonary.setValue("Description is greater than 255 characters", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else {
            dictonary.setValue("Valid Description", forKey: "error")
            dictonary.setValue(true, forKey: "validity")
            return dictonary
        }
    }

    /**
     * @return false if the transaction ID is empty or has greater than 64 characters.
     */
    public func isValidTransactionID() -> (validity: Bool, error: String) {
        if (self.transactionID?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Transaction ID is a mandatory parameter")
        } else if (self.transactionID?.characters.count)! > 64 {
            return (true, "Transaction ID is greater than 64 characters")
        } else {
            return (true, "Valid Transaction ID")
        }
    }

    public func isValidTransactionID() -> NSDictionary {
        let dictonary = NSMutableDictionary()
        if (self.transactionID?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            dictonary.setValue("Transaction ID is a mandatory parameter", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary

        } else if (self.transactionID?.characters.count)! > 64 {
            dictonary.setValue("Transaction ID is greater than 64 characters", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else {
            dictonary.setValue("Valid Transaction ID", forKey: "error")
            dictonary.setValue(true, forKey: "validity")
            return dictonary
        }
    }

    /**
     * @return false if the redirection URL is empty or contains any query parameters.
     */

    public func isValidRedirectURL() -> (validity: Bool, error: String) {
        if (self.redirectionUrl?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (true, "Invalid Redirection URL")
        } else if !isValidURL(urlString: (self.redirectionUrl)!) {
            return (true, "Invalid Redirection URL")
        } else {
            return (true, "Valid Redirection URL")
        }
    }

    public func isValidRedirectURL() -> NSDictionary {
        let dictonary = NSMutableDictionary()
        if (self.redirectionUrl?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            dictonary.setValue("Invalid Redirection URL", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else if !isValidURL(urlString: (self.redirectionUrl)!) {
            dictonary.setValue("Invalid Redirection URL", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else {
            dictonary.setValue("Valid Redirection URL", forKey: "error")
            dictonary.setValue(true, forKey: "validity")
            return dictonary
        }
    }

    /**
     * @return false if webhook is set and not a valid url or has query parameters
     */
    public func isValidWebhook() -> (validity: Bool, error: String) {
        if (self.webhook?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Webhook is a mandatory parameter.")
        } else {
            return (true, "Valid Webhook")
        }
    }

    public func isValidWebhook() -> NSDictionary {
        let dictonary = NSMutableDictionary()
        if (self.webhook?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            dictonary.setValue("Webhook is a mandatory parameter.", forKey: "error")
            dictonary.setValue(false, forKey: "validity")
            return dictonary
        } else {
            dictonary.setValue("Valid Webhook", forKey: "error")
            dictonary.setValue(true, forKey: "validity")
            return dictonary
        }
    }

    public func isValidURL(urlString: String) -> Bool {
        let url: NSURL = NSURL(string: urlString)!
        if url.query != nil {
            return false
        } else {
            return true
        }
    }

}
