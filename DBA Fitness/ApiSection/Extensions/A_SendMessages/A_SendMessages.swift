
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

/*extension Chat_VC{

 func sendMessage(parameters:[String :Any] ){
 if Connectivity.isConnectedToInternet {
 NVActivityIndicator.managerHandler.showIndicator()

 apimethod.commonMethod(url: ApiURLs.chatting, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
 NVActivityIndicator.managerHandler.stopIndicator()
 if success, let result = response as? HTTPURLResponse{
 
 if(result.statusCode==404||result.statusCode==400){

 UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)

 }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){

 chatMessages = try? JSONDecoder().decode(M_SendMessages.self, from: responseData)

 let dataStatus = chatMessages?.status
 if (dataStatus == 200 && chatMessages?.data != nil){

 //                            if let count = chatMessages?.data?.count{
 //
 //                                let olderMsgs : [M_SendMessagesData] = (chatMessages?.data?.reversed())
 //
 //                                self.chatMessagesArray = olderMsgs
 //                                self.scrollToBottom()
 //                                //self.chat_Tableview.reloadData()
 //
 //                                //self.chat_Tableview.scrollToRow(at: IndexPath(row: olderMsgs.count + 1, section: 0), at: .bottom, animated: false)
 //
 //                                /*   if self.page == 1{
                                    //                                 self.chatMessagesArray = olderMsgs
                                    //                                 self.scrollToBottom()
                                    //                                 }else{
                                    //                                 var tempSet = olderMsgs
                                    //                                 tempSet.append(contentsOf: self.chatMessagesArray)
                                    //                                 self.chatMessagesArray = tempSet
                                    //                                 self.chat_Tableview.reloadData()
                                    //                                 self.chat_Tableview.scrollToRow(at: IndexPath(row: olderMsgs.count + 1, section: 0), at: .bottom, animated: false)
                                    //                                 }*/
 //                            }

 if let count = chatMessages?.data?.count{
 let olderMsgs : [M_SendMessagesData] = (chatMessages?.data?.reversed())
 self.chatMessagesArray = olderMsgs


 self.photoURL = nil
 self.videoURL = nil

 self.chat_Tableview.delegate = self
 self.chat_Tableview.dataSource = self
 self.chat_Tableview.register(UINib(nibName: "Sender_Chat_Cell", bundle: nil), forCellReuseIdentifier: "Sender_Chat_Cell")
 self.chat_Tableview.register(UINib(nibName: "Receiver_Chat_Cell", bundle: nil), forCellReuseIdentifier: "Receiver_Chat_Cell")
 self.scrollToBottom()
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
 }*/





extension Chat_VC{

    func sendChatMessage(image:URL?,reciver_id:String, message:String, video:URL?, isHideLoader:Bool? = nil) {

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

        

        /*var sessionManager: Alamofire.SessionManager
         var backgroundSessionManager: Alamofire.SessionManager
         sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
         backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.youApp.identifier.backgroundtransfer"))

         let configuration = URLSessionConfiguration.background(withIdentifier: "com.room.myApp")
         configuration.timeoutIntervalForRequest = 10 // seconds
         let alamoFireManager = Alamofire.SessionManager(configuration: configuration)*/

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            if isHideLoader == true{

            }else{
                NVActivityIndicator.managerHandler.showIndicator()
            }

            if image != nil{
                multipartFormData.append(image!, withName: "image")
            }
            if message != ""{
                multipartFormData.append(message.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"message")
            }
            if reciver_id != ""{
                multipartFormData.append(reciver_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"reciver_id")
            }
            if video != nil{
                multipartFormData.append(video!, withName: "video")
            }

        }, to:ApiURLs.chatting, method:.post, headers:APIheaders)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in

                    
                    

                })
                upload.responseJSON { response in
                    NVActivityIndicator.managerHandler.stopIndicator()
                    
                    if response.result.isSuccess {
                        guard let responseData = response.data else {
                            UniversalMethod.universalManager.alertMessage("Welcome in Chat Session 444", self.navigationController)
                            return
                        }
                        chatMessages = try? JSONDecoder().decode(M_SendMessages.self, from: responseData)
                        if let dataStatus = chatMessages?.status, dataStatus == 200,
                           let chatData = chatMessages?.data, chatData.count > 0 {
                            let olderMsgs: [M_SendMessagesData] = chatData.reversed()
                            self.chatMessagesArray = olderMsgs
                            self.photoURL = nil
                            self.videoURL = nil
                            self.chat_Tableview.delegate = self
                            self.chat_Tableview.dataSource = self
                            self.chat_Tableview.register(UINib(nibName: "Sender_Chat_Cell", bundle: nil), forCellReuseIdentifier: "Sender_Chat_Cell")
                            self.chat_Tableview.register(UINib(nibName: "Receiver_Chat_Cell", bundle: nil), forCellReuseIdentifier: "Receiver_Chat_Cell")
                            self.scrollToBottom()
                            self.readInboxMessages(parameters:["sender_id": reciver_id] )
                        } else {
//                            UniversalMethod.universalManager.alertMessage("Welcome in Chat Session 222: photo url \(image), messages \(message), receiver id  \(reciver_id)", self.navigationController)
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


