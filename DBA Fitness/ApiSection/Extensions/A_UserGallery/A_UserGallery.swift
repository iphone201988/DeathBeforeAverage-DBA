
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire
import SDWebImage

extension UIViewController{
    
    // MARK: Upload Profile Pic API
    
    func userGallery(image:URL?, gallery_id:String, isBackAfterReload:Bool? = nil, user_id:String? = nil){
        
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
            
            if gallery_id != ""{
                multipartFormData.append(gallery_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"gallery_id")
            }
            
            if user_id != ""{
                if let userID = user_id{
                    multipartFormData.append(userID.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"user_id")
                }
            }
            
        }, to: ApiURLs.my_gallery, method:.post, headers:APIheaders)
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
                        
                        let responseObject = response.response as Any
                        
                        
                        if isBackAfterReload == true {
                            // NotificationCenter.default.post(name:NSNotification.Name(Constants.updateGallery), object:false)
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.updateGallery), object: true)
                        }else{
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.updateGallery), object: true)
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
