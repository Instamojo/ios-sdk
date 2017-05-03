//
//  UPISubmissionResponse.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class UPISubmissionResponse: NSObject {

    public var paymentID: String
    public var statusCode: Int
    public var payerVirtualAddress: String
    public var payeeVirtualAddress: String
    public var statusCheckURL: String
    public var upiBank: String
    public var statusMessage: String

    override init() {
        self.paymentID = ""
        self.statusCode = 0
        self.payeeVirtualAddress = ""
        self.payerVirtualAddress = ""
        self.statusCheckURL = ""
        self.upiBank = ""
        self.statusMessage = ""
    }

    public init(paymentID: String, statusCode: Int, payerVirtualAddress: String, payeeVirtualAddress: String, statusCheckURL: String, upiBank: String, statusMessage: String) {
        self.paymentID = paymentID
        self.statusCode = statusCode
        self.payerVirtualAddress = payerVirtualAddress
        self.payeeVirtualAddress = payeeVirtualAddress
        self.statusCheckURL = statusCheckURL
        self.upiBank = upiBank
        self.statusMessage = statusMessage
    }
}
