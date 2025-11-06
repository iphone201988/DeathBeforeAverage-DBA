
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension FollowerANDFollowingList{
    
    func getFollowersANDFollowingList(parameters:[String :Any], type:String){
        if Connectivity.isConnectedToInternet {
            
            let newURL = ApiURLs.get_my_follower_and_following_list + type
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                
                if success, let result = response as? HTTPURLResponse{
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        followerANDFollowingUserInfo = try? JSONDecoder().decode(FollowerANDFollowingUserInfo.self, from: responseData)
                    
                        let dataStatus = followerANDFollowingUserInfo?.status
                        
                        if (dataStatus == 200 && followerANDFollowingUserInfo?.data != nil){
                            self.followersANDFollowingListTableView.delegate = self
                            self.followersANDFollowingListTableView.dataSource = self
                            self.followersANDFollowingListTableView.register(UINib(nibName: "Clients_Info", bundle: nil), forCellReuseIdentifier: "Clients_Info")
                            self.followersANDFollowingListTableView.reloadData()
                        }else{
                              self.followersANDFollowingListTableView.reloadData()
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



