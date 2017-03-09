//
//  UPICallBack.swift
//  Instamojo
//
//  Created by Sukanya Raj on 22/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation

protocol UPICallBack  {
    func onSubmission(upiSubmissionResponse : UPISubmissionResponse, exception : NSException)
    
    func onStatusCheckComplete( dictonary : NSDictionary, paymentComplete : Bool, exception : NSException)
}
