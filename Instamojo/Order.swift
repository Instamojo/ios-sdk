//
//  Order.swift
//  Instamojo
//
//  Created by Sukanya Raj on 14/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class Order {

    var id: String?
    var transactionID: String?
    let buyerName: String?
    var buyerEmail: String?
    var buyerPhone: String?
    var amount: String?
    var description: String?
    var currency: String?
    var redirectionUrl: String?
    var webhook: String?
    var mode: String?
    var authToken: String?
    var resourceURI: String?
    var clientID: String?
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
        self.description = description
        self.webhook = webhook
        if Urls.getBaseUrl().contains("test") {
           self.clientID = Constants.TestClientId
        } else {
            self.clientID = Constants.ProdClientId
        }
    }

    public func isValidToCreateOrder() -> (validity: Bool, error: String) {
        let space = ","
        return (isValidName().validity && isValidEmail().validity && isValidPhone().validity && isValidAmount().validity && isValidWebhook().validity && isValidDescription().validity  && isValidTransactionID().validity, isValidName().error + space + isValidEmail().error + space + isValidPhone().error + space + isValidAmount().error + space + isValidWebhook().error + space + isValidTransactionID().error)
    }

    public func isValid() -> (validity: Bool, error: String) {
        let space = ","
        return (isValidName().validity && isValidEmail().validity && isValidPhone().validity && isValidAmount().validity && isValidWebhook().validity && isValidDescription().validity && isValidRedirectURL().validity && isValidTransactionID().validity, isValidName().error + space + isValidEmail().error + space + isValidPhone().error + space + isValidAmount().error + space + isValidWebhook().error + space + isValidDescription().error + space + isValidRedirectURL().error + space + isValidTransactionID().error)
    }

    /**
     * @return false if the buyer name is empty or has greater than 100 characters. Else true.
     */
    func isValidName() -> (validity: Bool, error: String) {
        if (self.buyerName?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "The buyer name is empty")
        } else if ((self.buyerName?.characters.count)! > 100) {
            return (false, "The buyer name is greater than 100 characters")
        } else {
             return (true, "Valid Name")
        }
    }

    /**
     * @return false if the buyer email is empty or has greater than 75 characters. Else true.
     */
    func isValidEmail() -> (validity: Bool, error: String) {
        if  (self.buyerEmail?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "The buyer email is empty")
        } else if (self.buyerEmail?.characters.count)! > 75 {
            return (false, "The buyer email is greater than 75 characters")
        } else {
             return (true, "Valid Email")
        }
    }

    /**
     * @return false if the phone number is empty. Else true.
     */
    func isValidPhone() -> (validity: Bool, error: String) {
        if (self.buyerPhone?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Phone number is empty")
        } else {
            return (true, "Valid Phone Number")
        }
    }

    /**
     * @return false if the amount is empty or less than Rs. 9 or has more than 2 decimal places.
     */
    func isValidAmount() -> (validity: Bool, error: String) {
        if (self.amount?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Amount is empty")
        } else {
            let amountArray = self.amount?.components(separatedBy: ".")
            if amountArray?.count != 2 {
                 return (false, "In valid Amount")
            } else {
                if (amountArray?[0].characters.count)! < 2 {
                    return (false, "In valid Amount")
                } else {
                    return (true, "Valid Amount")
                }
            }
        }
    }

    /**
     * @return false if the description is empty or has greater than 255 characters. Else true.
     */
    func isValidDescription()-> (validity: Bool, error: String) {
        if (self.description?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Description is empty")
        } else if (self.description?.characters.count)! > 255 {
            return (true, "Description is greater than 255 characters")
        } else {
            return (true, "Valid Description")
        }
    }

    /**
     * @return false if the transaction ID is empty or has greater than 64 characters.
     */
    func isValidTransactionID() -> (validity: Bool, error: String) {
        if (self.transactionID?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Transaction ID is empty")
        } else if (self.transactionID?.characters.count)! > 64 {
            return (true, "Transaction ID is greater than 64 characters")
        } else {
            return (true, "Valid Transaction ID")
        }
    }

    /**
     * @return false if the redirection URL is empty or contains any query parameters.
     */

    func isValidRedirectURL() -> (validity: Bool, error: String) {
        if (self.redirectionUrl?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (true, "Valid Redirection URL")
        } else if isValidURL(urlString: (self.redirectionUrl)!) {
            return (true, "Redirection URL is invalid")
        } else {
            return (true, "Valid Redirection URL")
        }
    }

    /**
     * @return false if webhook is set and not a valid url or has query parameters
     */
    func isValidWebhook() -> (validity: Bool, error: String) {
        if (self.webhook?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            return (false, "Webhook is empty")
        } else {
            return (true, "Valid Webhook")
        }
    }

    func isValidURL(urlString: String) -> Bool {
        let url: NSURL = NSURL(string: urlString)!
        if url.query != nil {
            return false
        } else {
            return true
        }
    }

}
