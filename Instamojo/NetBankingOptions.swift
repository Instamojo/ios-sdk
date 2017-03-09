//
//  NetBankingOptions.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class NetBankingOptions {

    var url: String!
    var banks: NSDictionary!

    init(url: String, banks: NSDictionary) {
        self.url = url
        self.banks = banks
    }

    func getPostData(accessToken: String, bankCode: String) -> String {
        return "access_token=" + accessToken + "&bank_code=" + bankCode
    }

    func toString() -> String {
        return "URL " + self.url + "Banks " + String(describing: self.banks.allKeys)
    }
}
