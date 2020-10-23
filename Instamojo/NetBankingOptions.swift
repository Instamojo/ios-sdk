//
//  NetBankingOptions.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Edited by Vaibhav Bhasin on 4/10/19
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class NetBankingOptions: NSObject {

    public var url: String!
    public var banks: [NetBankingBanks]!

    init(url: String, banks: [NetBankingBanks]) {
        self.url = url
        self.banks = banks
    }

    public func getPostData(accessToken: String, bankCode: String) -> String {
        return "access_token=" + accessToken + "&bank_code=" + bankCode
    }

}
