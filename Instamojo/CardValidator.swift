//
//  CardValidator.swift
//  Instamojo
//
//  Created by Sukanya Raj on 07/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation

open class CardValidator {
    public enum CardType: Int {
        case amex = 0
        case visa
        case mastercard
        case discover
        case dinersClub
        case maestro
    }

    public enum CardError: Error {
        case unsupported
        case invalid
    }

    fileprivate class func regularExpression(for cardType: CardType) -> String {
        switch cardType {
        case .amex:
            return "^3[47][0-9]{5,}$"
        case .dinersClub:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .mastercard:
            return "^5[1-5][0-9]{5,}$"
        case .visa:
            return "^4[0-9]{6,}$"
        case .maestro:
            return "^(5018|5020|5038|6304|6759|676[1-3])"
        }
    }

    fileprivate class func cardLength(for cardType: CardType) -> Int {
        switch cardType {
        case .amex:
            return 15
        case .dinersClub:
            return 14
        case .discover:
            return 16
        case .mastercard:
            return 16
        case .visa:
            return 16
        case .maestro:
            return 19
        }
    }

    class func performLuhnAlgorithm(with cardNumber: String) throws {

        let formattedCardNumber = cardNumber.formattedCardNumber()

        guard formattedCardNumber.count >= 9 else {
            throw CardError.invalid
        }

        let originalCheckDigit = formattedCardNumber.last!
        let characters = formattedCardNumber.dropLast().reversed()

        var digitSum = 0

        for (idx, character) in characters.enumerated() {
            let value = Int(String(character)) ?? 0
            if idx % 2 == 0 {
                var product = value * 2

                if product > 9 {
                    product -= 9
                }

                digitSum += product
            } else {
                digitSum += value
            }
        }

        digitSum *= 9

        let computedCheckDigit = digitSum % 10

        let originalCheckDigitInt = Int(String(originalCheckDigit))
        let valid = originalCheckDigitInt == computedCheckDigit

        if valid == false {
            throw CardError.invalid
        }
    }

    class func cardType(for cardNumber: String) throws -> CardType {
        var foundCardType: CardType?
        let formattedCardNumber = cardNumber.formattedCardNumber()

        for i in CardType.amex.rawValue...CardType.maestro.rawValue {
            let cardType = CardType(rawValue: i)!
            let regex = regularExpression(for: cardType)

            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

            if predicate.evaluate(with: formattedCardNumber) == true {
                foundCardType = cardType
                break
            }
        }

        if foundCardType == nil {
            throw CardError.invalid
        }

        return foundCardType!
    }
}

public extension CardValidator.CardType {
    func stringValue() -> String {
        switch self {
        case .amex:
            return "American Express"
        case .visa:
            return "Visa"
        case .mastercard:
            return "Mastercard"
        case .discover:
            return "Discover"
        case .dinersClub:
            return "Diner's Club"
        case .maestro :
            return "Maestro"
        }
    }

    init?(string: String) {
        switch string.lowercased() {
        case "american express":
            self.init(rawValue: 0)
        case "visa":
            self.init(rawValue: 1)
        case "mastercard":
            self.init(rawValue: 2)
        case "discover":
            self.init(rawValue: 3)
        case "diner's club":
            self.init(rawValue: 4)
        case "maestro":
            self.init(rawValue: 5)
        default:
            return nil
        }
    }

}

public extension String {
    public func isValidCardNumber() -> Bool {
        do {
            try CardValidator.performLuhnAlgorithm(with: self)
            return true
        } catch {
            return false
        }
    }

    public func cardType() -> CardValidator.CardType? {
        let cardType = try? CardValidator.cardType(for: self)
        return cardType
    }

    public func validLength() -> Int {
        let cardType = try? CardValidator.cardType(for: self)
        return CardValidator.cardLength(for: cardType!)
    }

    public func formattedCardNumber() -> String {
        let numbersOnlyEquivalent = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        return numbersOnlyEquivalent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    var length: String { return String(count)   }

    var pairs: [String] {
        var result = [String]()
        let chars = Array(self)
        for index in stride(from:0, to: chars.count, by: 4) {
            result.append(String(chars[index..<min(index + 4, chars.count)]))
        }
        return result
    }

    var expiryDate: [String] {
        var result = [String]()
        let chars = Array(self)
        for index in stride(from:0, to: chars.count, by: 2) {
            result.append(String(chars[index..<min(index + 2, chars.count)]))
        }
        return result
    }

    var amountFormatter: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: Float(self)!))!
    }

    func validDate() -> Bool {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/YY"

        let myDate = dateFormatter.date(from: self)

        if NSDate().compare(myDate!) == ComparisonResult.orderedDescending {
            return false
        } else {
            return true
        }
    }

}
