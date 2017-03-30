//
//  Card.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

public class Card : NSObject{

    public var cardHolderName: String
    public var cardNumber: String
    public var date: String
    public var cvv: String
    public var savedCard: Bool

    override init() {
        self.cardNumber = ""
        self.cvv = ""
        self.date = ""
        self.cardHolderName = ""
        self.savedCard = false
    }

    public init(cardHolderName: String, cardNumber: String, date: String, cvv: String, savedCard: Bool) {
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.date = date
        self.cvv = cvv
        self.savedCard = savedCard
    }

    public func getExpiryMonth() -> String {
        return self.date.components(separatedBy: "/")[0]
    }

    public func getExpiryYear() -> String {
        return self.date.components(separatedBy: "/")[1]

    }
    
    public func isValidCard() -> Bool {
        return isValidCVV() && isValidDate() && isValidCardNumber() && isValidCardHolderName()
    }
    
    public func isValidCardNumber() -> Bool {
        return self.cardNumber.isValidCardNumber() && self.cardNumber.validLength() != self.cardNumber.characters.count
    }
    
    public func isValidCardHolderName() -> Bool{
        if self.cardHolderName.isEmpty {
            return false
        }else{
            return true
        }
    }
    
    public func isValidDate() -> Bool {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let currentYear =  components.year
        let month = getExpiryMonth()
        let year = getExpiryYear()
        
        if Int(month)! > 12 || Int(year)! < currentYear!{
            return false
        }else{
            return false
        }
    }
    
    public func isValidCVV() -> Bool{
        if self.cvv.isEmpty{
            return false
        }else{
            return true
        }
    }
    
}
