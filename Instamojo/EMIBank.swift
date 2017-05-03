//
//  EMIBank.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class EMIBank: NSObject {
    public var bankName: String!
    public var bankCode: String!
    public var rate : [(key: Int, value: Int)]!

    public init(bankName: String, bankCode: String, rate : [(key: Int, value: Int)]) {
        self.bankName = bankName
        self.bankCode = bankCode
        self.rate = rate
    }
}
