//
//  NetBankingBanks.swift
//  Instamojo
//
//  Created by Sukanya Raj on 10/03/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation

public class NetBankingBanks: NSObject {

    public var bankName: String!
    public var bankCode: String!

    public init(bankName: String, bankCode: String) {
        self.bankName = bankName
        self.bankCode = bankCode
    }
}
