//
//  EMIBank.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class EMIBank {
    var bankName : String!
    var bankCode : String!
    var rate : [(key: Int, value: Int)]!

    
    init(bankName : String, bankCode : String, rate : [(key: Int, value: Int)]){
        self.bankName = bankName
        self.bankCode = bankCode
        self.rate = rate
    }
}
