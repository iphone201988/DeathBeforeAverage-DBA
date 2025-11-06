
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension Trainer_Exercise_Programs{
    
    func getPrograms(parameters:[String :Any]){
        if Connectivity.isConnectedToInternet {
            
            let newURL = ApiURLs.get_all_program + "page=\(pageNo)" + "&type=\(userRole)"
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        programInfos = try? JSONDecoder().decode(M_ProgramDetails.self, from: responseData)
                    
                        let dataStatus = programInfos?.status
                        
                        if (dataStatus == 200 && programInfos?.data != nil){
                            
                            var totalPages = Int()
                            var currentPages = Int()
                            
                           if programInfos?.pages ?? 0 > 0 && programInfos?.currentPage ?? 0 > 0{
                                totalPages = programInfos?.pages ?? 0
                                currentPages = programInfos?.currentPage ?? 0
                                self.pageNo = currentPages
                                let remainingPages = totalPages - currentPages
                                
                                DataSaver.dataSaverManager.saveData(key: "remainingPages", data: remainingPages)
                            }
                            
                            self.exercise_Program_Tableview.delegate = self
                            self.exercise_Program_Tableview.dataSource = self
                            self.exercise_Program_Tableview.register(UINib(nibName: "Trainer_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Trainer_Programs_Cell")
                            self.exercise_Program_Tableview.register(UINib(nibName: "Exercise_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Exercise_Programs_Cell")
                            self.exercise_Program_Tableview.register(UINib(nibName: "Client_Program_Cell", bundle: nil), forCellReuseIdentifier: "Client_Program_Cell")
                            self.exercise_Program_Tableview.register(UINib(nibName: "Client_Progress", bundle: nil), forCellReuseIdentifier: "Client_Progress")
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



extension Client_Exercise_Programs{
    
    func getPrograms(parameters:[String :Any]){
        if Connectivity.isConnectedToInternet {
            
            let newURL = ApiURLs.get_all_program + "page=\(pageNo)" + "&type=\(userRole)"
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        programInfos = try? JSONDecoder().decode(M_ProgramDetails.self, from: responseData)
                    
                        let dataStatus = programInfos?.status
                        
                        if (dataStatus == 200 && programInfos?.data != nil){
                            
                            var totalPages = Int()
                            var currentPages = Int()
                            
                           if programInfos?.pages ?? 0 > 0 && programInfos?.currentPage ?? 0 > 0{
                                totalPages = programInfos?.pages ?? 0
                                currentPages = programInfos?.currentPage ?? 0
                                self.pageNo = currentPages
                                let remainingPages = totalPages - currentPages
                                
                                DataSaver.dataSaverManager.saveData(key: "remainingPages", data: remainingPages)
                            }
                            
                            self.exercise_Program_Tableview.delegate = self
                            self.exercise_Program_Tableview.dataSource = self
                            self.exercise_Program_Tableview.register(UINib(nibName: "Trainer_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Trainer_Programs_Cell")
                            self.exercise_Program_Tableview.register(UINib(nibName: "Exercise_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Exercise_Programs_Cell")
                            self.exercise_Program_Tableview.register(UINib(nibName: "Client_Program_Cell", bundle: nil), forCellReuseIdentifier: "Client_Program_Cell")
                            self.exercise_Program_Tableview.register(UINib(nibName: "Client_Progress", bundle: nil), forCellReuseIdentifier: "Client_Progress")
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
