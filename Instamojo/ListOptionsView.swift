//
//  ListOptionsView.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class ListOptionsView : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var banksTableView: UITableView!
    var optionsFor : String!
    var order : Order!
    var options : [String]!
    var netBankingOptions : NSDictionary!
    var mainStoryboard: UIStoryboard = UIStoryboard()
    var submissionURL : String!
    var wallets : [Wallet]!
    var banks : [EMIBank]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOptions()
        banksTableView.tableFooterView = UIView()
        mainStoryboard = Constants.getStoryboardInstance()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if optionsFor == Constants.WALLETS_OPTION{
            return wallets.count
        }else if optionsFor == Constants.EMI_OPTION{
            return banks.count
        }else {
            return options.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "options", for: indexPath);
        if optionsFor == Constants.WALLETS_OPTION{
            let wallet = wallets[indexPath.row] as Wallet
            let walletName = wallet.name
            cell.textLabel?.text = walletName
        } else if optionsFor == Constants.EMI_OPTION{
            let bank = banks[indexPath.row] as EMIBank
            let bankName = bank.bankName
            cell.textLabel?.text = bankName
        }else{
            cell.textLabel?.text = options[indexPath.row]
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if optionsFor == Constants.EMI_OPTION {
            let bank = banks[indexPath.row] as EMIBank
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_EMI_VIEW_CONTROLLER) as! EMIOptionsView
            viewController.order = self.order
            viewController.selectedBank = bank
            self.navigationController?.pushViewController(viewController, animated: true)
        }else if optionsFor == Constants.NET_BANKING_OPTION {
            let selectedBank = options[indexPath.row]
            let bankCode = netBankingOptions.value(forKey: selectedBank) as! String
            let postData = order.netBankingOptions.getPostData(accessToken: order.authToken!, bankCode: bankCode)
            
            let browserParams = BrowserParams()
            browserParams.url = self.submissionURL
            browserParams.postData = postData
            browserParams.clientId = order.clientID
            browserParams.endUrlRegexes = Urls.getEndUrlRegex()
            
            self.startJuspayBrowser(params: browserParams)
        }else if optionsFor == Constants.WALLETS_OPTION {
            let wallet = wallets[indexPath.row] as Wallet
            let walletID = wallet.walletID
            let postData = order.walletOptions.getPostData(accessToken: order.authToken!, walletID: walletID)
            let browserParams = BrowserParams()
            browserParams.url = self.submissionURL
            browserParams.clientId = order.clientID
            browserParams.postData = postData
            browserParams.endUrlRegexes = Urls.getEndUrlRegex()
            
            self.startJuspayBrowser(params: browserParams)
        }
    }
    
    func startJuspayBrowser(params : BrowserParams){
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_JUSPAY_VIEW_CONTROLLER) as! JuspayBrowser
        viewController.params = params;
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setOptions(){
        switch optionsFor {
        case Constants.NET_BANKING_OPTION:
            self.submissionURL = order.netBankingOptions.url
            self.netBankingOptions = order.netBankingOptions.banks
            options = self.netBankingOptions.allKeys as! [String]
            self.title = Constants.NETBANKING_TITLE
            break
        case Constants.WALLETS_OPTION :
            self.submissionURL = order.walletOptions.url
            self.wallets = order.walletOptions.wallets as [Wallet]
            self.title = Constants.WALLET_TITLE
            break
        case Constants.EMI_OPTION :
            self.submissionURL = order.emiOptions.url
            banks = order.emiOptions.emiBanks as [EMIBank]
            self.title = Constants.EMI_TITLE
            break
        default:
            options = [];
            self.title = Constants.EMI_TITLE
        }
    }
    
    
    
}
