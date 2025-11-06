

import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension Trainer_Exercise_Programs{
    
    func getExercise(parameters:[String :Any]){
        if Connectivity.isConnectedToInternet {
            
            let newURL = ApiURLs.get_all_excercise + "page=\(pageNo)" + "&type=\(userRole)"
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            
                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        exerciseInfos = try? JSONDecoder().decode(M_ExerciseDetails.self, from: responseData)
                    
                        let dataStatus = exerciseInfos?.status
                        
                        if (dataStatus == 200 && exerciseInfos?.data != nil){
                            
                            var totalPages = Int()
                            var currentPages = Int()
                            
                           if exerciseInfos?.pages ?? 0 > 0 && exerciseInfos?.currentPage ?? 0 > 0{
                                totalPages = exerciseInfos?.pages ?? 0
                                currentPages = exerciseInfos?.currentPage ?? 0
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



extension UIViewController{
    
    func getExerciseByFolderID(parameters:[String :Any], _ folderID:String? = nil){
        if Connectivity.isConnectedToInternet {
            
            let newURL = ApiURLs.get_excercise_by_folderId + "\(folderID ?? "1")" + "&page=1"
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        exerciseInfos = try? JSONDecoder().decode(M_ExerciseDetails.self, from: responseData)
                    
                        
                        let dataStatus = exerciseInfos?.status
                        
                        if (dataStatus == 200 && exerciseInfos?.data != nil){
                            
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.getCataglogueDetails), object:true)
                            
                           /* self.exercise_Program_Tableview.delegate = self
                            self.exercise_Program_Tableview.dataSource = self
                            self.exercise_Program_Tableview.register(UINib(nibName: "Trainer_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Trainer_Programs_Cell")
                            self.exercise_Program_Tableview.register(UINib(nibName: "Exercise_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Exercise_Programs_Cell")
                            self.exercise_Program_Tableview.register(UINib(nibName: "Client_Program_Cell", bundle: nil), forCellReuseIdentifier: "Client_Program_Cell")
                            self.exercise_Program_Tableview.register(UINib(nibName: "Client_Progress", bundle: nil), forCellReuseIdentifier: "Client_Progress")
                            self.exercise_Program_Tableview.reloadData()*/
                            
                        }else{
                            
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.getCataglogueDetails), object:false)
                              //self.exercise_Program_Tableview.reloadData()
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
