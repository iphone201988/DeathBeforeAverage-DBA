
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func markPurchased(parameters:[String :Any], entryPoint:EntryPoint ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.purchased_subscription, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)
                        
                        let dataStatus = userInfo?.status
                        
                        if (dataStatus == 200){

                            locallySaveLoggedUserData(userInfo)

                            if entryPoint == .Onboarding{
                                UniversalMethod.universalManager.pushVC("Trainer_About", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
                            }else{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}


