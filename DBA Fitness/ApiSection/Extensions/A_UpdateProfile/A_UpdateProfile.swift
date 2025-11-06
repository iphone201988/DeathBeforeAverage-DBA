
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire
import SDWebImage

extension UIViewController{
    
    // MARK: Upload Profile Pic API
    
    func updateProfile(firstname:String, lastname:String, type:String, location:String, image:URL?, specialist:String, email:String, username:String){
        
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
            
            if image != nil{
                multipartFormData.append(image!, withName: "image")
            }
            
            multipartFormData.append(email.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"email")
            multipartFormData.append(firstname.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"firstname")
            multipartFormData.append(lastname.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"lastname")
            multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"type")
            multipartFormData.append(location.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"location")
            multipartFormData.append(username.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"username")
            
            if specialist != ""{
                multipartFormData.append(specialist.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"specialist")
            }
          
        }, to:ApiURLs.update_profile, method:.post, headers:APIheaders)
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
                        }
                        NotificationCenter.default.post(name:NSNotification.Name(Constants.isUpdatedProfile), object:true)
                    }else{
                      /*  if Constants.stopUploadingDuetoBackground == "1"{
                            UniversalMethod.universalManager.alertMessage("Uploading stopped due to app in background mode, try again", self.navigationController)
                        }else{
                            UniversalMethod.universalManager.alertMessage("Something went wrong, please retry., try again", self.navigationController)
                        }*/
                         UniversalMethod.universalManager.alertMessage("Upload failed, try again.", self.navigationController)
                    }
                }
            case .failure(let error):
                UniversalMethod.universalManager.alertMessage("Error in upload: \(error.localizedDescription)", self.navigationController)
                
                
            }
        }
    }
}
