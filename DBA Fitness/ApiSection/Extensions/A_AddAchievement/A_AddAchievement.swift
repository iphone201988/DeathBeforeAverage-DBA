
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire
import SDWebImage

extension UIViewController{
    
    func addAchievement(year: String? = nil,
                        event: String? = nil,
                        image: [URL]?,
                        junior_absolute: String? = nil,
                        men_up_to_90_kg: String? = nil,
                        apiUrl:String,
                        achievement_id:String,
                        type: String? = nil){
        
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
            
            if image?.count ?? 0 > 0{
                if let image {
                    for imageLink in image {
                        multipartFormData.append(imageLink, withName: "image[]")
                    }
                }

            }
            
            if achievement_id != ""{
                multipartFormData.append(achievement_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"achievement_id")
            }

            if let year {
                multipartFormData.append(year.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"year")
            }

            if let event {
                multipartFormData.append(event.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"event")
            }

            if let junior_absolute {
                multipartFormData.append(junior_absolute.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"junior_absolute")
            }

            if let men_up_to_90_kg {
                multipartFormData.append(men_up_to_90_kg.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"men_up_to_90_kg")
            }

            if let type {
                multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(),
                                         withName :"type")
            }

        }, to:apiUrl, method:.post, headers:APIheaders)
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
                        //self.tabBarController?.tabBar.isHidden = false
                        if let type {
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.updateDeleteAchievement),
                                                            object:true)
                        } else {
                            self.navigationController?.popViewController(animated: true)
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

extension Load_Certificates{
    
    func updateGallery(image: URL?, achievement_id: String, type: String? = nil, update_image: String? = nil){
        
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
            
            if image != nil {
                if let image {
                    multipartFormData.append(image, withName: "image")
                }
                
            }
            
            if achievement_id != ""{
                multipartFormData.append(achievement_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"achievement_id")
            }

            if let type, !type.isEmpty { // is responsible for delete action
                multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"type")
            }

            if let update_image { // is responsible for delete action
                multipartFormData.append(update_image.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"update_image")
            }
            
        }, to:ApiURLs.achievement_gallery, method:.post, headers:APIheaders)
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
                        //particularAcheivementInfo = userInfo?.achievement?.first
                        particularAcheivementInfo = userInfo?.achievement?[Constants.selectedAchievementIndex]
                        self.certificates_Collectionview.reloadData()
                    
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
