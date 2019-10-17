//
//  ListOptionsView.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Edited by Vaibhav Bhasin on 4/10/19
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class ListOptionsView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var banksTableView: UITableView!
    var paymentOption: String!
    var order: Order!
    var mainStoryboard: UIStoryboard = UIStoryboard()
    var submissionURL: String!
    var netBanks: [NetBankingBanks]!
    var wallets: [Wallet]!
    var banks: [EMIBank]!

    var filteredEMIBanks = [EMIBank]()
    var filteredWallets = [Wallet]()
    var filteredNetBanks = [NetBankingBanks]()

    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        netBanks = [NetBankingBanks]()
        wallets = [Wallet]()
        banks = [EMIBank]()

        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            self.banksTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        banksTableView.tableFooterView = UIView()
        mainStoryboard = Constants.getStoryboardInstance()
        self.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            if paymentOption == Constants.WalletsOption {
                return filteredWallets.count
            } else if paymentOption == Constants.EmiOption {
                return filteredEMIBanks.count
            } else {
                return filteredNetBanks.count
            }
        } else {
            if paymentOption == Constants.WalletsOption {
                return wallets.count
            } else if paymentOption == Constants.EmiOption {
                return banks.count
            } else {
                return netBanks.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "options", for: indexPath)
         if self.resultSearchController.isActive {
            if paymentOption == Constants.WalletsOption {
                let wallet = filteredWallets[indexPath.row] as Wallet
                let walletName = wallet.name
                cell.textLabel?.text = walletName
            } else if paymentOption == Constants.EmiOption {
                let bank = filteredEMIBanks[indexPath.row] as EMIBank
                let bankName = bank.bankName
                cell.textLabel?.text = bankName
            } else {
                let bank = filteredNetBanks[indexPath.row] as NetBankingBanks
                let bankName = bank.bankName
                cell.textLabel?.text = bankName
            }
         } else {
            if paymentOption == Constants.WalletsOption {
                let wallet = wallets[indexPath.row] as Wallet
                let walletName = wallet.name
                cell.textLabel?.text = walletName
            } else if paymentOption == Constants.EmiOption {
                let bank = banks[indexPath.row] as EMIBank
                let bankName = bank.bankName
                cell.textLabel?.text = bankName
            } else {
                let bank = netBanks[indexPath.row] as NetBankingBanks
                let bankName = bank.bankName
                cell.textLabel?.text = bankName
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultSearchController.isActive {
            if paymentOption == Constants.EmiOption {
                let bank = filteredEMIBanks[indexPath.row] as EMIBank
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsEmiViewController) as! EMIOptionsView
                viewController.order = self.order
                viewController.selectedBank = bank
                self.navigationController?.pushViewController(viewController, animated: true)
            } else if paymentOption == Constants.NetBankingOption {
                let bank = filteredNetBanks[indexPath.row] as NetBankingBanks
                let postData = order.netBankingOptions.getPostData(accessToken: order.authToken!, bankCode: bank.bankCode)

                let browserParams = BrowserParams()
                browserParams.url = self.submissionURL
                browserParams.postData = postData
                browserParams.clientId = order.clientID
                browserParams.endUrlRegexes = Urls.getEndUrlRegex()

                self.startJuspayBrowser(params: browserParams)
            } else if paymentOption == Constants.WalletsOption {
                let wallet = filteredWallets[indexPath.row] as Wallet
                let walletID = wallet.walletID
                let postData = order.walletOptions.getPostData(accessToken: order.authToken!, walletID: walletID)
                let browserParams = BrowserParams()
                browserParams.url = self.submissionURL
                browserParams.clientId = order.clientID
                browserParams.postData = postData
                browserParams.endUrlRegexes = Urls.getEndUrlRegex()

                self.startJuspayBrowser(params: browserParams)
            }

        } else {
            if paymentOption == Constants.EmiOption {
                let bank = banks[indexPath.row] as EMIBank
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsEmiViewController) as! EMIOptionsView
                viewController.order = self.order
                viewController.selectedBank = bank
                self.navigationController?.pushViewController(viewController, animated: true)
            } else if paymentOption == Constants.NetBankingOption {
                let bank = netBanks[indexPath.row] as NetBankingBanks
                let postData = order.netBankingOptions.getPostData(accessToken: order.authToken!, bankCode: bank.bankCode)

                let browserParams = BrowserParams()
                browserParams.url = self.submissionURL
                browserParams.postData = postData
                browserParams.clientId = order.clientID
                browserParams.endUrlRegexes = Urls.getEndUrlRegex()

                self.startJuspayBrowser(params: browserParams)
            } else if paymentOption == Constants.WalletsOption {
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
    }

    func startJuspayBrowser(params: BrowserParams) {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsJuspayViewController) as! PaymentViewController
        viewController.params = params
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func setOptions() {
        switch paymentOption {
        case Constants.NetBankingOption:
            self.submissionURL = order.netBankingOptions.url
            self.netBanks = self.order.netBankingOptions.banks as [NetBankingBanks]
            self.title = Constants.NetbankingTitle
            break
        case Constants.WalletsOption :
            self.submissionURL = order.walletOptions.url
            self.wallets = order.walletOptions.wallets as [Wallet]
            self.title = Constants.WalletTitle
            break
        case Constants.EmiOption :
            self.submissionURL = order.emiOptions.url
            banks = order.emiOptions.emiBanks as [EMIBank]
            self.title = Constants.EmiTitle
            break
        default:
            Logger.logDebug(tag: "ListOptions", message: "Default Case")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = "Back"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setOptions()
        self.banksTableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        switch paymentOption {
        case Constants.NetBankingOption:
            self.filteredNetBanks.removeAll(keepingCapacity: false)
            self.filteredNetBanks = self.netBanks.filter({ (netBank) -> Bool in
                return netBank.bankName.lowercased().contains(searchText!.lowercased())
            })
            self.banksTableView.reloadData()
            break
        case Constants.WalletsOption :
            self.filteredWallets.removeAll(keepingCapacity: false)
            self.filteredWallets = self.wallets.filter({ (wallet) -> Bool in
                return wallet.name.lowercased().contains(searchText!.lowercased())
            })
            self.banksTableView.reloadData()
            break
        case Constants.EmiOption :
            self.filteredEMIBanks.removeAll(keepingCapacity: false)
            self.filteredEMIBanks = self.banks.filter({ (bank) -> Bool in
                return bank.bankName.lowercased().contains(searchText!.lowercased())
            })
            self.banksTableView.reloadData()
            break
        default:
            Logger.logDebug(tag: "ListOptions", message: "Default Case")
        }

    }

}
