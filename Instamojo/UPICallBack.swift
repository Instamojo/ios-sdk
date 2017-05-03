//
//  UPICallBack.swift
//  Instamojo
//
//  Created by Sukanya Raj on 22/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation

@objc public protocol UPICallBack {
    func onSubmission(upiSubmissionResponse: UPISubmissionResponse, exception: String)

    func onStatusCheckComplete(paymentComplete: Bool, status: Int)
}
