//
//  Constants.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation
import UIKit

public class Constants {

    //Default base url
    public static let DefaultBaseUrl = "https://api.instamojo.com/"

    // Status code for UPI Pending Authentication
    public static let PendingPayment = 2
    public static let FailedPayment = 6
    public static let PaymentError = 104

    //Ruppe 
    public static let Inr = "\u{20B9}"

    //DateFormat
    public static let DateFormat = "%02d/%d"

    //Default Card Expiry
    public static let DefaultCardExpiry = "12/49"

    // Default CVV Number
    public static let DefaultCvv = "111"

    //Card Validation Errors
    public static let EmptyCardNumer = "Required"
    public static let InvalidCardNumber = "Invalid Card Number"
    public static let EmptyCardHolderName = "Required"
    public static let EmptyExpiryDate = "Required"
    public static let EmptyCVV = "Required"
    
    //Card Image Names
    public static let AcceptedCards = "accepted_cards"
    public static let UnknownCard = "ic_unknown_card"

    //Spinner Text
    public static let SpinnerText = "Please Wait.."

    //Card Options
    public static let DebitCard = 101
    public static let CreditCard = 102
    public static let CrediCardEmi = 103

    // Client ID is required for JuspayBrowser
    public static let ProdClientId = "instamojo8"
    public static let TestClientId = "testing_instamojo"

    //Payment Options
    public static let WalletsOption = "Wallets"
    public static let EmiOption = "EMI"
    public static let NetBankingOption = "Net Banking"
    public static let CreditCardOption = "Credit Card"
    public static let DebitCardOption = "Debit Card"
    public static let UpiOption = "UPI"

    //Storyboard ViewController Names
    public static let PaymentOptionsCell = "options"
    public static let PaymentOptionsListviewController = "optionsView"
    public static let PaymentOptionsCardViewController = "cardFormView"
    public static let PaymentOptionsUpiViewController = "upiPaymentView"
    public static let PaymentOptionsEmiViewController = "emiOptions"
    public static let PaymentOptionsJuspayViewController = "juspay"
    public static let PaymentOptionsViewController  = "PaymentOptions"

    //ViewController Titles
    public static let NetbankingTitle = "Choose your Bank"
    public static let WalletTitle = "Choose your Wallet"
    public static let EmiTitle = "Choose your Credit Card"
    public static let UpiTitle = "Verify Payment"
    public static let EmiCardTitle = "EMI on Credit Card"
    public static let CrediCardTitle = "Enter Credit Card Details"
    public static let DebitCardTitle = "Enter Debit Card Details"
    
    internal static let frameworkBundle = Bundle(identifier: "com.instamojo.ios.Instamojo")!
    
    public static func getStoryboardInstance() -> UIStoryboard {
        return UIStoryboard(name: "InstamojoStoryboard", bundle: frameworkBundle)
    }
}
