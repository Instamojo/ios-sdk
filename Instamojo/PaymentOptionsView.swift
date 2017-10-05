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
    var paymentOptions: NSMutableArray = [Constants.DebitCardOption, Constants.NetBankingOption, Constants.CreditCardOption, Constants.WalletsOption, Constants.EmiOption, Constants.UpiOption]
    var paymentCompleted : Bool = false;

    var mainStoryboard: UIStoryboard = UIStoryboard()
    var isBackButtonNeeded: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentOptionsTableView.tableFooterView = UIView()
        mainStoryboard = Constants.getStoryboardInstance()
        self.reloadDataBasedOnOrder()
        NotificationCenter.default.addObserver(self, selector: #selector(self.backToViewController), name: NSNotification.Name("INSTAMOJO"), object: nil)
        
        if(isBackButtonNeeded == false){
            let menu_button_ = UIBarButtonItem.init(title: "Exit", style: .plain, target: self, action:#selector(self.exitViewController))
            self.navigationItem.rightBarButtonItem = menu_button_
        }
    }
    
    @objc func exitViewController(){
        self.dismiss(animated: true, completion: nil)
    }

    
    @objc func backToViewController(){
        Logger.logDebug(tag: "Payment Done", message: "In Observer")
        paymentCompleted = true
    }

    //Set payment options based on the order
    func reloadDataBasedOnOrder() {
        if order.netBankingOptions == nil {
            paymentOptions.remove(Constants.NetBankingOption)
        }
        if order.cardOptions == nil {
            paymentOptions.remove(Constants.CreditCardOption)
            paymentOptions.remove(Constants.DebitCardOption)
        }
        if order.emiOptions == nil {
            paymentOptions.remove(Constants.EmiOption)
        }
        if order.walletOptions == nil {
            paymentOptions.remove(Constants.WalletsOption)
        }
        if order.upiOptions == nil {
            paymentOptions.remove(Constants.UpiOption)
        }
        paymentOptionsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.PaymentOptionsCell, for: indexPath)
        cell.textLabel?.text = paymentOptions.object(at: indexPath.row) as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowSelected = indexPath.row
        let options = paymentOptions.object(at: rowSelected) as? String
        switch options {
        case Constants.NetBankingOption? :
            DispatchQueue.main.async {
                self.onNetBankingSelected(options: options!)
            }
            break
        case Constants.CreditCardOption? :
            onCreditCardSelected()
            break
        case Constants.DebitCardOption? :
            onDebitCardSelected()
            break
        case Constants.EmiOption? :
            onEmiSelected(options : options!)
            break
        case Constants.WalletsOption? :
             DispatchQueue.main.async {
                self.onWalletSelected(options: options!)
             }
            break
        case Constants.UpiOption? :
            onUPISelected()
            break
        default:
            onCreditCardSelected()
            break
        }
    }

    func onNetBankingSelected(options: String) {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsListviewController) as? ListOptionsView {
            viewController.paymentOption = options
            viewController.order = order
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.value(forKey: "USER-CANCELLED-ON-VERIFY") != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                _ = self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "INSTAMOJO"), object: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if paymentCompleted {
            Logger.logDebug(tag: "Payment Done", message: "GO BACK")
            paymentCompleted = false
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    func onCreditCardSelected() {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsCardViewController) as? CardFormView {
            viewController.cardType = Constants.CreditCard
            viewController.order = self.order
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func onDebitCardSelected() {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsCardViewController) as? CardFormView {
            viewController.cardType = Constants.DebitCard
            viewController.order = self.order
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func onEmiSelected(options: String) {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsListviewController) as? ListOptionsView {
            viewController.paymentOption = options
            viewController.order = order
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func onWalletSelected(options: String) {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsListviewController) as? ListOptionsView {
            viewController.paymentOption = options
            viewController.order = order
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func onUPISelected() {
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsUpiViewController) as? UPIPaymentView {
            viewController.order = order
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

}
