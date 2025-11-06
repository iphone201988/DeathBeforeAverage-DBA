
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func addAnthropometric(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.add_anthropometric, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "Some fields are required")", self.navigationController)
                        }
                        
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)
                        
                        let dataStatus = userInfo?.status
                        
                        if (dataStatus == 200){

                            if Constants.isEditAnthropometric == "1"{
                                 NotificationCenter.default.post(name:NSNotification.Name(Constants.isUpdatedProfile), object:true)
                            }else{
                                let currentRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String
                                if currentRole == Role.trainer.rawValue{
                                    let story = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle:nil)
                                    let vc = story.instantiateViewController(withIdentifier: Trainer_Tabbar.Trainer_Bar.rawValue) as! MainTabbar_Controller
                                    vc.selectedIndex = 4
                                    UIApplication.shared.windows.first?.rootViewController = vc
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                }else if (currentRole == Role.client.rawValue){
                                    UniversalMethod.universalManager.pushVC("Client_Goals", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
                                }
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

