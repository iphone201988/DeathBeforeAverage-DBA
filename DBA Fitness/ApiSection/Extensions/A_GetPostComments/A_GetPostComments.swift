
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension PostComments{
    
    func postComments(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            var newUrl = ""
            var httpMethod = ""
            
            if isCommented == true{
                httpMethod = "POST"
                newUrl = ApiURLs.add_comment
            }else{
                httpMethod = "GET"
                newUrl = ApiURLs.get_comment + "post_id=\(particularPostInfo?.postID ?? "0")"
            }
            
            apimethod.commonMethod(url: newUrl, parameters: parameters, method: httpMethod) { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                       
                        postCommentsInfo = try? JSONDecoder().decode(M_GetPostComments.self, from: responseData)
                     
                        let dataStatus = postCommentsInfo?.status
                        if (dataStatus == 200 && postCommentsInfo?.data != nil){
                            
                            if let count = postCommentsInfo?.data?.count{
                                
                                //let olderMsgs : [M_GetPostCommentsData] = (postCommentsInfo?.data?.reversed()) ?? []
                                
                                let olderMsgs : [M_GetPostCommentsData] = (postCommentsInfo?.data) ?? []
                                
                                self.chatMessagesArray = olderMsgs
                                self.scrollToBottom()
                                //self.chat_Tableview.reloadData()
                                
                                //self.chat_Tableview.scrollToRow(at: IndexPath(row: olderMsgs.count + 1, section: 0), at: .bottom, animated: false)
                                
                                /*   if self.page == 1{
                                 self.chatMessagesArray = olderMsgs
                                 self.scrollToBottom()
                                 }else{
                                 var tempSet = olderMsgs
                                 tempSet.append(contentsOf: self.chatMessagesArray)
                                 self.chatMessagesArray = tempSet
                                 self.chat_Tableview.reloadData()
                                 self.chat_Tableview.scrollToRow(at: IndexPath(row: olderMsgs.count + 1, section: 0), at: .bottom, animated: false)
                                 }*/
                            }
                            
                        }else{
                            UniversalMethod.universalManager.alertMessage("Welcome in Chat Session", self.navigationController)
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

