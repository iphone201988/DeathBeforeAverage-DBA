
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension Client_Progress_View{
    
    func getProgress(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            var newURL = String()
            
            if self.searchedClientUserID == ""{
                newURL = ApiURLs.get_client_progress + "page=\(pageNo)"
            }else{
                newURL = ApiURLs.get_client_progress + "page=\(pageNo)" + "&userid=\(self.searchedClientUserID)"
            }
            
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
                        
                        clientProgressInfo = try? JSONDecoder().decode(M_ClientProgress.self, from: responseData)
                     
                        let dataStatus = clientProgressInfo?.status
                        
                        if (dataStatus == 200 && clientProgressInfo?.data != nil){
                            
                            var totalPages = Int()
                            var currentPages = Int()
                            
                            if clientProgressInfo?.pages ?? 0 > 0 && clientProgressInfo?.currentPage ?? 0 > 0{
                                totalPages = clientProgressInfo?.pages ?? 0
                                currentPages = clientProgressInfo?.currentPage ?? 0
                                self.pageNo = currentPages
                                let remainingPages = totalPages - currentPages
                                DataSaver.dataSaverManager.saveData(key: "remainingPages", data: remainingPages)
                            }
                            self.exercise_Program_Tableview.delegate = self
                            self.exercise_Program_Tableview.dataSource = self
                            self.exercise_Program_Tableview.register(UINib(nibName: "Trainer_Trainings_Cell", bundle: nil), forCellReuseIdentifier: "Trainer_Trainings_Cell")
                            self.exercise_Program_Tableview.reloadData()
                        }else{
                            self.exercise_Program_Tableview.reloadData()
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

