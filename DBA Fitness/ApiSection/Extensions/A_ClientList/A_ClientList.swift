
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension Trainer_s_Clients{
    
    func clientList(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
          
            if searchTF.text != ""{
                if (searchedString.contains(" ")){
                    replaced = searchedString.replacingOccurrences(of: " ", with: "%20")
                }else{
                    replaced = searchedString
                }
                
                if let fetchType = type{
                    newURL = ApiURLs.get_myclient + "page=\(pageNo)" + "&search=\(replaced)" + "&type=\(fetchType)"
                }else{
                    newURL = ApiURLs.get_myclient + "page=\(pageNo)" + "&search=\(replaced)" + "&type=1"
                }
                
            }else{
                
                if let fetchType = type{
                    newURL = ApiURLs.get_myclient + "page=\(pageNo)" + "&type=\(fetchType)"
                }else{
                    newURL = ApiURLs.get_myclient + "page=\(pageNo)" + "&type=1"
                }
               
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
                        
                        trainerClientList = try? JSONDecoder().decode(M_TrainerClientList.self, from: responseData)
                          
                          let dataStatus = trainerClientList?.status
                          
                          if (dataStatus == 200 && trainerClientList?.data != nil){
                              
                              var totalPages = Int()
                              var currentPages = Int()
                              
                              if trainerClientList?.pages ?? 0 > 0 && trainerClientList?.currentPage ?? 0 > 0{
                                  totalPages = trainerClientList?.pages ?? 0
                                  currentPages = trainerClientList?.currentPage ?? 0
                                  self.pageNo = currentPages
                                  let remainingPages = totalPages - currentPages
                                  DataSaver.dataSaverManager.saveData(key: "remainingPages", data: remainingPages)
                              }
                            
                            self.goals_Tableview.delegate = self
                            self.goals_Tableview.dataSource = self
                            self.goals_Tableview.register(UINib(nibName: "Clients_Info", bundle: nil), forCellReuseIdentifier: "Clients_Info")
                            self.goals_Tableview.reloadData()
                          }else{
                              self.goals_Tableview.reloadData()
                          }
                        
                        
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
                else {
                    
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}


