//
//  UPIPaymentView.swift
//  Instamojo
//
//  Created by Sukanya Raj on 07/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class UPIPaymentView: UIViewController {

    @IBOutlet weak var alertMessageView: UIView!
    @IBOutlet weak var vpaDetailsView: UIView!
    @IBOutlet weak var vpa: UITextField!
    var order: Order!

    override func viewDidLoad() {
        super.viewDidLoad()
        let verifyPaymentButton = UIBarButtonItem(
            title: Constants.UPI_TITLE,
            style: .plain,
            target: self,
            action: #selector(verifyPayment(sender:))
        )
        self.navigationItem.setRightBarButton(verifyPaymentButton, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func verifyPayment(sender: UIBarButtonItem) {
        self.vpaDetailsView.isHidden = true
        self.alertMessageView.isHidden = false
        self.title = Constants.UPI_TITLE
        self.navigationItem.rightBarButtonItem = nil
    }
}
