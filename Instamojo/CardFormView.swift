//
//  CardFormView.swift
//  Instamojo
//
//  Created by Sukanya Raj on 07/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import UIKit

class CardFormView : UIViewController, UITextFieldDelegate, JuspayRequestCallBack{
    
    @IBOutlet weak var errorLableView: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet var expiryPickerView: MonthYearPickerView!
    
    var order : Order!
    var cardType : Int = 0;
    var amountToBePayed : Float = 0;
    var spinner : Spinner!
    
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
            let date = String(format: Constants.DATE_FORMAT, month, year)
            self.expiryDateTextField.text = date
        }
        cvvTextField.inputAccessoryView = toolbarDone
        spinner = Spinner(text: Constants.SPINNER_TEXT)
        spinner.hide()
        self.view.addSubview(spinner)
    }
    
    //Click listener on the Done button on top of the keyboard
    func doneButton_Clicked(sender : UIBarButtonItem){
        if cardNumberTextField.isEditing {
            cardNumberTextField.resignFirstResponder()
            nameTextField.becomeFirstResponder()
        }else if expiryDateTextField.isEditing{
            let expiryDate = expiryDateTextField?.text
            expiryDateTextField.resignFirstResponder()
            cvvTextField.becomeFirstResponder()
            if (expiryDate?.isEmpty)!{
                expiryDateTextField.text = Constants.DEFAULT_CARD_EXPIRY
            }
        }else if cvvTextField.isEditing{
            let cvv = cvvTextField?.text
            cvvTextField.resignFirstResponder()
            if (cvv?.isEmpty)! {
                cvvTextField.text = Constants.DEFAULT_CVV
            }
        }
        validateEntries()
    }
    
    //Prepare the card object for a juspay request
    func prepareCheckOut(){
        let cardHolderName = nameTextField.text
        let cardNumber = cardNumberTextField.text
        let expiryDate = expiryDateTextField.text
        let cvv = cvvTextField.text
        let card = Card(cardHolderName: cardHolderName!, cardNumber: cardNumber!, date: expiryDate!, cvv: cvv!, savedCard: false)
        self.checkOutCard(card: card)
    }
    
    //A juspay request using Card object
    func checkOutCard(card : Card){
        spinner.show()
        let request = Request(order: self.order, card: card, jusPayRequestCallBack: self)
        request.execute()
    }
    
    //Valiated the data entered
    func validateEntries(){
        let cardNumber = cardNumberTextField?.text
        let name = nameTextField?.text
        var error : String = "";
        
        if !cardNumberTextField.isEditing {
            if (cardNumber?.isEmpty)! {
                error = Constants.EMPTY_CARD_NUMER
            }else{
                let isValid = cardNumber?.isValidCardNumber();
                if !isValid! {
                    error = Constants.INVALID_CARD_NUMBER
                    cardNumberTextField.textColor = UIColor.red
                }else{
                    cardNumberTextField.textColor = UIColor.black
                }
            }
        }else{
            error = error + "";
        }
        
        if !nameTextField.isEditing {
            if (name?.isEmpty)! {
                error = error + Constants.EMPTY_CARD_HOLDER_NAME
            }
        }else{
            error = error + "";
        }
        errorLableView.text = error
    }
    
    //To asssing next responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            expiryDateTextField.becomeFirstResponder();
        }
        validateEntries()
        return true
    }
    
    //Changed the screen title based on card type selected and updated the pay button title with the amount
    func initUI(){
        if cardType == Constants.DEBIT_CARD{
            self.title = Constants.DEBIT_CARD_TITLE
        }else if cardType == Constants.CREDIT_CARD {
            //Default to Credit Card
            self.title = Constants.CREDI_CARD_TITLE
        }else{
            self.title = Constants.EMI_CARD_TITLE
        }
        payButton.setTitle("Pay " + Constants.INR + String(amountToBePayed).amountFormatter, for: UIControlState.normal)
    }
    
    //validates a card number
    func cardNumberDidChange(range:NSRange) -> Bool {
        let cardNumber = cardNumberTextField.text?.formattedCardNumber();
        do {
            let cardType = try CardValidator.cardType(for: (cardNumber)!)
            cardImageView.image = UIImage(named : cardType.stringValue());
            let validLength = cardNumber?.validLength();
            if ((cardNumber?.characters.count)! >= validLength! && range.length == 0) {
                return false;
            }else{
                return true;
            }
        }catch{
            if (cardNumber?.isEmpty)! {
                cardImageView.image = UIImage(named : Constants.ACCEPTED_CARDS);
                return true
            }else{
                cardImageView.image = UIImage(named : Constants.UNKNOWN_CARD);
                return ((cardNumber?.characters.count)! >= 19 && range.length == 0) ? false : true;
            }
        }
    }
    
    //texfield values are validated as and when a character changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text?.characters.count;
        if textField == cardNumberTextField {
            //card number validations
            if (characterCount!) > 4 {
                let numberEntered = cardNumberTextField.text?.formattedCardNumber();
                let finalString = numberEntered?.pairs.joined(separator: " ")
                cardNumberTextField.text = finalString
                return cardNumberDidChange(range: range)
            }else{
                return true;
            }
        }else if(textField == cvvTextField){
            //CVV number should not exceed 6 character limit
            return (characterCount! >= 6 && range.length == 0) ? false : true;
        }else if textField == expiryDateTextField{
            return (characterCount! >= 5 && range.length == 0) ? false : true;
        }else {
            return true;
        }
    }
    
    //Call back recieved from juspay request to instamojo
    func onFinish(params : BrowserParams, error : String ){
        let mainStoryboard = Constants.getStoryboardInstance()
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.PAYMENT_OPTIONS_JUSPAY_VIEW_CONTROLLER) as! JuspayBrowser
        viewController.params = params;
        self.navigationController?.pushViewController(viewController, animated: true)
        spinner.hide()
    }

    //When pay button is clicked
    @IBAction func checkout(_ sender: Any) {
        if (errorLableView.text?.isEmpty)! {
            prepareCheckOut()
        }
    }

}
