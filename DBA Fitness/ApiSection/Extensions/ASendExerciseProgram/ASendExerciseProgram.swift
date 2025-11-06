
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func callSendExerciseProgram(parameters:[String :Any], _ isExerciseCatalogue:Bool? = nil ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            var remoteURL = String()
            if isExerciseCatalogue == true{
                remoteURL = ApiURLs.share_excercise_folder
            }else{
                remoteURL = ApiURLs.send_program_or_excercise_to_client
            }
            
            apimethod.commonMethod(url: remoteURL, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        let refreshAlert = UIAlertController(title: "DBA Fitness", message: "Successfully sent to client", preferredStyle: UIAlertController.Style.alert)

                        refreshAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action: UIAlertAction) in
                            
                            //clientList(parameters:[:] )
                            self.navigationController?.popViewController(animated: true)
                            
                            
                        }))
                        self.present(refreshAlert, animated: true, completion: nil)
                    
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



