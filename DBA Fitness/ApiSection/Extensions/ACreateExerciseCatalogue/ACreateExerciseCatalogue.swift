
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func callCreateExerciseCatalogue(parameters:[String :Any], _ newCatalogue:Bool? = nil){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.excercise_folder, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if result.statusCode == 409{
                        // Folder Name Already Exist!
                        UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "Something went wrong, please retry., please retry.")", self.navigationController)
                    }
                    
                    else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        exerciseCatalogueInfos = try? JSONDecoder().decode(M_CatalogueInfo.self, from: responseData)
                        let dataStatus = exerciseCatalogueInfos?.status
                        if (dataStatus == 200 && exerciseCatalogueInfos?.data != nil){
                            
                            var message = String()
                            if newCatalogue == true{
                                message = "Category Name Successfully Created"
                            }else{
                                message = "Category Name Successfully Renamed"
                            }
                            
                            let refreshAlert = UIAlertController(title: "DBA Fitness", message: message, preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action: UIAlertAction) in
                                NotificationCenter.default.post(name:NSNotification.Name(Constants.getCataglogueDetails), object:true)
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                        }else{
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.getCataglogueDetails), object:false)
                        }
                        //self.navigationController?.popViewController(animated: true)
                        
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



