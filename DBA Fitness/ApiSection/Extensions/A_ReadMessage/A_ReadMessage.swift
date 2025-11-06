
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension Incoming_Messages{
    
    func readInboxMessages(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.isread_messages, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                       //self.tabBarController?.tabBar.isHidden = true
                       Constants.isMessageTab = "1"
                        let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Chat_VC") as! Chat_VC
                        vc.selectedReceiverName = particularMessage?.senderName ?? ""
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        
//                       UniversalMethod.universalManager.pushVC("Chat_VC", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
                        
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


extension Chat_VC{

    func readInboxMessages(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            apimethod.commonMethod(url: ApiURLs.isread_messages, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){

                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }

                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){

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
