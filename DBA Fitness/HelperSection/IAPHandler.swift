
import UIKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    case failed
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "Your purchase restored successfully!"//"You've successfully restored your purchase!"
        case .purchased: return "Welcome to the fitness revolution!"//"You've successfully bought this purchase!"
        case .failed: return "Transactions failed"
        }
    }
}


class IAPHandler: NSObject {
    static let shared = IAPHandler()
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    public typealias ProductIdentifier = String
    
    fileprivate var productID = "com.DBA.DBA.SubscriptionA"
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    var isNavigateViaSetting: Bool = false
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(isNavigateViaSetting: Bool){
        // Put here your IAP Products ID's
        self.isNavigateViaSetting = isNavigateViaSetting
        let productIdentifiers = NSSet(objects: productID)
        if let identifiers = productIdentifiers as? Set<String> {
            productsRequest = SKProductsRequest(productIdentifiers: identifiers)
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts {
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
            }
        } else {
            HelperUtil.getCurrentVC { currentVC in
                var actionTitlesArr = ["Continue with DBA", "Dismiss"]
                if self.isNavigateViaSetting {
                    actionTitlesArr = ["Dismiss"]
                }
                self.invalidProductAlert(title: "Death Before Average",
                                         message: "Please update your contract with Apple for subscription services. Please visit your Apple account for additional information.",
                                         actionTitles: actionTitlesArr,
                                         vc: currentVC,
                                         actions: [ { _ in
                    if !self.isNavigateViaSetting {
                        DispatchQueue.main.async {
                            UniversalMethod.universalManager.pushVC("Trainer_About",
                                                                    currentVC.navigationController!,
                                                                    storyBoard: AppStoryboard.Onboarding.rawValue)
                        }
                    }
                }, { _ in }, nil])
            }
        }
    }
    
    func invalidProductAlert(title: String?,
                             message: String?,
                             actionTitles: [String?],
                             vc: UIViewController,
                             actions: [((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            if !isNavigateViaSetting {
                if index == 0 {
                    action.setValue(UIColor.red, forKey: "titleTextColor")
                }
            }
            
            alert.addAction(action)
        }
        vc.present(alert, animated: true, completion: nil)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(trans)
                    
                    
                    //                    // Get the receipt if it's available
                    //                    if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
                    //                       FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
                    //
                    //                        do {
                    //                            let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                    //
                    //                            let receiptString = receiptData.base64EncodedString(options: [])
                    //                            // Read receiptData
                    //                        }
                    //                        catch { }
                    //                    }
                    
                    
                    //receiptValidation()
                    purchaseStatusBlock?(.purchased)
                    break
                case .failed:
                    NVActivityIndicator.managerHandler.stopIndicator()
                    SKPaymentQueue.default().finishTransaction(trans)
                    break
                case .restored:
                    NVActivityIndicator.managerHandler.stopIndicator()
                    SKPaymentQueue.default().finishTransaction(trans)
                    break
                case .purchasing:
                    // Show your loader - Disable interactions here
                    NVActivityIndicator.managerHandler.showIndicator()
                    
                default: _ = "Something went wrong."
                }}}
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
    }

    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        // Hide your loader - Enable interactions here
        NVActivityIndicator.managerHandler.stopIndicator()
    }
    
    func receiptValidation() {
        
        let SUBSCRIPTION_SECRET = "secret"
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        if FileManager.default.fileExists(atPath: receiptPath ?? ""){
            var receiptData:NSData?
            do{
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            }
            catch{
            }
            let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
            let requestDictionary = ["receipt-data":base64encodedReceipt ?? ""]
            
            //["receipt-data":base64encodedReceipt!,"password":SUBSCRIPTION_SECRET]
            
            guard JSONSerialization.isValidJSONObject(requestDictionary) else {  return }
            do {
                let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
                // https://buy.itunes.apple.com/verifyReceipt
                let validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"  // this works but as noted above it's best to use your own trusted server
                guard let validationURL = URL(string: validationURLString) else { return }
                
                let session = URLSession(configuration: URLSessionConfiguration.default)
                var request = URLRequest(url: validationURL)
                request.httpMethod = "POST"
                request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                let queue = DispatchQueue(label: "itunesConnect")
                queue.async {
                    let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
                        if let data = data , error == nil {
                            do {
                                let appReceiptJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                            } catch let error as NSError {
                            }
                        } else {
                        }
                    }
                    task.resume()
                }
                
            } catch let error as NSError {
            }
        }
    }
}

