
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension User_Profile{
    
    func userFollow(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            var newURL = ""
            if isFollowUnfollow == 1{
                newURL = ApiURLs.userunFollow
            }else{
                newURL = ApiURLs.userFollow
            }
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                        
                       
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        /* if let existingLayer = (self.messageView.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
                         existingLayer.removeFromSuperlayer()
                         }*/
                        
                        let isFollowInfos = try? JSONDecoder().decode(M_isFollow.self, from: responseData)
                        
                        if isFollowInfos?.data?.isfollow == 1{
                            self.followingAction_View.gradientBackground(from: self.startColor, to: self.endColor, direction: .leftToRight)
                            self.followingAction_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
                            self.isFollowTitle.text = "Following"
                            self.isFollowUnfollow = 1
                        }else{
                            if let existingLayer = (self.followingAction_View.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
                                existingLayer.removeFromSuperlayer()
                            }
                            self.followingAction_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
                            self.isFollowTitle.text = "Follow"
                            self.isFollowUnfollow = 0
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

extension Trainer_Detail_View{
    
    func userFollow(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            var newURL = ""
            if isFollowUnfollow == 1{
                newURL = ApiURLs.userunFollow
            }else{
                newURL = ApiURLs.userFollow
            }
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        /* if let existingLayer = (self.messageView.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
                         existingLayer.removeFromSuperlayer()
                         }*/
                        
                       /* let isFollowInfos = try? JSONDecoder().decode(M_isFollow.self, from: responseData)
                        
                        if isFollowInfos?.data?.isfollow == 1{
                            self.followingAction_View.gradientBackground(from: self.startColor, to: self.endColor, direction: .leftToRight)
                            self.followingAction_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
                            self.isFollowTitle.text = "Following"
                            self.isFollowUnfollow = 1
                        }else{
                            if let existingLayer = (self.followingAction_View.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
                                existingLayer.removeFromSuperlayer()
                            }
                            self.followingAction_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
                            self.isFollowTitle.text = "Follow"
                            self.isFollowUnfollow = 0
                        }*/
                        
                        self.userProfileInfo(parameters:[:] )
                        
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

