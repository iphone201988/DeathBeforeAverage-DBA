
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension Client_Review{
    
    func clientAllReviews(parameters:[String :Any], anotherUserID: String = ""){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            var newURL = ""
            if anotherUserID.isEmpty {
                newURL = ApiURLs.get_all_reviews + "page=\(pageNo)" + "&type=\(ratingAndCommentsFetchingType.rawValue)"
            } else {
                newURL = ApiURLs.get_all_reviews_by_id + "?page=\(pageNo)" + "&userid=\(anotherUserID)"
            }
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
                        
                        clientReviewsInfo = try? JSONDecoder().decode(M_ClientAllReviews.self, from: responseData)
                        
                        let dataStatus = clientReviewsInfo?.status
                        
                        if (dataStatus == 200 && clientReviewsInfo?.data != nil){
                            
                            var totalPages = Int()
                            var currentPages = Int()
                            
                            if clientReviewsInfo?.pages ?? 0 > 0 && clientReviewsInfo?.currentPage ?? 0 > 0{
                                totalPages = clientReviewsInfo?.pages ?? 0
                                currentPages = clientReviewsInfo?.currentPage ?? 0
                                self.pageNo = currentPages
                                let remainingPages = totalPages - currentPages
                                DataSaver.dataSaverManager.saveData(key: "remainingPages", data: remainingPages)
                            }
                            self.review_Tableview.delegate = self
                            self.review_Tableview.dataSource = self
                            self.review_Tableview.register(UINib(nibName: "Reviews", bundle: nil), forCellReuseIdentifier: "Reviews")
                            self.review_Tableview.reloadData()
                        }else{
                            self.review_Tableview.reloadData()
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

