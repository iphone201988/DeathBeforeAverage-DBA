
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension ProgramPurchasedORPurchaserList{
    
    func getPurchasedORPurchaserList(parameters:[String :Any], endPoint:String){
        if Connectivity.isConnectedToInternet {
            
            apimethod.commonMethod(url: endPoint, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                
                if success, let result = response as? HTTPURLResponse{
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        purchasedORPurchaserInfo = try? JSONDecoder().decode(M_ProgramDetails.self, from: responseData)
                    
                        let dataStatus = purchasedORPurchaserInfo?.status
                        
                        if (dataStatus == 200 && purchasedORPurchaserInfo?.data != nil){
                            self.programPurchasedORPurchaserListTableView.delegate = self
                            self.programPurchasedORPurchaserListTableView.dataSource = self
                            self.programPurchasedORPurchaserListTableView.register(UINib(nibName: "Client_Program_Cell", bundle: nil), forCellReuseIdentifier: "Client_Program_Cell")
                            self.programPurchasedORPurchaserListTableView.reloadData()
                        }else{
                              self.programPurchasedORPurchaserListTableView.reloadData()
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



