//
//  JuspayRequestCallBack.swift
//  Instamojo
//
//  Created by Sukanya Raj on 21/02/17.
//  Edited by Vaibhav Bhasin on 4/10/19
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

@objc public protocol JuspayRequestCallBack {
   func onFinish(params: BrowserParams, error: String )
}
