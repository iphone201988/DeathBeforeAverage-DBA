

import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire
import SDWebImage

extension UIViewController{
    
    func addProgramTraining(
        program_id:String,
        training_name:String,
        training_description:String,
        training_video:URL?,
        training_day:String,
        apiUrl:String,
        training_id:String,
        thumbnil:URL? = nil,
        type: String = "",
        order: String = "") {
            
            func basicAuth() -> String{
                let user = "whistle"
                let password = "!@#$%_whistle_)(*&^"
                let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8) ?? Data()
                let base64Credentials = credentialData.base64EncodedString(options: [])
                
                return base64Credentials
            }
            
            let sessionkey = DataSaver.dataSaverManager.fetchData(key: "sessionkey") as? String ?? ""
            let userid = DataSaver.dataSaverManager.fetchData(key: "userid") as? String ?? ""
            
            let APIheaders: HTTPHeaders = [
                "Accept": "application/x-www-form-urlencoded",
                "Content-Type" : "application/x-www-form-urlencoded",
                "Authorization" : "Basic \(basicAuth())",
                "sessionkey" : sessionkey,
                "userid" : userid,
            ]
            
            print("header: \(APIheaders), url: \(apiUrl)")
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                NVActivityIndicator.managerHandler.showIndicator()
                
                if training_video != nil{
                    multipartFormData.append(training_video!, withName: "training_video")
                }
                
                if training_id != ""{
                    multipartFormData.append(training_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"training_id")
                }
                
                if program_id != ""{
                    multipartFormData.append(program_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"program_id")
                }
                
                if thumbnil != nil{
                    multipartFormData.append(thumbnil!, withName: "training_thumbnil")
                }
                
                
                multipartFormData.append(training_name.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"training_name")
                multipartFormData.append(training_description.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"training_description")
                multipartFormData.append(training_day.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"training_day")
                
            }, to:apiUrl, method:.post, headers:APIheaders)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        
                        
                        
                        
                    })
                    upload.responseJSON { response in
                        
                        NVActivityIndicator.managerHandler.stopIndicator()
                        
                        
                        
                        if response.result.isSuccess{
                            guard let data = response.data else { return }
                            programTrainingInfo = try? JSONDecoder().decode(M_ProgramTranining.self, from: data)
                            particularProgramTraining = programTrainingInfo?.data?.first
                            
                            if !training_id.isEmpty {
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                let storyBoard = UIStoryboard(name: AppStoryboard.Trainer_Training.rawValue, bundle: nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Training_View") as! Trainer_Training_View
                                vc.isBackToWorkoutDaysVC = true
                                vc.hidesBottomBarWhenPushed = true
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            //                        UniversalMethod.universalManager.pushVC("Trainer_Training_View", self.navigationController, storyBoard: AppStoryboard.Trainer_Training.rawValue)
                            
                        }else{
                            UniversalMethod.universalManager.alertMessage("Upload failed, try again.", self.navigationController)
                        }
                    }
                case .failure(let error):
                    UniversalMethod.universalManager.alertMessage("Error in upload: \(error.localizedDescription)", self.navigationController)
                    
                    
                }
            }
        }
}

