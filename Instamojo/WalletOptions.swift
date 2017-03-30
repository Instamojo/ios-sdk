//
//  WalletOptions.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class WalletOptions : NSObject{

    public var url: String!
    public var wallets: [Wallet]!

    public init(url: String, wallets: [Wallet]) {
        self.url = url
        self.wallets = wallets
    }

    public func getPostData(accessToken: String, walletID: String) -> String {
        return "access_token=" + accessToken + "&wallet_id=" + walletID
    }
}
