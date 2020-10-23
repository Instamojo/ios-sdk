//
//  UPICallBack.swift
//  Instamojo
//
//  Created by Sukanya Raj on 22/02/17.
//  Edited by Vaibhav Bhasin on 4/10/19
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation

@objc public protocol UPICallBack {
    func onSubmission(upiSubmissionResponse: UPISubmissionResponse, exception: String)

    func onStatusCheckComplete(paymentComplete: Bool, status: Int)
}
