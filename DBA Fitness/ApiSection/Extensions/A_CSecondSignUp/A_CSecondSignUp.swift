
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire
import SDWebImage

extension UIViewController{
    
    // MARK: Upload Profile Pic API
    
    func csecondSignUp(firstname:String, lastname:String, type:String, location:String, image:URL, specialist:String, password:String, username:String){
        
        func basicAuth() -> String{
            let user = "whistle"
            let password = "!@#$%_whistle_)(*&^"
            let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8) ?? Data()
            let base64Credentials = credentialData.base64EncodedString(options: [])
            
            return base64Credentials
        }
        
        let sessionkey = DataSaver.dataSaverManager.fetchData(key: "sessionkey") as? String ?? ""
        let userid = DataSaver.dataSaverManager.fetchData(key: "userid") as? String ?? ""
        
        let APIheaders: HTTPHeaders = [
            "Accept": "application/x-www-form-urlencoded",
            "Content-Type" : "application/x-www-form-urlencoded",
            "Authorization" : "Basic \(basicAuth())",
            "sessionkey" : sessionkey,
            "userid" : userid,
        ]
        
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            NVActivityIndicator.managerHandler.showIndicator()
            
            multipartFormData.append(image, withName: "image")
            multipartFormData.append(firstname.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"firstname")
            
            multipartFormData.append(firstname.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"firstname")
            
            multipartFormData.append(lastname.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"lastname")
            
            multipartFormData.append(password.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"password")
            
            multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"type")
            
            multipartFormData.append(username.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"username")
            
            if location != ""{
                multipartFormData.append(location.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"location")
            }
            
            if specialist != ""{
                multipartFormData.append(specialist.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"specialist")
            }
            

            
        }, to:ApiURLs.signup_second, method:.post, headers:APIheaders)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    
                    
                    
                    
                })
                upload.responseJSON { response in
                    
                    NVActivityIndicator.managerHandler.stopIndicator()
                    
                    
                    
                    
                    
                    
                    if response.result.isSuccess{
                        guard let data = response.data else { return }
                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: data)
                        
                        
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
                            
                            let userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
                            
                            if userRole != ""{
                                if (userRole == Role.trainer.rawValue){
                                    let storyBoard = AppStoryboard.Trainer_Setting.instance
                                    let vc = storyBoard.instantiateViewController(withIdentifier: "StripeAccountIntegration") as! StripeAccountIntegration
                                    vc.hidesBottomBarWhenPushed = true
                                    vc.isSignUp = true
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }else{
                                    UniversalMethod.universalManager.pushVC("Trainer_About", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
                                }
                            }
                            
                        }else{
                            UniversalMethod.universalManager.alertMessage("The user name or e-mail already exists.", self.navigationController)
                        }
                        
                    }else{
                        
                        UniversalMethod.universalManager.alertMessage("Upload failed, try again.", self.navigationController)
                    }
                }
            case .failure(let error):
                UniversalMethod.universalManager.alertMessage("Error in upload: \(error.localizedDescription)", self.navigationController)
                
                
            }
        }
    }
}
