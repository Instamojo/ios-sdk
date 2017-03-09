//
//  PaymentOptionsView.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class PaymentOptionsView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var paymentOptionsTableView: UITableView!
    var order: Order!
    var paymentOptions: NSMutableArray = [Constants.NET_BANKING_OPTION, Constants.CREDIT_CARD_OPTION, Constants.DEBIT_CARD_OPTION, Constants.EMI_OPTION, Constants.WALLETS_OPTION, Constants.UPI_OPTION]

    var mainStoryboard: UIStoryboard = UIStoryboard()

    override func viewDidLoad() {
        super.viewDidLoad()
        paymentOptionsTableView.tableFooterView = UIView()
        mainStoryboard = Constants.getStoryboardInstance()
        self.reloadDataBasedOnOrder()
    }

    //Set payment options based on the order
    func reloadDataBasedOnOrder() {
        if order.netBankingOptions == nil {
            paymentOptions.remove(Constants.NET_BANKING_OPTION)
        }
        if order.cardOptions == nil {
            paymentOptions.remove(Constants.CREDIT_CARD_OPTION)
            paymentOptions.remove(Constants.DEBIT_CARD_OPTION)
        }
        if order.emiOptions == nil {
            paymentOptions.remove(Constants.EMI_OPTION)
        }
        if order.walletOptions == nil {
            paymentOptions.remove(Constants.WALLETS_OPTION)
        }
        if order.upiOptions == nil {
            paymentOptions.remove(Constants.UPI_OPTION)
        }
        paymentOptionsTableView.reloadData()

        //Until implementation is complete
         paymentOptions.remove(Constants.UPI_OPTION)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: Constants.PAYMENT_OPTIONS_CELL, for: indexPath)
        cell.textLabel?.text = paymentOptions.object(at: indexPath.row) as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowSelected = indexPath.row
        let options = paymentOptions.object(at: rowSelected) as! String
        switch options {
        case Constants.NET_BANKING_OPTION :
            onNetBankingSelected(options: options)
            break
        case Constants.CREDIT_CARD_OPTION :
            onCreditCardSelected()
            break
        case Constants.DEBIT_CARD_OPTION :
            onDebitCardSelected()
            break
        case Constants.EMI_OPTION :
            onEmiSelected(options : options)
            break
        case Constants.WALLETS_OPTION :
            onWalletSelected(options: options)
            break
        case Constants.UPI_OPTION :
            onUPISelected()
            break
        default:
            onCreditCardSelected()
            break
        }
    }

    func onNetBankingSelected(options: String) {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_LISTVIEW_CONTROLLER) as! ListOptionsView
        viewController.optionsFor = options
        viewController.order = order
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func onCreditCardSelected() {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_CARD_VIEW_CONTROLLER) as! CardFormView
        viewController.cardType = Constants.CREDIT_CARD
        viewController.order = self.order
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func onDebitCardSelected() {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_CARD_VIEW_CONTROLLER) as! CardFormView
        viewController.cardType = Constants.DEBIT_CARD
        viewController.order = self.order
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func onEmiSelected(options: String) {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_LISTVIEW_CONTROLLER) as! ListOptionsView
        viewController.optionsFor = options
        viewController.order = order
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func onWalletSelected(options: String) {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_LISTVIEW_CONTROLLER) as! ListOptionsView
        viewController.optionsFor = options
        viewController.order = order
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func onUPISelected() {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_UPI_VIEW_CONTROLLER) as! UPIPaymentView
        viewController.order = order
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
