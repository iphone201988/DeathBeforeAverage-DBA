
import UIKit
import StoreKit

class Upgrade_Subscription: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
//    @IBOutlet weak var outerView: GradientView!
//    @IBOutlet weak var innerView: GradientView!
    @IBOutlet weak var termsPolicy: UITextView!
    @IBOutlet weak var monthly: UIButton!
    @IBOutlet weak var annual: UIButton!
    @IBOutlet weak var restore: GradientButton!
    
    var entryPoint:EntryPoint?
    
    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
//        outerView.layer.cornerRadius = 13.0
//        innerView.layer.cornerRadius = 13.0
        setAgreementsLabelText()
        //self.tabBarController?.tabBar.isHidden = true
        if entryPoint == .Setting {
            IAPHandler.shared.fetchAvailableProducts(isNavigateViaSetting: true)
        } else {
            IAPHandler.shared.fetchAvailableProducts(isNavigateViaSetting: false)
        }
        
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in

            NVActivityIndicator.managerHandler.stopIndicator()

            guard let strongSelf = self else{ return }
            if type == .purchased {
                let alertView = UIAlertController(title: "DBA Fitness", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    self?.markPurchased(parameters:["is_purchased":1], entryPoint: self?.entryPoint ?? .Setting)
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
            if  type == .restored {
                let alertView = UIAlertController(title: "DBA Fitness", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    self?.markPurchased(parameters:["is_purchased":1], entryPoint: self?.entryPoint ?? .Setting)
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if entryPoint == .Onboarding {
//            monthly.isHidden = false
//            annual.isHidden = false
//            restore.isHidden = true
//        }else{
//            monthly.isHidden = true
//            annual.isHidden = true
//            restore.isHidden = false
//        }
    }
    
    //MARK : IB's Action
    
    @IBAction func purchaseProduct(_ sender: UIButton) {
        IAPHandler.shared.purchaseMyProduct(index: 0)
    }
    
    @IBAction func didTapAnnualSubscription(_ sender: GradientButton) {
        IAPHandler.shared.purchaseMyProduct(index: 0)
    }
    
    @IBAction func restorePurchase(_ sender: UIButton) {
        IAPHandler.shared.restorePurchase()
//        UniversalMethod.universalManager.pushVC("Trainer_About", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
    }
    
    @IBAction func back(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper's Method
    
    fileprivate func setAgreementsLabelText() {
        
        termsPolicy.delegate = self
        termsPolicy.isUserInteractionEnabled = true
        termsPolicy.isEditable = false
        
        // Mark:- Setting for Terms and Policy link
        let str  = "By signing up you agree to our Privacy Policy and Terms and Conditions" as NSString
        let attributedString = NSMutableAttributedString(string: str as String)
        attributedString.addAttribute(.link, value: Constants.termsURLPath, range:str.range(of:"Terms and Conditions")
        )
        attributedString.addAttribute(.link, value: Constants.privacyURLPath, range: str.range(of: "Privacy Policy"))
        
        let blueColor = UIColor(red: 0/255, green: 117/255, blue: 187/255, alpha: 1)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: blueColor, range: NSRange.init(location:0, length: str.length))
        
        termsPolicy.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: blueColor,
            NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)
        ]
        termsPolicy.attributedText = attributedString
        termsPolicy.textAlignment = .center
        termsPolicy.linkTextAttributes = [.underlineStyle: NSUnderlineStyle.single.rawValue]
        termsPolicy.textColor = #colorLiteral(red: 0.9921568627, green: 0.9882352941, blue: 1, alpha: 1)
        
    }
}

extension Upgrade_Subscription : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
    
}

enum EntryPoint{
    case Onboarding
    case Setting
}
