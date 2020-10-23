//
//  Wallet.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Edited by Vaibhav Bhasin on 4/10/19
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class Wallet: NSObject {

    public var name: String
    public var imageUrl: String
    public var walletID: String

    override init() {
        self.name = ""
        self.imageUrl = ""
         self.walletID = ""
    }

    public init(name: String, imageUrl: String, walletID: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.walletID = walletID
    }

}
