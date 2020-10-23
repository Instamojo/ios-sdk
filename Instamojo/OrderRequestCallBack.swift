//
//  OrderRequestCallBack.swift
//  Instamojo
//
//  Created by Sukanya Raj on 21/02/17.
//  Edited by Vaibhav Bhasin on 4/10/19
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation

@objc public protocol OrderRequestCallBack {
    func onFinish(order: Order, error: String)
}
