//
//  InstamojoTests.swift
//  InstamojoTests
//
//  Created by Sukanya Raj on 14/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import XCTest
@testable import Instamojo

class InstamojoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: Order Class Tests
    func testOrderValidationSucceeds() {
        let order = Order.init(authToken: "", transactionID: "2343543", buyerName: "Sukanya", buyerEmail: "sukanyadraj@gmail.com", buyerPhone: "9952620490", amount: "2434", description: "dfkdjfhgkjdfkjfkjfdsdfgdsjfk", webhook: "dfgkjdkjfgkdfs")
        XCTAssertNotNil(order)
        print(order.isValid().error)
    }

}
