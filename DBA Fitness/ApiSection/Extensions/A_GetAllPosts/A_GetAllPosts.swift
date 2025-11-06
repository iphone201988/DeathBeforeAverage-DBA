
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire

extension Trainer_Post_View {

    func getAllPosts(parameters:[String :Any], isScrollToBottom:Bool? = nil ) {
        if Connectivity.isConnectedToInternet {

            //let newURL = ApiURLs.get_all_post + "page=\(pageNo)"
            let newURL = ApiURLs.get_global_and_personal_feed + Constants.selectedCurrentFeedTab //Constants.currentTab
            
           

            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in

                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){

                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            
                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){

                        allPosts = try? JSONDecoder().decode(M_AllPosts.self, from: responseData)

                        let dataStatus = allPosts?.status

                        if (dataStatus == 200 && allPosts?.data != nil){

                            var totalPages = Int()
                            var currentPages = Int()
                            
                            if allPosts?.pages ?? 0 > 0 && allPosts?.currentPage ?? 0 > 0{
                                totalPages = allPosts?.pages ?? 0
                                currentPages = allPosts?.currentPage ?? 0
                                self.pageNo = currentPages
                                let remainingPages = totalPages - currentPages
                                
                                DataSaver.dataSaverManager.saveData(key: "remainingPages", data: remainingPages)
                            }
                            
                            self.trainer_Post_Tableview.delegate = self
                            self.trainer_Post_Tableview.dataSource = self
                            self.trainer_Post_Tableview.register(UINib(nibName: "Trainer_Post_Cell", bundle: nil), forCellReuseIdentifier: "Trainer_Post_Cell")
                            self.trainer_Post_Tableview.reloadData()
                            
                            if isScrollToBottom == true{
                                if !Constants.selectedGalleryPhotoAssociatedPostID.isEmpty{
                                    _ = allPosts?.data?.enumerated().compactMap({ index, element in
                                        if element.postID == Constants.selectedGalleryPhotoAssociatedPostID {
                                            if allPosts?.data?.count ?? 0 > 2 {
                                                self.trainer_Post_Tableview.scrollToRow(at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
                                            }
                                        }
                                    })
                                }
                            }
                        }else{
                            self.trainer_Post_Tableview.reloadData()
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


