//
//  Constants.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation
import UIKit

public class Constants{
    
    //Default base url
   public static var DEFAULT_BASE_URL = "https://api.instamojo.com/";
    
    // Status code for UPI Pending Authentication
    public static let PENDING_PAYMENT = 2;
    
    //Ruppe 
    public static let INR = "\u{20B9}"
    
    //DateFormat
    public static let DATE_FORMAT = "%02d/%d"
    
    //Default Card Expiry
    public static let DEFAULT_CARD_EXPIRY = "12/49"
    
    // Default CVV Number
    public static let DEFAULT_CVV = "111"
    
    
    //Card Validation Errors
    public static let EMPTY_CARD_NUMER = "Please enter the card number"
    public static let INVALID_CARD_NUMBER = "Card Number is not valid"
    public static let EMPTY_CARD_HOLDER_NAME = "\n\nPlease enter Name"
    
    
    //Card Image Names
    public static let ACCEPTED_CARDS = "accepted_cards"
    public static let UNKNOWN_CARD = "ic_unknown_card"
    
    //Spinner Text
    public static let SPINNER_TEXT = "Please Wait.."
    
    //Card Options
    public static let DEBIT_CARD = 101;
    public static let CREDIT_CARD = 102;
    public static let CREDI_CARD_EMI = 103;
    
    // Client ID is required for JuspayBrowser
    public static let PROD_CLIENT_ID = "instamojo8"
    public static let TEST_CLIENT_ID = "testing_instamojo"
    
    //Payment Options
    public static let WALLETS_OPTION = "Wallets"
    public static let EMI_OPTION = "EMI"
    public static let NET_BANKING_OPTION = "Net Banking"
    public static let CREDIT_CARD_OPTION = "Credit Card"
    public static let DEBIT_CARD_OPTION = "Debit Card"
    public static let UPI_OPTION = "UPI"
    
    //Storyboard ViewController Names
    public static let PAYMENT_OPTIONS_CELL = "options"
    public static let PAYMENT_OPTIONS_LISTVIEW_CONTROLLER = "optionsView"
    public static let PAYMENT_OPTIONS_CARD_VIEW_CONTROLLER = "cardFormView"
    public static let PAYMENT_OPTIONS_UPI_VIEW_CONTROLLER = "upiPaymentView"
    public static let PAYMENT_OPTIONS_EMI_VIEW_CONTROLLER = "emiOptions"
    public static let PAYMENT_OPTIONS_JUSPAY_VIEW_CONTROLLER = "juspay"
    public static let PAYMENT_OPTIONS_VIEW_CONTROLLER  = "PaymentOptions"
    
    
    //ViewController Titles
    public static let NETBANKING_TITLE = "Choose your Bank"
    public static let WALLET_TITLE = "Choose your Wallet"
    public static let EMI_TITLE = "Choose your Credit Card"
    public static let UPI_TITLE = "Verify Payment"
    public static let EMI_CARD_TITLE = "EMI on Credit Card"
    public static let CREDI_CARD_TITLE = "Enter Credit Card Details"
    public static let DEBIT_CARD_TITLE = "Enter Debit Card Details"
    
    public static func getStoryboardInstance() -> UIStoryboard{
        let frameworkBundle = Bundle(identifier: "com.instamojo.ios.Instamojo")!
        return UIStoryboard(name: "InstamojoStoryboard", bundle: frameworkBundle)
    }
}
