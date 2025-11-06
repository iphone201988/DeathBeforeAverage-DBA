
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension Trainer_Meal_View{
    
    func deleteMeal(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.delete_meal, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        programMealInfo = try? JSONDecoder().decode(M_ProgramMealInfo.self, from: responseData)
                        
                        let dataStatus = programMealInfo?.status
                        if (dataStatus == 200 && programMealInfo?.data != nil){
                            self.exercise_Program_Tableview.delegate = self
                            self.exercise_Program_Tableview.dataSource = self
                            self.exercise_Program_Tableview.register(UINib(nibName: "Nutrition_Days_Cell", bundle: nil), forCellReuseIdentifier: "Nutrition_Days_Cell")
                            self.exercise_Program_Tableview.reloadData()
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


