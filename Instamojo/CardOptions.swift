//
//  CardOptions.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class CardOptions {
    var orderID: String
    var url: String
    var merchantID: String

    init() {
        self.orderID = ""
        self.url = ""
        self.merchantID = ""
    }

    init(orderID: String, url: String, merchantID: String) {
        self.orderID = orderID
        self.url = url
        self.merchantID = merchantID
    }

    func toString() -> String {
        return " Order ID - " + self.orderID + " URL -" + self.url + "MerchantID -" + merchantID
    }
}
