
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func deleteUser(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.delete_user_account, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
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
                            UniversalMethod.universalManager.navigateToAuth()
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


