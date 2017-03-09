//
//  Card.swift
//  Instamojo
//
//  Created by Sukanya Raj on 15/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class Card {
    
    var cardHolderName : String
    var cardNumber : String
    var date : String
    var cvv : String
    var savedCard : Bool
    
    init() {
        self.cardNumber = ""
        self.cvv = ""
        self.date = ""
        self.cardHolderName = ""
        self.savedCard = false
    }
    
    init(cardHolderName : String, cardNumber : String, date : String, cvv : String, savedCard : Bool) {
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.date = date
        self.cvv = cvv
        self.savedCard = savedCard
    }
    
    func getExpiryMonth() -> String{
        return self.date.components(separatedBy: "/")[0]
    }
    
    func getExpiryYear() -> String{
        return self.date.components(separatedBy: "/")[1]

    }
}
