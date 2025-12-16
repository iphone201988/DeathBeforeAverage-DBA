
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension UIViewController{
    
    func trainerCommentsRating(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            apimethod.commonMethod(url: ApiURLs.add_rating_and_comment, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    debugLog("result \(result)")
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "You can rate once a month.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                       
                        trainerCommentsInfo = try? JSONDecoder().decode(M_GetTrainerComments.self, from: responseData)
                        
                        
                        if  Constants.isRatingTrainers == "1"{
                            /*let refreshAlert = UIAlertController(title: "DBA", message: "\(dict?["message"] ?? "The user name or e-mail already exists.")", preferredStyle: UIAlertController.Style.alert)*/
                            
//                            let refreshAlert = UIAlertController(title: "DBA Fitness", message: "You can only rate a Trainer once a week.", preferredStyle: UIAlertController.Style.alert)
//
//                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
//                                 NotificationCenter.default.post(name:NSNotification.Name(Constants.isUpdatedPosts), object:true)
//                            }))
//                            self.present(refreshAlert, animated: true, completion: nil)

                            // Toast.show(message: "Your rating for this trainer was successfully submitted", controller: self)

                            Toast.show(message: "\(dict?["message"] ?? "Your rating was submitted successfully.")", controller: self)

                        }else{
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.isUpdatedPosts), object:true)
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


