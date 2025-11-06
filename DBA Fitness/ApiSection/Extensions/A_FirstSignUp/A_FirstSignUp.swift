
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func firstSignUp(parameters:[String :Any], isShowLoading:Bool? = nil, isComingFrom:String ){
        if Connectivity.isConnectedToInternet {
            
            if isShowLoading != false{
                NVActivityIndicator.managerHandler.showIndicator()
            }
            
            apimethod.commonMethod(url: ApiURLs.signup_first, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)
                        
                        let dataStatus = userInfo?.status
                        
                        if (dataStatus == 200){
                            
                            locallySaveLoggedUserData(userInfo)
                            
                            if let is_connected_stripe = userInfo?.data?.is_connected_stripe {
                                if is_connected_stripe == "1" {
                                    DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: true)
                                } else {
                                    DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: false)
                                }
                            } else {
                                DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: false)
                            }
                            
                            if userInfo?.data?.type == "0"{
                                
                                UniversalMethod.universalManager.navigateToChooseRole()
                                
                                /*
                                 let refreshAlert = UIAlertController(title: "Death Before Average", message: "Account verification mail sent on your registered email. Please verify your account.", preferredStyle: UIAlertController.Style.alert)
                                 
                                 refreshAlert.addAction(UIAlertAction(title: "Continue with DBA", style: .default, handler: { (action: UIAlertAction) in
                                 UniversalMethod.universalManager.navigateToChooseRole()
                                 }))
                                 self.present(refreshAlert, animated: true, completion: nil)
                                 
                                 */
                                
                            }else if (userInfo?.data?.type == "1"){
                                UniversalMethod.universalManager.navigateToTrainer()
                            }else if (userInfo?.data?.type == "2"){
                                UniversalMethod.universalManager.navigateToClient()
                            }else if (userInfo?.data?.type == "3"){
                                
                                
                                if isComingFrom == "LoginVC"{
                                    NotificationCenter.default.post(name:NSNotification.Name(Constants.loginknowAboutAccountVerifyStatus), object:true)
                                }else{
                                    NotificationCenter.default.post(name:NSNotification.Name(Constants.signUpknowAboutAccountVerifyStatus), object:true)
                                }
                                
                                let refreshAlert = UIAlertController(
                                    title: "Death Before Average",
                                    message: "Check your email to verify your account. If using a mobile device, the onboarding process will start automatically after verification. If verifying on a computer, open the app, select ‘Sign Up,’ and enter your email to continue. Don’t forget to check your spam folder.",
                                    preferredStyle: UIAlertController.Style.alert
                                )
                                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                                    // self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(refreshAlert, animated: true, completion: nil)
                            }
                            
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }else{
                        UniversalMethod.universalManager.alertMessage("Email is already exist", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}

/*
 Email delivered to your registered email for account verification. Verify your account, please. Once you have verified, the onboarding section will instantly open.
 */

func locallySaveLoggedUserData(_ userInfo: M_UserInfo?) {
    DataSaver.dataSaverManager.saveData(key: "firstname", data: userInfo?.data?.firstname ?? "hh")
    DataSaver.dataSaverManager.saveData(key: "lastname", data: userInfo?.data?.lastname ?? "hh")
    DataSaver.dataSaverManager.saveData(key: "email", data: userInfo?.data?.email ?? "hh")
    DataSaver.dataSaverManager.saveData(key: "sessionkey", data: userInfo?.data?.sessionkey ?? "hh")
    DataSaver.dataSaverManager.saveData(key: "userid", data: userInfo?.data?.userid ?? "hh")
    DataSaver.dataSaverManager.saveData(key: "userType", data: userInfo?.data?.type ?? "hh")
    DataSaver.dataSaverManager.saveData(key: "profilePic", data: userInfo?.data?.image ?? "")
    DataSaver.dataSaverManager.saveData(key: "isPrivate", data: userInfo?.data?.dataPrivate ?? "")
    DataSaver.dataSaverManager.saveData(key: "notification_alert", data: userInfo?.data?.notification_alert ?? "")
    DataSaver.dataSaverManager.saveData(key: "is_purchased", data: userInfo?.data?.is_purchased ?? "")
    DataSaver.dataSaverManager.saveData(key: "is_apple", data: userInfo?.data?.is_apple ?? "")
    DataSaver.dataSaverManager.saveData(key: "is_facebook", data: userInfo?.data?.is_facebook ?? "")
    DataSaver.dataSaverManager.saveData(key: "username", data: userInfo?.data?.username ?? "")
}
