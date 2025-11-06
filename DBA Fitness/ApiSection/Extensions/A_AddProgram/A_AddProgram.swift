
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func addProgram(parameters:[String :Any] ,indexToRemove:Int? = 0){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            var newURL = ""
            if Constants.isEditProgram == "1"{
                newURL = ApiURLs.update_program
            }else if (Constants.isEditProgram == "0"){
                newURL = ApiURLs.add_program
            }else if (Constants.isEditProgram == "2"){
                newURL = ApiURLs.delete_program
            }
            
            apimethod.commonMethod(url: newURL, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        if Constants.isEditProgram == "0" {
                            //Navigate to program building interface
                            programInfos = try? JSONDecoder().decode(M_ProgramDetails.self, from: responseData)
                            particularPrograms = programInfos?.data?.first
                            let storyBoard = AppStoryboard.Trainer_Program.instance
                            let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Program_Details") as! Trainer_Program_Details
                            vc.hidesBottomBarWhenPushed = true
                            self.navigationController?.pushViewController(vc, animated: true)

                            // self.navigationController?.popViewController(animated: true)
                        }else if (Constants.isEditProgram == "1"){
                            programInfos = try? JSONDecoder().decode(M_ProgramDetails.self, from: responseData)
                            particularPrograms = programInfos?.data?.first
                            self.navigationController?.popViewController(animated: true)
                        }else if (Constants.isEditProgram == "2"){
                            if let indexToRemove {
                                programInfos?.data?.remove(at: indexToRemove)
                            }
//                            programInfos = try? JSONDecoder().decode(M_ProgramDetails.self, from: responseData)
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.getProgramsDetails), object:true)
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

extension Trainer_Exercise_Programs{
    func copyProgram(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.copy_program,
                                   parameters: parameters,
                                   method: "POST") { (_ dict, _ success: Bool ,
                                                      _ error: Error?,
                                                      _ response: Any,
                                                      _ responseData) in
                
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        self.getPrograms(parameters:[:])
                        
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
