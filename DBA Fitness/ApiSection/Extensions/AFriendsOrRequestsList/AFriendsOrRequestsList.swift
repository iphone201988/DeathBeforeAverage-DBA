

import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension FriendsAndRequestsList{
    
    func getFriendsOrRequestsListAPI(parameters:[String :Any],type:String ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
          
            let newURL = ApiURLs.get_all_myfriend + type
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse {
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        friendsOrRequestsList = try? JSONDecoder().decode(M_TrainerClientList.self, from: responseData)
                          
                          let dataStatus = friendsOrRequestsList?.status
                          
                          if (dataStatus == 200 && friendsOrRequestsList?.data != nil){
                            self.trainer_Post_Tableview.delegate = self
                            self.trainer_Post_Tableview.dataSource = self
                            self.trainer_Post_Tableview.register(UINib(nibName: "Clients_Info", bundle: nil), forCellReuseIdentifier: "Clients_Info")
                            self.trainer_Post_Tableview.reloadData()
                          }else{
                              self.trainer_Post_Tableview.reloadData()
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
    
    func callAcceptORRejectRequest(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.accept_request, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401 || result.statusCode == 403){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                       
                        self.getFriendsOrRequestsListAPI(parameters:[:],type:"2" )
                     
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



extension NotificationLists{
    
    func getNotificationLists(parameters:[String :Any],type:String? = nil ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
          
            let newURL = ApiURLs.get_all_notification
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        notificationListDetails = try? JSONDecoder().decode(MNotificationLists.self, from: responseData)
                          
                          let dataStatus = notificationListDetails?.status
                          
                          if (dataStatus == 200 && notificationListDetails?.data != nil){
                            self.trainer_Post_Tableview.delegate = self
                            self.trainer_Post_Tableview.dataSource = self
                            self.trainer_Post_Tableview.register(UINib(nibName: "Clients_Info", bundle: nil), forCellReuseIdentifier: "Clients_Info")
                            self.trainer_Post_Tableview.reloadData()
                          }else{
                              self.trainer_Post_Tableview.reloadData()
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
