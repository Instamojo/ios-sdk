//
//  JuspayRequestCallBack.swift
//  Instamojo
//
//  Created by Sukanya Raj on 21/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

@objc public protocol JuspayRequestCallBack {
   func onFinish(params: BrowserParams, error: String )
}
