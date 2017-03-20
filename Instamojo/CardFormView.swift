//
//  CardFormView.swift
//  Instamojo
//
//  Created by Sukanya Raj on 07/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class CardFormView: UIViewController, UITextFieldDelegate, JuspayRequestCallBack {

    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet var expiryPickerView: MonthYearPickerView!

    @IBOutlet var cardNumberErrorLable: UILabel!
    @IBOutlet var cardNumberDivider: UIView!
    @IBOutlet var nameDivider: UIView!
    @IBOutlet var nameErrorLable: UILabel!
    @IBOutlet var expiryDateDivider: UIView!
    @IBOutlet var expiryDateErrorLable: UILabel!
    @IBOutlet var cvvDivider: UIView!
    @IBOutlet var cvvErrorLable: UILabel!
    
    var order: Order!
    var cardType: Int = 0
    var amountToBePayed: Float = 0
    var spinner: Spinner!
    var textField: UITextField!
    var invalidEntries: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountToBePayed =  Float(order.amount!)!
        initUI()
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self, action: #selector(doneButton_Clicked(sender:)))
        toolbarDone.items = [barBtnDone]
        cardNumberTextField.inputAccessoryView = toolbarDone
        expiryDateTextField.inputAccessoryView = toolbarDone
        expiryDateTextField.inputView = expiryPickerView
        expiryPickerView.removeFromSuperview()
        expiryPickerView.onDateSelected = { (month: Int, year: Int) in
            let date = String(format: Constants.DateFormat, month, year)
            self.expiryDateTextField.text = date
        }
        cvvTextField.inputAccessoryView = toolbarDone
        spinner = Spinner(text: Constants.SpinnerText)
        spinner.hide()
        self.view.addSubview(spinner)
        self.textField = cardNumberTextField
    }

    //Click listener on the Done button on top of the keyboard
    func doneButton_Clicked(sender: UIBarButtonItem) {
        if cardNumberTextField.isEditing {
            cardNumberTextField.resignFirstResponder()
            self.textField = nameTextField
            nameTextField.becomeFirstResponder()
        } else if expiryDateTextField.isEditing {
            expiryDateTextField.resignFirstResponder()
            self.textField = cvvTextField
            cvvTextField.becomeFirstResponder()
        } else if cvvTextField.isEditing {
            cvvTextField.resignFirstResponder()
        }
        validateEntries()
    }

    //Prepare the card object for a juspay request
    func prepareCheckOut() {
        let cardHolderName = nameTextField.text
        let cardNumber = cardNumberTextField.text
        let expiryDate = expiryDateTextField.text
        let cvv = cvvTextField.text
        let card = Card(cardHolderName: cardHolderName!, cardNumber: cardNumber!, date: expiryDate!, cvv: cvv!, savedCard: false)
        self.checkOutCard(card: card)
    }

    //A juspay request using Card object
    func checkOutCard(card: Card) {
        self.textField.resignFirstResponder()
        spinner.show()
        let request = Request(order: self.order, card: card, jusPayRequestCallBack: self)
        request.execute()
    }

    //Valiated the data entered
    func validateEntries() {
        let cardNumber = cardNumberTextField?.text
        let name = nameTextField?.text
        var error : String = ""
        if !cardNumberTextField.isEditing {
            if (cardNumber?.isEmpty)! {
                invalidEntries = true
                error = Constants.EmptyCardNumer
                cardNumberErrorLable.isHidden = false
                cardNumberErrorLable.text = Constants.EmptyCardNumer
                cardNumberDivider.backgroundColor = .red
            } else {
                let isValid = cardNumber?.isValidCardNumber()
                if !isValid! {
                    error = Constants.InvalidCardNumber
                    cardNumberErrorLable.isHidden = false
                    cardNumberErrorLable.text = Constants.InvalidCardNumber
                    cardNumberDivider.backgroundColor = .red
                    cardNumberTextField.textColor = .red
                } else {
                    cardNumberErrorLable.isHidden = true
                    cardNumberDivider.backgroundColor = .groupTableViewBackground
                    cardNumberTextField.textColor = .black
                    error += ""
                }
            }
        } else {
            cardNumberErrorLable.isHidden = true
            cardNumberDivider.backgroundColor = .groupTableViewBackground
            error += ""
        }

        if !nameTextField.isEditing {
            if (name?.isEmpty)! {
                error += Constants.EmptyCardHolderName
                nameErrorLable.isHidden = false
                nameErrorLable.text = Constants.EmptyCardHolderName
                nameDivider.backgroundColor = .red
            }else{
                nameErrorLable.isHidden = true
                nameDivider.backgroundColor = .groupTableViewBackground
                error += ""
            }
        } else {
            nameErrorLable.isHidden = true
            nameDivider.backgroundColor = .groupTableViewBackground
            error += ""
        }
        
        if !(name?.isEmpty)! && !(cardNumber?.isEmpty)! {
            if !expiryDateTextField.isEditing{
                let expiryDate = expiryDateTextField.text
                if (expiryDate?.isEmpty)! {
                    error += Constants.EmptyExpiryDate
                    expiryDateErrorLable.isHidden = false
                    expiryDateErrorLable.text = Constants.EmptyExpiryDate
                    expiryDateDivider.backgroundColor = .red
                }else{
                    expiryDateErrorLable.isHidden = true
                    expiryDateDivider.backgroundColor = .groupTableViewBackground
                }
            }else {
                expiryDateErrorLable.isHidden = true
                expiryDateDivider.backgroundColor = .groupTableViewBackground
                error += ""
            }
        }
        
        if !(name?.isEmpty)! && !(cardNumber?.isEmpty)! {
            if !cvvTextField.isEditing{
                let cvv = cvvTextField.text
                if (cvv?.isEmpty)! {
                    error += Constants.EmptyCVV
                    cvvErrorLable.isHidden = false
                    cvvErrorLable.text = Constants.EmptyCVV
                    cvvDivider.backgroundColor = .red
                }else{
                    cvvErrorLable.isHidden = true
                    cvvDivider.backgroundColor = .groupTableViewBackground
                    error += ""
                }
            }else {
                cvvErrorLable.isHidden = true
                cvvDivider.backgroundColor = .groupTableViewBackground
                error += ""
            }
        }
        invalidEntries = !error.isEmpty
    }

    //To asssing next responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            self.textField = expiryDateTextField
            expiryDateTextField.becomeFirstResponder()
        }
        validateEntries()
        return true
    }

    //Changed the screen title based on card type selected and updated the pay button title with the amount
    func initUI() {
        if cardType == Constants.DebitCard {
            self.title = Constants.DebitCardTitle
        } else if cardType == Constants.CreditCard {
            //Default to Credit Card
            self.title = Constants.CrediCardTitle
        } else {
            self.title = Constants.EmiCardTitle
        }
        payButton.setTitle("Pay " + Constants.Inr + String(amountToBePayed).amountFormatter, for: UIControlState.normal)
    }

    //validates a card number
    func cardNumberDidChange(range: NSRange) -> Bool {
        let cardNumber = cardNumberTextField.text?.formattedCardNumber()
        do {
            let cardType = try CardValidator.cardType(for: (cardNumber)!)
            cardImageView.image = UIImage(named : cardType.stringValue(), in: Constants.frameworkBundle, compatibleWith: nil)
            let validLength = cardNumber?.validLength()
            if (cardNumber?.characters.count)! >= validLength! && range.length == 0 {
                return false
            } else {
                return true
            }
        } catch {
            if cardNumber?.characters.count == 0 {
                cardImageView.image = UIImage(named: Constants.AcceptedCards, in: Constants.frameworkBundle, compatibleWith: nil)
                return true
            } else {
                cardImageView.image = UIImage(named: Constants.UnknownCard, in: Constants.frameworkBundle, compatibleWith: nil)

                return ((cardNumber?.characters.count)! >= 19 && range.length == 0) ? false : true
            }
        }
    }

    //texfield values are validated as and when a character changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text?.characters.count
        if textField == cardNumberTextField {
            //card number validations
            if (characterCount!) > 4 {
                let numberEntered = cardNumberTextField.text?.formattedCardNumber()
                let finalString = numberEntered?.pairs.joined(separator: " ")
                cardNumberTextField.text = finalString
                return cardNumberDidChange(range: range)
            } else {
                return true
            }
        } else if textField == cvvTextField {
            //CVV number should not exceed 6 character limit
            return (characterCount! >= 6 && range.length == 0) ? false : true
        } else if textField == expiryDateTextField {
            return (characterCount! >= 5 && range.length == 0) ? false : true
        } else {
            return true
        }
    }

    //Call back recieved from juspay request to instamojo
    func onFinish(params: BrowserParams, error: String ) {
        let mainStoryboard = Constants.getStoryboardInstance()
        if let viewController: PaymentViewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PaymentOptionsJuspayViewController) as? PaymentViewController {
            viewController.params = params
            self.navigationController?.pushViewController(viewController, animated: true)
            spinner.hide()
        }
    }

    //When pay button is clicked
    @IBAction func checkout(_ sender: Any) {
        if !(invalidEntries) {
            prepareCheckOut()
        }
    }

}
