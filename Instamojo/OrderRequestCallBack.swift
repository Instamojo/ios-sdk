//
//  OrderRequestCallBack.swift
//  Instamojo
//
//  Created by Sukanya Raj on 21/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation

public protocol OrderRequestCallBack {
    func onFinish(order : Order, error : String)
}
