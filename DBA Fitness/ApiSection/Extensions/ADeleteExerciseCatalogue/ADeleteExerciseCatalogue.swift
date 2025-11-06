
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func callDeleteExerciseCatalogue(parameters:[String :Any] , indexToRemove : Int? = nil ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.delete_excercise_folder, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        exerciseCatalogueInfos = try? JSONDecoder().decode(M_CatalogueInfo.self, from: responseData)
                        let dataStatus = exerciseCatalogueInfos?.status
                        
                        //Added by Geetam to fix a bug that didn't remove the exercise on successfull execution of delete exercise api
                        if let indexToRemove {
                            exerciseInfos?.data?.remove(at: indexToRemove)
                        }
                        
                        if (dataStatus == 200 && exerciseCatalogueInfos?.data != nil){
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.getCataglogueDetails), object:true)
                        }else{
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.getCataglogueDetails), object:false)
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


