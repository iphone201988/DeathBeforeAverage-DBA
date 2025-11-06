
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire
import SDWebImage

extension UIViewController{
    
    // description,image(optional)
    
    func addProgress(description: String? = nil,
                     image: [URL]?,
                     apiUrl: String,
                     progress_id: String,
                     type: String? = nil,
                     update_image: String? = nil){
        
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
            
            if progress_id != ""{
                multipartFormData.append(progress_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"progress_id")
            }

            if let description {
                multipartFormData.append(description.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"description")
            }

            if let type, !type.isEmpty {
                multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(),
                                         withName :"type")
            }

            if let update_image {
                multipartFormData.append(update_image.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(),
                                         withName :"update_image")
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
                        if progress_id != ""{
                            clientProgressInfo = try? JSONDecoder().decode(M_ClientProgress.self, from: data)
                            particularClientProgress = clientProgressInfo?.data?.first
                        }

                        if let type {
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.updateEditProgress),
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
    
    
    func addGoalAPI(description:String? = nil,
                    image:[URL]?,
                    apiUrl:String,
                    goal_id:String,
                    video:[URL]?,
                    thumbnil:[URL]?,
                    title:String? = nil,
                    type: String? = nil,
                    update_image: String? = nil){
        
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
            
            if video?.count ?? 0 > 0{
                if let video {
                    for videoLink in video {
                        multipartFormData.append(videoLink, withName: "video[]")
                    }
                }

            }
            
            if thumbnil?.count ?? 0 > 0{
                if let thumbnil {
                    for videoThumbnailLink in thumbnil {
                        multipartFormData.append(videoThumbnailLink, withName: "thumbnil[]")
                    }
                }

            }
            
            if goal_id != ""{
                multipartFormData.append(goal_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"goal_id")
            }
            
            if let title {
                multipartFormData.append(title.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"title")
            }

            if let description {
                multipartFormData.append(description.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"description")
            }

            if let type, !type.isEmpty {
                multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(),
                                         withName :"type")
            }

            if let update_image {
                multipartFormData.append(update_image.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(),
                                         withName :"update_image")
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
                        if let type, !type.isEmpty {

                            if let addedGoals = userInfo?.goal {
                                for goal in addedGoals {
                                    if goal.id == goal_id {
                                        particularGoalInfo = goal
                                        NotificationCenter.default.post(name:NSNotification.Name(Constants.updateEditGoals),
                                                                        object:true)
                                    }
                                }
                            }
                        } else {
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.addGoals), object:true)
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
