
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire
import SDWebImage

extension UIViewController{
    
    func addExercise(excercise_name:String,
                     excercise_description:String,
                     excercise_image:[URL]?,
                     excercise_video:URL?,
                     excercise_id:String,
                     apiUrl:String,
                     thumbnil:URL?,
                     training_id:String,
                     program_id:String,
                     exercise_info:String? = nil,
                     sets:String? = nil,
                     reps:String? = nil,
                     time:String? = nil,
                     type: String? = nil){
        
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
        
        debugLog("excercise_name: \(excercise_name)\n, excercise_description: \(excercise_description)\n, excercise_image: \(excercise_image)\n, excercise_video: \(excercise_video)\n, excercise_id: \(excercise_id)\n, apiUrl: \(apiUrl)\n, thumbnil: \(thumbnil)\n, training_id: \(training_id)\n, program_id: \(program_id)\n, exercise_info: \(exercise_info)\n, sets: \(sets)\n, reps: \(reps)\n, time: \(time)\n, type: \(type)\n")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            NVActivityIndicator.managerHandler.showIndicator()
            
            if excercise_image?.count ?? 0 > 0 {
                if let excercise_image {
                    for imageLink in excercise_image {
                        multipartFormData.append(imageLink, withName: "excercise_image[]") // excercise_image[]
                    }
                }
                
            }
            
            if excercise_video != nil{
                multipartFormData.append(excercise_video!, withName: "excercise_video")
            }
            
            if thumbnil != nil{
                multipartFormData.append(thumbnil!, withName: "thumbnil")
            }
            
            if let exerciseInfo = exercise_info{
                multipartFormData.append(exerciseInfo.data(using: String.Encoding.utf8,
                                                           allowLossyConversion: false) ?? Data(),
                                         withName :"exercise_info")
            }
            
            if excercise_id != ""{
                multipartFormData.append(excercise_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"excercise_id")
            }
            
            multipartFormData.append(selectedCatalgoueID.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"folder_id")
            
            multipartFormData.append(excercise_name.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"excercise_name")
            
            multipartFormData.append(excercise_description.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"excercise_description")
            
            if training_id != ""{
                multipartFormData.append(training_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"training_id")
            }
            
            if program_id != ""{
                multipartFormData.append(program_id.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"program_id")
            }
            
            if let setsNo = sets{
                multipartFormData.append(setsNo.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"sets")
            }
            
            if let respsNo = reps{
                multipartFormData.append(respsNo.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"reps")
            }
            
            if let duration = time{
                multipartFormData.append(duration.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"time")
            }
            
            if let type, !type.isEmpty {
                multipartFormData.append(
                    type.data(
                        using: String.Encoding.utf8,
                        allowLossyConversion: false
                    ) ?? Data(),
                    withName :"type"
                )
            }
            
            multipartFormData.append("1".data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"ismergedExercise")
            
            //ismergedExercise
            
        }, to:apiUrl, method:.post, headers:APIheaders)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    
                    
                    
                    
                })
                upload.responseJSON { response in
                    
                    NVActivityIndicator.managerHandler.stopIndicator()
                    
                    debugLog("result: \(response.result.debugDescription)")
                    
                    if response.result.isSuccess{
                        guard let data = response.data else { return }
                        exerciseInfos = try? JSONDecoder().decode(M_ExerciseDetails.self, from: data)
                        
                        if training_id != "" && program_id != ""{
                            NotificationCenter.default.post(name:NSNotification.Name("reloadTrainingExerciseTableView"), object:true)
                        }
                        
                        particularExercise = exerciseInfos?.data?.first
                        self.navigationController?.popViewController(animated: true)
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






extension Trainer_Training_View{
    
    func getAllTrainingExercise(parameters:[String :Any], type:Int ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            /*
             type:1:trainer
             type:2:client
             */
            
            let newURL = ApiURLs.get_excercise_training + "?training_id=\(particularProgramTraining?.id ?? "0")" + "&program_id=\(particularProgramTraining?.programID ?? "0")" + "&type=\(type)"
            
            //let newURL = ApiURLs.get_excercise_training
            
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
                        exerciseInfos = try? JSONDecoder().decode(M_ExerciseDetails.self, from: responseData)
                        let dataStatus = exerciseInfos?.status
                        // self.workoutExercisesDetail = exerciseInfos?.data ?? []
                        let exercisesDetail = exerciseInfos?.data ?? []
                        self.workoutExercisesDetail = self.sortExercisesByPosition(exercisesDetail)
                        
                        if (dataStatus == 200 && exerciseInfos?.data != nil){
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.register(UINib(nibName: "Exercise_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Exercise_Programs_Cell")
                            self.tableView.register(UINib(nibName: "Client_Progress", bundle: nil), forCellReuseIdentifier: "Client_Progress")
                            self.tableView.reloadData()
                        }else{
                            self.tableView.reloadData()
                        }
                        self.isWorkoutExercisesShuffled = false
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
    
    // Function to sort the array based on the position property
    func sortExercisesByPosition(_ exercises: [M_ExerciseData]) -> [M_ExerciseData] {
        return exercises.sorted { (first, second) -> Bool in
            // Convert position to integers, defaulting to 0 if nil or not convertible
            let firstPosition = Int(first.position ?? "") ?? 0
            let secondPosition = Int(second.position ?? "") ?? 0
            // Sort in ascending order; use < for ascending, > for descending
            return firstPosition < secondPosition
        }
    }
}
