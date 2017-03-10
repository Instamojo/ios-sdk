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
    var banks: [NetBankingBanks]!

    init(url: String, banks: [NetBankingBanks]) {
        self.url = url
        self.banks = banks
    }

    func getPostData(accessToken: String, bankCode: String) -> String {
        return "access_token=" + accessToken + "&bank_code=" + bankCode
    }

}
