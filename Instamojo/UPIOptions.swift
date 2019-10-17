//
//  UPIOptions.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Edited by Vaibhav Bhasin on 4/10/19
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class UPIOptions: NSObject {

    public var url: String

    override init() {
        self.url = ""
    }

    public init(url: String) {
        self.url = url
    }
}
