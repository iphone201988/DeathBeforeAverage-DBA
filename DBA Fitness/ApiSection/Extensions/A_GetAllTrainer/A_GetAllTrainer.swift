
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension All_Trainers{

    func getAllTrainer(parameters:[String :Any], isHideIndicator: Bool = false){
        if Connectivity.isConnectedToInternet {

            let userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""

            var newURL = String()

            if (userRole == Role.trainer.rawValue){

                newURL = ApiURLs.trainer_search + "page=\(pageNo)" + "&type=2"

            }else if (userRole == Role.client.rawValue){

                newURL = ApiURLs.trainer_search + "page=\(pageNo)" + "&type=1"

            }


            /*if Constants.searchIsCertifiate != "" && Constants.searchSpecialist == "" && Constants.searchGender == ""{
             newURL = ApiURLs.trainer_search + "page=\(pageNo)" + Constants.searchIsCertifiate
             }else if (Constants.searchIsCertifiate == "" && Constants.searchSpecialist != "" && Constants.searchGender == ""){
             newURL = ApiURLs.trainer_search + "page=\(pageNo)" + Constants.searchSpecialist
             }else if (Constants.searchIsCertifiate == "" && Constants.searchSpecialist == "" && Constants.searchGender != ""){
             newURL = ApiURLs.trainer_search + "page=\(pageNo)" + Constants.searchGender
             }else if (Constants.searchIsCertifiate != "" && Constants.searchSpecialist != "" && Constants.searchGender != ""){
             newURL = ApiURLs.trainer_search + "page=\(pageNo)" + Constants.searchIsCertifiate + Constants.searchSpecialist + Constants.searchGender
             }else{
             newURL = ApiURLs.trainer_search + "page=\(pageNo)"
             }*/

            if !Constants.searchLocation.isEmpty {
                let searchLocation = Constants.searchLocation
                var updatedLocationParam = searchLocation
                if (searchLocation.contains(" ")) {
                    updatedLocationParam = searchLocation.replacingOccurrences(of: " ", with: "%20")
                }
                newURL = newURL + updatedLocationParam
            }

            if Constants.searchIsCertifiate != ""{
                newURL = newURL + Constants.searchIsCertifiate
            }

            if Constants.searchSpecialist != ""{
                newURL = newURL + Constants.searchSpecialist
            }

            if Constants.searchGender != ""{
                newURL = newURL + Constants.searchGender
            }

            if searchTF.text != ""{
                if (searchedString.contains(" ")){
                    replaced = searchedString.replacingOccurrences(of: " ", with: "%20")
                }else{
                    replaced = searchedString
                }
                newURL = newURL + "&trainer_name=\(replaced)"
            }




            if isHideIndicator {

            } else {
                NVActivityIndicator.managerHandler.showIndicator()
            }

            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in

                NVActivityIndicator.managerHandler.stopIndicator()

                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400||result.statusCode == 401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){

                        allTrainerInfo = try? JSONDecoder().decode(M_GetAllTrainer.self, from: responseData)

                        let dataStatus = allTrainerInfo?.status

                        if (dataStatus == 200 && allTrainerInfo?.data != nil){

                            var totalPages = Int()
                            var currentPages = Int()

                            if allTrainerInfo?.pages ?? 0 > 0 && allTrainerInfo?.currentPage ?? 0 > 0{
                                totalPages = allTrainerInfo?.pages ?? 0
                                currentPages = allTrainerInfo?.currentPage ?? 0
                                self.pageNo = currentPages
                                let remainingPages = totalPages - currentPages
                                
                                DataSaver.dataSaverManager.saveData(key: "remainingPages", data: remainingPages)
                            }

                            self.goals_Tableview.delegate = self
                            self.goals_Tableview.dataSource = self
                            self.goals_Tableview.register(UINib(nibName: "Trainers_List_Cell", bundle: nil), forCellReuseIdentifier: "Trainers_List_Cell")
                            self.goals_Tableview.reloadData()

                        }else{
                            self.goals_Tableview.reloadData()
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



