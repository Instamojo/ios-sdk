//
//  Wallet.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class Wallet {

    var name: String
    var imageUrl: String
    var walletID: String

    init() {
        self.name = ""
        self.imageUrl = ""
         self.walletID = ""
    }

    init(name: String, imageUrl: String, walletID: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.walletID = walletID
    }

}
