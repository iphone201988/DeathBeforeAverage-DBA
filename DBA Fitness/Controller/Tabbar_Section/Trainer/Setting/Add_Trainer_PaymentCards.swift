
import UIKit
import Stripe

class Add_Trainer_PaymentCards: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var card_Number: UITextField!
    @IBOutlet weak var holder_Name: UITextField!
    @IBOutlet weak var cvv_Number: UITextField!
    @IBOutlet weak var expire_Month: UITextField!
    @IBOutlet weak var expire_Year: UITextField!
    @IBOutlet weak var interface_Title: UILabel!
    
    var month_PickerView: UIPickerView!
    var year_PickerView: UIPickerView!
    
    var monthArray = [String]()
    var yearArray = [String]()
    var top_title = String()
    var dictPayData = [String:Any]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        card_Number.placeholderColor(color: UIColor.white)
        holder_Name.placeholderColor(color: UIColor.white)
        cvv_Number.placeholderColor(color: UIColor.white)
        expire_Month.placeholderColor(color: UIColor.white)
        expire_Year.placeholderColor(color: UIColor.white)
        
        interface_Title.text = top_title
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        month_PickerView = UIPickerView()
        month_PickerView.dataSource = self
        month_PickerView.delegate = self
        expire_Month.inputView = month_PickerView
        
        year_PickerView = UIPickerView()
        year_PickerView.dataSource = self
        year_PickerView.delegate = self
        expire_Year.inputView = year_PickerView
        
        monthArray.removeAll()
        yearArray.removeAll()
        
        for i in 1..<13{
            monthArray.append("\(i)")
        }
        for i in 2024..<2050{
            yearArray.append("\(i)")
        }
        
        expire_Month.text = monthArray.first
        expire_Year.text = yearArray.first
        
        if Constants.isEditCard == "1"{
            //card_Number.text = "XXXX XXXX XXXX \(particularCardDict?.card ?? "0000")"
            card_Number.text = particularCardDict?.full_card
            holder_Name.text = particularCardDict?.holdername
            expire_Month.text = particularCardDict?.expMonth ?? ""
            expire_Year.text = particularCardDict?.expYear ?? ""
        }
        
        card_Number.delegate = self
        holder_Name.delegate = self
        cvv_Number.delegate = self
        expire_Month.delegate = self
        expire_Year.delegate = self
        
        card_Number.addDoneButtonOnKeyboard()
        holder_Name.addDoneButtonOnKeyboard()
        cvv_Number.addDoneButtonOnKeyboard()
        expire_Month.addDoneButtonOnKeyboard()
        expire_Year.addDoneButtonOnKeyboard()
        
//        card_Number.clearButtonMode = .always
//        holder_Name.clearButtonMode = .always
//        cvv_Number.clearButtonMode = .always
        
        card_Number.modifyClearButtonWithImage()
        holder_Name.modifyClearButtonWithImage()
        cvv_Number.modifyClearButtonWithImage()
        
        
        
        
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        if holder_Name.text == "" || card_Number.text == "" || cvv_Number.text == "" || expire_Month.text == "" || expire_Year.text == ""{
            UniversalMethod.universalManager.alertMessage("All fields are required", self.navigationController)
        }else{
            getToken()
        }
        
        /* if holder_Name.text == "" || card_Number.text == "" || cvv_Number.text == "" || expire_Month.text == "" || expire_Year.text == ""{
         UniversalMethod.universalManager.alertMessage("All fields are required", self.navigationController)
         }else{
         if Constants.isEditCard == "1"{
         cardOperation(parameters:["holdername":holder_Name.text ?? "","card":card_Number.text ?? "","cansave":"1", "cardid":particularCardDict?.cardid ?? "0"] )
         }else{
         cardOperation(parameters:["holdername":holder_Name.text ?? "","card":card_Number.text ?? "","cansave":"1"] )
         }
         }*/
    }
    
 
    
    
    //MARK: Helper's Method
}

extension Add_Trainer_PaymentCards: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if pickerView == month_PickerView {
            return monthArray.count
        }else{
            return yearArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == month_PickerView{
            return monthArray[row]
        }else{
            return yearArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if pickerView == month_PickerView{
            expire_Month.text = monthArray[row]
        }else{
            expire_Year.text = yearArray[row]
        }
    }
}

extension Add_Trainer_PaymentCards: STPPaymentCardTextFieldDelegate{
    
    private func getToken(){
        NVActivityIndicator.managerHandler.showIndicator()
        let cardParams = STPCardParams()
        cardParams.number = card_Number.text
        cardParams.name = holder_Name.text
        cardParams.expMonth = UInt(expire_Month.text ?? "12") ?? 12
        cardParams.expYear =  UInt(expire_Year.text ?? "12") ?? 1999
        cardParams.cvc = cvv_Number.text
        STPAPIClient.shared.createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            

            
            guard let token = token, error == nil else {
                // Present error to user...
                UniversalMethod.universalManager.alertMessage("Something went wrong, please retry. may be you enter wrong Card's credential", self.navigationController)
                NVActivityIndicator.managerHandler.stopIndicator()
                return
            }
            self.dictPayData["stripe_token"] = token.tokenId
            
            if Constants.isEditCard == "1"{
                self.cardOperation(parameters:["holdername":self.holder_Name.text ?? "","card":self.card_Number.text ?? "","cansave":"1", "cardid":particularCardDict?.cardid ?? "0", "tokenid":token.tokenId, "full_card":self.card_Number.text ?? ""] )
            }else{
                self.cardOperation(parameters:["holdername":self.holder_Name.text ?? "","card":self.card_Number.text ?? "","cansave":"1","tokenid":token.tokenId, "full_card":self.card_Number.text ?? ""] )
            }
            
        }
    }
    
}

extension Add_Trainer_PaymentCards: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == holder_Name{
            if range.location == 0 && string == " " { // prevent space on first character
                return false
            }

            if textField.text?.last == " " && string == " " { // allowed only single space
                return false
            }

            if string == " " { return true } // now allowing space between name

            if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
                return false
            }
            
            let maxLength = 25
            let content = textField.text ?? ""
            let currentString: NSString = content as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == cvv_Number{
            let maxLength = 4
            let content = textField.text ?? ""
            let currentString: NSString = content as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if textField == card_Number{
            let maxLength = 16
            let content = textField.text ?? ""
            let currentString: NSString = content as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        
        return true
    }
}


//extension ViewController{
//
//    import UIKit
//
//    class AddPaymentCard: UIViewController {
//
//        //MARK: Outlets & Variables
//        @IBOutlet weak var cardNameView: UIView!
//        @IBOutlet weak var cardNumberView: UIView!
//        @IBOutlet weak var expirationView: UIView!
//        @IBOutlet weak var CVVView: UIView!
//        @IBOutlet weak var checkIcon: UIImageView!
//        @IBOutlet weak var rememberCardText: CustomLabel!
//        @IBOutlet weak var rememberCardButton: UIButton!
//        @IBOutlet weak var popUpView: UIView!
//        @IBOutlet weak var headerView: UIView!
//        @IBOutlet weak var applyView: UIView!
//        @IBOutlet weak var selectContinueMainView: UIView!
//        @IBOutlet weak var cardExpiryDateTF: UITextField!
//        @IBOutlet weak var holderCardNumberTF: UITextField!
//        @IBOutlet weak var holderNameValidationError: UILabel!
//        @IBOutlet weak var cardNumberValidationError: UILabel!
//        @IBOutlet weak var expiryDateValidationError: UILabel!
//        @IBOutlet weak var cvvValidationError: UILabel!
//        @IBOutlet weak var holderNameTF: UITextField!
//        @IBOutlet weak var cvvNumberTF: UITextField!
//
//        var holderNameValidationStatus = false
//        var cardNumberValidationStatus = false
//        var expiryDateValidationStatus = false
//        var cvvValidationStatus = false
//        var p_AddCards = [String:String]()
//        var exp_month:String?
//        var exp_year:String?
//
//        //MARK: Controller's Lifecycle
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            // Do any additional setup after loading the view.
//            fieldsDelegateSetUp()
//        }
//
//        override func viewWillLayoutSubviews() {
//            DispatchQueue.main.async {
//                super.updateViewConstraints()
//                self.initialViewSetUp()
//            }
//        }
//
//        //MARK: IB's Action
//        @IBAction func back(_ sender: UIButton) {
//            self.navigationController?.popViewController(animated: true)
//        }
//
//        @IBAction func addPaymentCard(_ sender: UIButton) {
//            if holderNameValidationStatus == true && cardNumberValidationStatus == true && expiryDateValidationStatus == true && cvvValidationStatus == true{
//                let enterdCardNumber = holderCardNumberTF.text
//                let originalCardNumber = enterdCardNumber?.components(separatedBy: ["-"]).joined()
//                p_AddCards["card_number"] = originalCardNumber
//                p_AddCards["exp_month"] = exp_month
//                p_AddCards["exp_year"] = exp_year
//                p_AddCards["cvc"] = cvvNumberTF.text
//                p_AddCards["isDefault"] = "\(rememberCardButton.tag)"
//                p_AddCards["name"] = holderNameTF.text
//                callAddCards(parameters:p_AddCards)
//            }else{
//                if holderNameValidationStatus == false{
//                    holderNameValidationError.text = "Holder name can't be emty"
//                    holderNameValidationStatus = false
//                    self.cardNameView.layoutIfNeeded()
//                }
//                if cardNumberValidationStatus == false{
//                    cardNumberValidationError.text = "Card number cannot be empty"
//                    cardNumberValidationStatus = false
//                    self.cardNumberView.layoutIfNeeded()
//                }
//                if expiryDateValidationStatus == false{
//                    expiryDateValidationError.text = "Choose expiry date"
//                    expiryDateValidationStatus = false
//                    self.expirationView.layoutIfNeeded()
//                }
//                if cvvValidationStatus == false{
//                    cvvValidationError.text = "CVV cannot be empty"
//                    cvvValidationStatus = false
//                    self.CVVView.layoutIfNeeded()
//                }
//            }
//        }
//
//        @IBAction func remeberCardAction(_ sender: UIButton) {
//            if rememberCardButton.tag == 0{
//                rememberCardButton.tag = 1
//                checkIcon.image = #imageLiteral(resourceName: "off")
//                rememberCardText.textColor = UIColor(named: "#1F1E20")
//            }else{
//                rememberCardButton.tag = 0
//                checkIcon.image = #imageLiteral(resourceName: "off-1")
//                rememberCardText.textColor = UIColor(named: "#7E849B")
//            }
//        }
//
//        @IBAction func dismissAction(_ sender: UIButton) {
//            self.dismiss(animated: true, completion: nil)
//        }
//
//        //MARK: Helper's Method
//        @objc func tapDoneStart(){
//            if let datePicker = self.cardExpiryDateTF.inputView as? UIDatePicker {
//                let dateformatter = DateFormatter()
//                dateformatter.dateFormat = "MM.dd.yy"
//                self.cardExpiryDateTF.text = dateformatter.string(from: datePicker.date)
//                dateformatter.dateFormat = "MM"
//                self.exp_month = dateformatter.string(from: datePicker.date)
//                dateformatter.dateFormat = "yyyy"
//                self.exp_year = dateformatter.string(from: datePicker.date)
//                expiryDateValidationError.text = ""
//                expiryDateValidationStatus = true
//                self.expirationView.layoutIfNeeded()
//            }
//            self.cardExpiryDateTF.resignFirstResponder()
//        }
//
//        func fieldsDelegateSetUp(){
//            self.cardExpiryDateTF.delegate = self
//            self.cardExpiryDateTF.addDoneButtonOnKeyboard()
//            self.holderCardNumberTF.delegate = self
//            self.holderCardNumberTF.addDoneButtonOnKeyboard()
//            self.holderNameTF.delegate = self
//            self.holderNameTF.addDoneButtonOnKeyboard()
//            self.cvvNumberTF.delegate = self
//            self.cvvNumberTF.addDoneButtonOnKeyboard()
//
//            self.cardExpiryDateTF.setInputViewDatePicker(target: self, selector: #selector(tapDoneStart), datePickerMode: .date, minimumDate: Date(), MaximumDate: nil)
//
//            holderNameTF.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
//            holderCardNumberTF.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
//            cardExpiryDateTF.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
//            cvvNumberTF.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
//
//            holderNameValidationError.text = ""
//            cardNumberValidationError.text = ""
//            expiryDateValidationError.text = ""
//            cvvValidationError.text = ""
//        }
//    }
//
//    extension AddPaymentCard: UITextFieldDelegate{
//
//        func textFieldDidBeginEditing(_ textField: UITextField) {
//            if textField == holderNameTF {
//                if textField.text == ""{
//                    holderNameValidationError.text = "Holder name can't be emty"
//                    holderNameValidationStatus = false
//                    self.cardNameView.layoutIfNeeded()
//                }
//            }
//
//            if textField == holderCardNumberTF {
//                if textField.text == ""{
//                    cardNumberValidationError.text = "Card number cannot be empty"
//                    cardNumberValidationStatus = false
//                    self.cardNumberView.layoutIfNeeded()
//                }
//            }
//
//            if textField == cvvNumberTF {
//                if textField.text == ""{
//                    cvvValidationError.text = "CVV cannot be empty"
//                    cvvValidationStatus = false
//                    self.CVVView.layoutIfNeeded()
//                }
//            }
//
//            if textField == cardExpiryDateTF {
//                if textField.text == ""{
//                    expiryDateValidationError.text = "Choose expiry date"
//                    expiryDateValidationStatus = false
//                    self.expirationView.layoutIfNeeded()
//                }
//            }
//        }
//
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
//            if textField == holderCardNumberTF {
//                if currentText.count >= 20 {
//                    return false
//                }
//                return true
//            }else if(textField == cvvNumberTF) {
//                if currentText.count > 3 {
//                    return false
//                }
//                return true
//            }else{
//                return true
//            }
//        }
//
//        @objc func textIsChanging(_ textField:UITextField){
//
//            if textField == holderNameTF{
//                let holderNameString = holderNameTF.text?.trimmed() ?? ""
//                if holderNameString != ""{
//                    holderNameValidationError.text = ""
//                    holderNameValidationStatus = true
//                    self.cardNameView.layoutIfNeeded()
//                }else{
//                    holderNameValidationError.text = "Holder name cannot be empty"
//                    holderNameValidationStatus = false
//                    self.cardNameView.layoutIfNeeded()
//                }
//            }else if textField == cvvNumberTF{
//                let cvvNumberString = cvvNumberTF.text?.trimmed() ?? ""
//                if cvvNumberString != "" && cvvNumberString.count == 3{
//                    cvvValidationError.text = ""
//                    cvvValidationStatus = true
//                    self.CVVView.layoutIfNeeded()
//                }else if (cvvNumberString.count < 3 && cvvNumberString.count > 0){
//                    cvvValidationError.text = "Enter valid CVV"
//                    cvvValidationStatus = false
//                    self.CVVView.layoutIfNeeded()
//                }else{
//                    cvvValidationError.text = "CVV cannot be empty"
//                    cvvValidationStatus = false
//                    self.CVVView.layoutIfNeeded()
//                }
//            }else if textField == holderCardNumberTF{
//                let cardNumberString = holderCardNumberTF.text?.trimmed() ?? ""
//                textField.text = cardNumberString.grouping(every: 4, with: "-")
//                if cardNumberString != "" && cardNumberString.count == 19{
//                    cardNumberValidationError.text = ""
//                    cardNumberValidationStatus = true
//                    self.cardNumberView.layoutIfNeeded()
//                }else if (cardNumberString.count < 19 && cardNumberString.count > 0){
//                    cardNumberValidationError.text = "Enter valid card number"
//                    cardNumberValidationStatus = false
//                    self.cardNumberView.layoutIfNeeded()
//                }else{
//                    cardNumberValidationError.text = "Card number cannot be empty"
//                    cardNumberValidationStatus = false
//                    self.cardNumberView.layoutIfNeeded()
//                }
//            }else if textField == cardExpiryDateTF{
//                if textField.text != ""{
//                    expiryDateValidationError.text = ""
//                    expiryDateValidationStatus = true
//                    self.expirationView.layoutIfNeeded()
//                }else{
//                    expiryDateValidationError.text = "Choose expiry date"
//                    expiryDateValidationStatus = false
//                    self.expirationView.layoutIfNeeded()
//                }
//            }
//        }
//    }
//
//    extension AddPaymentCard: UITextViewDelegate{}
//
//    extension AddPaymentCard{
//
//        //MARK: Initial View Setup
//        func initialViewSetUp(){
//
//            //Define View Style
//            self.popUpView.roundCorners(topLeft: 14.0, topRight: 14.0, bottomLeft: 0.0, bottomRight: 0.0)
//            self.headerView.customViewsShadow(red: 169.0/255.0, green: 168.0/255.0, blue: 192.0/255.0, alpha: 1.0, width: 0, height: 1, opacity: 0.2, radius: 9)
//            self.applyView.gradientBackground(from: startColor, to: endColor, direction: .topToBottom)
//            self.selectContinueMainView.customViewsShadow(red: 169.0/255.0, green: 168.0/255.0, blue: 192.0/255.0, alpha: 1.0, width: 0, height: 1, opacity: 0.2, radius: 9)
//            //LoadView
//            self.popUpView.layoutIfNeeded()
//            self.headerView.layoutIfNeeded()
//            self.applyView.layoutIfNeeded()
//            self.selectContinueMainView.layoutIfNeeded()
//            cardNameView.customView(borderWidth: 1.0, cornerRadius: 26.0, red: 237.0/255, green: 238.0/255, blue: 239.0/255, alpha: 1.0)
//            cardNumberView.customView(borderWidth: 1.0, cornerRadius: 26.0, red: 237.0/255, green: 238.0/255, blue: 239.0/255, alpha: 1.0)
//            expirationView.customView(borderWidth: 1.0, cornerRadius: 26.0, red: 237.0/255, green: 238.0/255, blue: 239.0/255, alpha: 1.0)
//            CVVView.customView(borderWidth: 1.0, cornerRadius: 26.0, red: 237.0/255, green: 238.0/255, blue: 239.0/255, alpha: 1.0)
//
//            rememberCardButton.tag = 0
//            checkIcon.image = #imageLiteral(resourceName: "off-1")
//            rememberCardText.textColor = UIColor(named: "#7E849B")
//        }
//    }
//
//
//}
