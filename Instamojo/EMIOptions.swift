//
//  EMIOptions.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class EMIOptions : NSObject{

    var merchantID: String
    var orderID: String
    var url: String
    var emiBanks: [EMIBank]!
    var selectedBankCode: String!
    var selectedTenure: Int = -1

    override init() {
        self.merchantID = ""
        self.orderID = ""
        self.selectedTenure = -1
        self.url = ""
    }

    init(merchantID: String, orderID: String, url: String, emiBanks: [EMIBank]) {
        self.merchantID = merchantID
        self.orderID = orderID
        self.url = url
        self.emiBanks = emiBanks
    }

}
