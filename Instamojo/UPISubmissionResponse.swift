//
//  UPISubmissionResponse.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class UPISubmissionResponse {

    var paymentID: String
    var statusCode: Int
    var payerVirtualAddress: String
    var payeeVirtualAddress: String
    var statusCheckURL: String
    var upiBank: String
    var statusMessage: String

    init() {
        self.paymentID = ""
        self.statusCode = 0
        self.payeeVirtualAddress = ""
        self.payerVirtualAddress = ""
        self.statusCheckURL = ""
        self.upiBank = ""
        self.statusMessage = ""
    }

    init(paymentID: String, statusCode: Int, payerVirtualAddress: String, payeeVirtualAddress: String, statusCheckURL: String, upiBank: String, statusMessage: String) {
        self.paymentID = paymentID
        self.statusCode = statusCode
        self.payerVirtualAddress = payerVirtualAddress
        self.payeeVirtualAddress = payeeVirtualAddress
        self.statusCheckURL = statusCheckURL
        self.upiBank = upiBank
        self.statusMessage = statusMessage
    }
}
