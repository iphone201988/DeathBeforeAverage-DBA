
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension Trainer_Training_Section{
    
    func getProgramTraining(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            let newURL = ApiURLs.get_all_training + "page=\(pageNo)"  + "&dayID=\(dayID)" + "&program_id=\(particularPrograms?.id ?? "0")"
            
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
                        
                        programTrainingInfo = try? JSONDecoder().decode(M_ProgramTranining.self, from: responseData)
                        
                        let dataStatus = programTrainingInfo?.status
                        
                        if (dataStatus == 200 && programTrainingInfo?.data != nil){
                            
                            var totalPages = Int()
                            var currentPages = Int()
                            
                            if programTrainingInfo?.pages ?? 0 > 0 && programTrainingInfo?.currentPage ?? 0 > 0{
                                totalPages = programTrainingInfo?.pages ?? 0
                                currentPages = programTrainingInfo?.currentPage ?? 0
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

