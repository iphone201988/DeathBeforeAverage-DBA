
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func placeOrder(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.place_order, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201) {
                        
                        DispatchQueue.main.async {
                            
                            let refreshAlert = UIAlertController(title: "Death Before Average",
                                                                 message: "Program is successfully purchased",
                                                                 preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Dismiss",
                                                                 style: .default,
                                                                 handler: { (action: UIAlertAction) in
                                
                                if #available(iOS 13, *) {
                                    if let currentVC = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.topViewController() {
                                        currentVC.navigationController?.popToViewController(ofClass: Trainer_Exercise_Programs.self)
                                    }
                                } else {
                                    if let currentVC = UIApplication.shared.keyWindow?.topViewController() {
                                        currentVC.navigationController?.popToViewController(ofClass: Trainer_Exercise_Programs.self)
                                    }
                                }
                            }))
                            
                            self.present(refreshAlert, animated: true, completion: nil)
                        }
                        
                        //UniversalMethod.universalManager.alertMessage("Program is successfully purchased", self.navigationController)
                        
                    } else if(result.statusCode==500) {
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }else{
                    UniversalMethod.universalManager.alertMessage("There is something wrong with your card details. Please try again with valid card information.", self.navigationController)
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}
