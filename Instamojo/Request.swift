//
//  Request.swift
//  Instamojo
//
//  Created by Sukanya Raj on 20/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class Request {
    
   
    var order : Order?
    var mode : Mode
    var orderID : String?
    var accessToken : String?
    var card : Card?
    var virtualPaymentAddress : String?
    var upiSubmissionResponse : UPISubmissionResponse?
    var orderRequestCallBack : OrderRequestCallBack?
    var juspayRequestCallBack : JuspayRequestCallBack?

    
    public enum Mode {
        case OrderCreate
        case FetchOrder
        case Juspay
        case UPISubmission
        case UPIStatusCheck
    }
    
    /**
     * Network Request to create an order ID from Instamojo server.
     *
     * @param order                Order model with all the mandatory fields set.
     * @param orderRequestCallBack Callback interface for the Asynchronous Network Call.
     */
    public init(order : Order, orderRequestCallBack : OrderRequestCallBack) {
        self.mode = Mode.OrderCreate
        self.order = order
        self.orderRequestCallBack = orderRequestCallBack
    }
    
    /**
     * Network Request to get order details from Juspay for JuspaySafeBrowser.
     *
     * @param order                 Order model with all the mandatory fields set.
     * @param card                  Card with all the proper validations done.
     * @param jusPayRequestCallback Callback for Asynchronous network call.
     */
    init(order : Order, card : Card, jusPayRequestCallBack : JuspayRequestCallBack) {
        self.mode = Mode.Juspay
        self.order = order
        self.card = card
        self.juspayRequestCallBack = jusPayRequestCallBack
    }
    
    /**
     * Network request for UPISubmission Submission
     *
     * @param order                 {@link Order}
     * @param virtualPaymentAddress String
     * @param upiCallback           {@link UPICallback}
     */
    init(order : Order, virtualPaymentAddress : String, upiCallBack : UPICallBack) {
        self.mode = Mode.UPISubmission
        self.order = order
        self.virtualPaymentAddress = virtualPaymentAddress
    }
    
    /**
     * Network Request to check the status of the transaction
     *
     * @param order                 {@link Order}
     * @param upiSubmissionResponse {@link UPISubmissionResponse}
     * @param upiCallback           {@link UPICallback}
     */
    init(order : Order, upiSubmissionResponse : UPISubmissionResponse, upiCallback : UPICallBack ) {
        self.mode = Mode.UPIStatusCheck
        self.order = order
        self.upiSubmissionResponse = upiSubmissionResponse
    }
    
    /**
     * Network request to fetch the order
     * @param accessToken           String
     * @param orderID               String
     * @param orderRequestCallBack  {@link OrderRequestCallBack}
     */
    init(orderID : String, accessToken : String, orderRequestCallBack : OrderRequestCallBack ) {
        self.mode = Mode.FetchOrder
        self.orderID = orderID
        self.accessToken = accessToken
        self.virtualPaymentAddress = ""
        self.upiSubmissionResponse = UPISubmissionResponse.init()
    }
    
    public func execute(){
        switch self.mode {
        case Mode.OrderCreate:
            createOrder()
            break
        case Mode.FetchOrder:
            fetchOrder()
            break
        case Mode.Juspay:
            juspayRequest()
            break
        case Mode.UPISubmission:
            executeUPIRequest()
            break
        case Mode.UPIStatusCheck:
            upiStatusCheck()
            break
        }
    }
    
    func createOrder(){
        let url : String = Urls.getOrderCreateUrl()
        
        let params : [String: Any] = ["name": order!.buyerName!, "email": order!.buyerEmail!, "amount" : order!.amount!,"description" : order!.description! ,"phone" : order!.buyerPhone!,"currency": order!.currency!,"transaction_id" : order!.transactionID!,"redirect_url" : order!.redirectionUrl!,"advanced_payment_options" : "true", "mode" : order!.mode!, "webhook_url" : order!.webhook!]
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        request.addValue(getUserAgent(), forHTTPHeaderField: "User-Agent")
        request.addValue("Bearer " + order!.authToken!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if error == nil{
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as?  [String:Any] {
                        if jsonResponse["payment_options"] != nil{
                            //Payment Options Recieved 
                            self.updateTransactionDetails(jsonResponse: jsonResponse)
                            self.orderRequestCallBack?.onFinish(order: self.order!, error: "")
                        }else{
                            if jsonResponse["error"] != nil {
                                let errorMessage = jsonResponse["error"] as! String
                                self.orderRequestCallBack?.onFinish(order: self.order!, error: errorMessage)
                            }else {
                                if jsonResponse["success"] != nil{
                                    let success = jsonResponse["success"] as! Bool
                                    if success {
                                        Logger.logDebug(tag: " Create-Order-SerialisedResponse", message: "Response: \(jsonResponse)")
                                    }else{
                                        self.orderRequestCallBack?.onFinish(order: self.order!, error: jsonResponse["message"] as! String)
                                    }
                                }else{
                                      Logger.logDebug(tag: " Create-Order-SerialisedResponse", message: "Response: \(jsonResponse)")
                                }
                            }
                        }
                    }
                } catch {
                    Logger.logError(tag: "Caught Exception", message: String(describing: error))
                    self.orderRequestCallBack?.onFinish(order: self.order!, error: String(describing: error))
                }
            }else{
                print(error!.localizedDescription)
            }
        })

        task.resume()
    }
    
    func updateTransactionDetails(jsonResponse : [String:Any]){
        //update order details
        let orders = jsonResponse["order"] as! [String:Any]
        self.order!.id = orders["id"] as? String
        self.order!.transactionID = orders["transaction_id"] as? String
        self.order!.resourceURI = orders["resource_uri"] as? String
        
        //update payment_options
        let paymentOptions = jsonResponse["payment_options"] as! [String:Any]
        
        //card_options of this order
        if paymentOptions["card_options"] != nil {
            let card_options = paymentOptions["card_options"] as! [String:Any]
            let submissionData = card_options["submission_data"] as! [String : Any]
            
            let merchandID = submissionData["merchant_id"] as! String
            let orderID = submissionData["order_id"] as! String
            let submission_url = card_options["submission_url"] as! String
        
            let cardOptions = CardOptions(orderID: orderID, url: submission_url, merchantID: merchandID)
            self.order!.cardOptions = cardOptions
        }
        
        //netbanking_options of this order
        if paymentOptions["netbanking_options"] != nil {
            let netbanking_options = paymentOptions["netbanking_options"] as! [String:Any]
            let submission_url = netbanking_options["submission_url"] as! String
            let choicesArray = netbanking_options["choices"] as! [[String: Any]]
            let choices : NSMutableDictionary = NSMutableDictionary()
            for i in 0 ..< choicesArray.count{
                let bank_name = choicesArray[i]["name"] as! String
                let bank_code = choicesArray[i]["id"] as! String
                choices.setValue(bank_code, forKey: bank_name)
            }
            if choices.count > 0 {
                self.order!.netBankingOptions = NetBankingOptions(url: submission_url, banks: choices)
                Logger.logDebug(tag: "NetBanking Options", message: self.order!.netBankingOptions.toString())
            }
        }
        
        //emi_options of this order
        if paymentOptions["emi_options"] != nil {
            let emi_options = paymentOptions["emi_options"] as! [String: Any]
            let emi_list = emi_options["emi_list"] as! [[String : Any]]
            let submission_url =  emi_options["submission_url"] as! String
            var emis : [EMIBank]!
            for i in 0 ..< emi_list.count{
                let bank_name = emi_list[i]["bank_name"] as! String
                let bank_code = emi_list[i]["bank_code"] as! String
                var rates = [Int : Int]()
                let ratesRaw = emi_list[i]["rates"] as! [[String : Any]]
                for j in 0 ..< ratesRaw.count{
                    let tenure = ratesRaw[j]["tenure"] as! Int
                    let interest = ratesRaw[j]["interest"] as! Int
                    rates.updateValue(interest, forKey: tenure)
                }
                
                let sortedRates = rates.sorted(by: { $0.0 < $1.0 })
                
                if rates.count > 0 {
                    let emiBank = EMIBank(bankName: bank_name, bankCode: bank_code, rate: sortedRates)
                    emis.append(emiBank)
                }
            }
            let submissionData = emi_options["submissionData"] as! [String : Any]
            let merchantID = submissionData["merchant_id"] as! String
            let orderID = submissionData["order_id"] as! String
            if emis.count > 0 {
                self.order?.emiOptions = EMIOptions(merchantID: merchantID, orderID: orderID, url: submission_url, emiBanks: emis)
            }
            
        }
        
        //wallet_options of this order
        if paymentOptions["wallet_options"] != nil {
            let wallet_options = paymentOptions["wallet_options"] as! [String: Any]
            let submission_url = wallet_options["submission_url"] as! String
            let choicesArray = wallet_options["choices"] as! [[String: Any]]
            var wallets = [Wallet]()
            for i in 0 ..< choicesArray.count{
                let name = choicesArray[i]["name"] as! String
                let walletID = choicesArray[i]["id"] as! Int
                let walletImage = choicesArray[i]["image"] as! String
                wallets.append(Wallet(name: name, imageUrl: walletImage, walletID: String(walletID)))
            }
            if wallets.count > 0 {
                self.order?.walletOptions = WalletOptions(url: submission_url, wallets: wallets)
            }
        }
        
        //upi_options of this order
        if paymentOptions["upi_options"] != nil{
            let upi_options = paymentOptions["upi_options"] as! [String: Any]
            self.order?.upiOptions = UPIOptions(url: upi_options["submission_url"] as! String)
        }
    }
    
    func sortRates(values:[Int]) -> [Int]{
        
        let sortedValues = values.sorted(by: { (value1, value2) -> Bool in
            
            if (value1 < value2) {
                return true
            } else {
                return false
            }
        })
        return sortedValues
    }
    
    func fetchOrder(){
        let url : String = Urls.getOrderFetchURL(orderID: self.orderID!)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        request.addValue(getUserAgent(), forHTTPHeaderField: "User-Agent")
        request.addValue("Bearer " + order!.authToken!, forHTTPHeaderField: "Authorization")
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")})
        task.resume()
    }
    
    func juspayRequest(){

        Logger.logDebug(tag: "Card Options", message: (self.order?.cardOptions.toString())!)
        let url : String = self.order!.cardOptions.url
        let session = URLSession.shared
        
        var params = ["order_id": self.order!.cardOptions.orderID, "merchant_id": self.order!.cardOptions.merchantID , "payment_method_type" : "Card","card_number" : self.card!.cardNumber ,"name_on_card" : self.card!.cardHolderName,"card_exp_month": self.card!.getExpiryMonth() ,"card_exp_year" : self.card!.getExpiryYear(),"card_security_code" : self.card!.cvv,"save_to_locker" : self.card!.savedCard ? "true" : "false", "redirect_after_payment" : "true", "format" : "json"] as [String : Any]
        
        if self.order!.emiOptions != nil {
            params.updateValue("true", forKey: "is_emi")
            params.updateValue(self.order!.emiOptions.selectedBankCode, forKey :"emi_bank")
            params.updateValue(self.order!.emiOptions.selectedTenure , forKey: "emi_tenure")
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.setBodyContent(parameters: params)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            Logger.logDebug(tag: " Create-Order-Response", message: String(describing: response))
            if error == nil{
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as?  [String:Any] {
                            if jsonResponse["payment"] != nil{
                            let payment = jsonResponse["payment"] as! [String : Any]
                            let authentication = payment["authentication"] as! [String : Any]
                            let url = authentication["url"] as! String
                            let orderID = jsonResponse["order_id"] as! String
                            let txn_id = jsonResponse["txn_id"] as! String
                            
                            let browserParams = BrowserParams()
                            browserParams.url = url
                            browserParams.orderId = orderID
                            browserParams.clientId = self.order?.cardOptions.merchantID
                            browserParams.merchantId = self.order?.cardOptions.merchantID
                            browserParams.transactionId = txn_id
                            browserParams.endUrlRegexes = Urls.getEndUrlRegex()
                            
                            self.juspayRequestCallBack?.onFinish(params: browserParams, error: "")
                        }
                    }
                } catch {
                    Logger.logError(tag: "Caught Exception", message: String(describing: error))
                }
            }else{
                print(error!.localizedDescription)
            }
        })

        task.resume()
    }
    
    func executeUPIRequest(){
        let url : String = self.order!.upiOptions.url
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        let session = URLSession.shared
        
        let params = ["virtual_address": self.virtualPaymentAddress!] as NSMutableDictionary
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue(getUserAgent(), forHTTPHeaderField: "User-Agent")
        request.addValue("Bearer " + order!.authToken!, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")})
        task.resume()

    }
    
    func upiStatusCheck(){
        let url : String = self.upiSubmissionResponse!.statusCheckURL
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        request.addValue(getUserAgent(), forHTTPHeaderField: "User-Agent")
        request.addValue("Bearer " + order!.authToken!, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")})
        task.resume()

    }
    
    
    func getUserAgent() -> String {
        let versionName : String = Bundle.main.infoDictionary?["CFBundleVersion"] as! String + ";"
        let versionCode : String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let appID = Bundle.main.bundleIdentifier! + ";"
        return  "Instamojo IOS SDK;" + UIDevice.current.model + ";" + "Apple;" + UIDevice.current.systemVersion + ";" + appID + versionName + versionCode
     }
    
    
}

public extension NSMutableURLRequest{
    func setBodyContent(parameters: [String : Any]) {
        let parameterArray = parameters.map { (key, value) -> String in
            return "\(key)=\((value as AnyObject))"
        }
        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}

