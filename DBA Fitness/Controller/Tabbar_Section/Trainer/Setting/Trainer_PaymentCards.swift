
import UIKit
import MGSwipeTableCell
import Stripe

class Trainer_PaymentCards: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var goals_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    @IBOutlet weak var confirmHeight: NSLayoutConstraint!
    @IBOutlet weak var confirm_Bottom: NSLayoutConstraint!
    
    var dictPayData = [String:Any]()
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    //  var client_Goals = [String]()
    
    var isPurchaseSection = false
    var selectedCard = [Int:Bool]()
    var cardCVV = ""
    var program_id = ""
    var stripe_secret_key = String()
    
    private var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    private var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if isPurchaseSection == true{
            interface_Title.text = "Choose Card"
            confirmHeight.constant = 50.0
            confirm_Bottom.constant = 20.0
            nextButton.isHidden = false
        }else{
            interface_Title.text = "My Cards"
            confirmHeight.constant = 0.0
            confirm_Bottom.constant = 0.0
            nextButton.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(cardsInfo(_:)), name: NSNotification.Name(rawValue: Constants.cardsDetails), object: nil)
    }
    
    @objc func cardsInfo(_ notify:NSNotification){
        let isUpdated = notify.object as? Bool
        if isUpdated == true{
            goals_Tableview.delegate = self
            goals_Tableview.dataSource = self
            goals_Tableview.register(UINib(nibName: "Payment_Cards_Cell", bundle: nil), forCellReuseIdentifier: "Payment_Cards_Cell")
            goals_Tableview.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCards(parameters:[:] )
    }
    
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Add_Trainer_PaymentCards") as! Add_Trainer_PaymentCards
        
        //let vc = self.storyboard?.instantiateViewController(identifier: "Add_Trainer_PaymentCards") as! Add_Trainer_PaymentCards
        vc.top_title = "Add Card"
        Constants.isEditCard = "0"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func next(_ sender: UIButton) {
        
        if selectedCard.count == 0{
            UniversalMethod.universalManager.alertMessage("Choose a card first", self.navigationController)
        }else{
            let alertController = UIAlertController(title: "DBA Fitness", message: "", preferredStyle: UIAlertController.Style.alert)
            
            //            alertController.addTextField { (textField : UITextField) -> Void in
            //                textField.placeholder = "Enter your Name"
            //            }
            alertController.addTextField { (textField : UITextField) -> Void in
                textField.placeholder = "Enter your CVV"
            }
            let saveAction = UIAlertAction(title: "Pay", style: UIAlertAction.Style.default, handler: { alert -> Void in
                self.cardCVV = alertController.textFields?.first?.text ?? "000"
                let inputContent = alertController.textFields?.first?.text ?? ""
                if inputContent.isEmpty {
                    UniversalMethod.universalManager.alertMessage("CVV number cannot be empty", self.navigationController)
                } else {
                    self.getToken()
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction) -> Void in })
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func skip(_ sender: UIButton) {
        
    }
    
    //MARK: Helper's Method
}

extension Trainer_PaymentCards: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = cardsInfos?.data?.count else{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            nextButton.isEnabled = false
            skipButton.isEnabled = true
            skipButton.alpha = 1.0
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            nextButton.isEnabled = false
            skipButton.isEnabled = true
            skipButton.alpha = 1.0
        }else{
            empty_View.isHidden = true
            goals_Tableview.isHidden = false
            nextButton.isEnabled = true
            skipButton.isEnabled = false
            skipButton.alpha = 0.5
        }
        return count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Payment_Cards_Cell", for: indexPath) as? Payment_Cards_Cell {

            let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                self?.removeGoal(at: indexPath.row)
                return true
            }

            let editButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "edit_icon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                self?.editGoal(at: indexPath.row)
                return true
            }

            cell.rightButtons = [deleteButton, editButton]

            cell.configure()

            let cardDict = cardsInfos?.data?[indexPath.row]
            cell.pair1.text = "XXXX"
            cell.pair2.text = "XXXX"
            cell.pair3.text = "XXXX"
            cell.pair4.text = cardDict?.card
            cell.expiryDate.text = "\(cardDict?.expMonth ?? "N/A")/\(cardDict?.expYear ?? "N/A")"//"01/21"
            cell.holderName.text = cardDict?.holdername ?? "N/A"

            if isPurchaseSection == true{
                if  selectedCard[indexPath.row] == true{
                    cell.backgroundColor = UIColor(named:"Sub_Interface_BG_CC")
                }else{
                    cell.backgroundColor = UIColor.clear
                }
            }else{
                cell.backgroundColor = UIColor.clear
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCard.removeAll()
        selectedCard[indexPath.row] = true
        particularCardInfo = cardsInfos?.data?[indexPath.row]
        goals_Tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    private func removeGoal(at index: Int) {
        
        Constants.isEditCard = "2"
        let cardsDict = cardsInfos?.data?[index]
        cardOperation(parameters:["cardid":cardsDict?.cardid ?? "0"] )
    }
    
    private func editGoal(at index: Int) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Add_Trainer_PaymentCards") as! Add_Trainer_PaymentCards
        vc.top_title = "Edit Card"
        particularCardDict = cardsInfos?.data?[index]
        Constants.isEditCard = "1"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension Trainer_PaymentCards: STPPaymentCardTextFieldDelegate{
    
    private func getToken(){
        NVActivityIndicator.managerHandler.showIndicator()
        let cardParams = STPCardParams()
        cardParams.number = particularCardInfo?.full_card
        cardParams.name = particularCardInfo?.holdername
        cardParams.expMonth = UInt(particularCardInfo?.expMonth ?? "12") ?? 12
        cardParams.expYear =  UInt(particularCardInfo?.expYear ?? "1999") ?? 1999
        cardParams.cvc = cardCVV
        STPAPIClient.shared.createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            

            
            guard let token = token, error == nil else {
                // Present error to user...
                UniversalMethod.universalManager.alertMessage("Please provide valid information.", self.navigationController)
                NVActivityIndicator.managerHandler.stopIndicator()
                return
            }
            self.dictPayData["stripe_token"] = token.tokenId
            self.placeOrder(parameters:["program_id":self.program_id,
                                        "amount":particularPrograms?.price ?? "100",
                                        "token":token.tokenId])
        }
    }
}

//                                        "stripe_secret_key": self.stripe_secret_key
