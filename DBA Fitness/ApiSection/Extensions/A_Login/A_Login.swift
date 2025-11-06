
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func login(parameters:[String :Any],isShowLoading:Bool? = nil, isComingFrom:String  ){
        if Connectivity.isConnectedToInternet {

            //NVActivityIndicator.managerHandler.showIndicator()
            
            if isShowLoading != false{
                NVActivityIndicator.managerHandler.showIndicator()
            }
            
            apimethod.commonMethod(url: ApiURLs.login, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==400 || result.statusCode==401){
                        UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)

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
                            }else if (userInfo?.data?.type == "1"){
                                UniversalMethod.universalManager.navigateToTrainer()
                            }else if (userInfo?.data?.type == "2"){
                                UniversalMethod.universalManager.navigateToClient()
                            }
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }else if(result.statusCode==404){
                        UniversalMethod.universalManager.alertMessage("This account has no registration.", self.navigationController)
                    }else if(result.statusCode==405){
                        UniversalMethod.universalManager.alertMessage(" Please verify your email. Once you verify, you can continue with onboarding section. Note: Please proceed with the SignUp procedure using a validated email if your account has been verified but you haven't finished the second phase.", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
    
    

    
}


func logout(parameters:[String :Any] ){
    if Connectivity.isConnectedToInternet {
        NVActivityIndicator.managerHandler.showIndicator()
        
        apimethod.commonMethod(url: ApiURLs.logout, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
            NVActivityIndicator.managerHandler.stopIndicator()
            if success, let result = response as? HTTPURLResponse{
                
                if(result.statusCode==400 || result.statusCode==401){

                    UniversalMethod.universalManager.navigateToAuth()
                    
                    
                }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                    
                    let userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)

                    let dataStatus = userInfo?.status
                    
                    if (dataStatus == 200){

                        DispatchQueue.main.async {
                            DataSaver.dataSaverManager.deleteData(key: "accessToken")
                            DataSaver.dataSaverManager.deleteData(key: "Role")
                            DataSaver.dataSaverManager.deleteData(key: "name")
                            DataSaver.dataSaverManager.deleteData(key: "email")
                            DataSaver.dataSaverManager.deleteData(key: "id")
                            DataSaver.dataSaverManager.deleteData(key: "isComplete")
                            DataSaver.dataSaverManager.deleteData(key: "programID")
                            DataSaver.dataSaverManager.deleteData(key: "firstname")
                            DataSaver.dataSaverManager.deleteData(key: "lastname")
                            DataSaver.dataSaverManager.deleteData(key: "sessionkey")
                            DataSaver.dataSaverManager.deleteData(key: "userid")
                            DataSaver.dataSaverManager.deleteData(key: "userType")
                            DataSaver.dataSaverManager.deleteData(key: "profilePic")
                            DataSaver.dataSaverManager.deleteData(key: "isPrivate")
                            DataSaver.dataSaverManager.deleteData(key: "selectedLoc")
                            DataSaver.dataSaverManager.deleteData(key: "notification_alert")
                            DataSaver.dataSaverManager.deleteData(key: "is_purchased")
                            DataSaver.dataSaverManager.deleteData(key: "is_connected_stripe")
                            DataSaver.dataSaverManager.deleteData(key: "isNewNotification")

                            Constants.searchIsCertifiate = ""
                            Constants.searchSpecialist = ""
                            Constants.searchGender = ""
                            
                            UniversalMethod.universalManager.navigateToAuth()
                        }
                        
                    }else{
                        
                    }
                }else if(result.statusCode==500){

                }else if(result.statusCode==404){
                    
                }
            }
        }
    }else{

    }
}
