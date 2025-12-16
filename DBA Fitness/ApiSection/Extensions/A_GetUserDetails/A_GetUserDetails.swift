
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire
import SDWebImage

extension UIViewController{

    func getUserDetails(parameters:[String :Any],
                        selectedFriendsOrRequesterProfileID:String? = nil,
                        notificationListUserID:String? = nil){
        if Connectivity.isConnectedToInternet {

            var newURL = ""

            if selectedFriendsOrRequesterProfileID != ""{
                newURL = ApiURLs.get_user_detail + "?userid=\(selectedFriendsOrRequesterProfileID ?? "0")"
            }else{
                if Constants.navigateToSetting == "1"{
                    newURL = ApiURLs.get_user_detail   // particularPostInfo
                }else{

                    if notificationListUserID != ""{
                        newURL = ApiURLs.get_user_detail + "?userid=\(notificationListUserID ?? "0")"
                    }else{
                        newURL = ApiURLs.get_user_detail + "?userid=\(particularPostInfo?.userid ?? "0")"
                    }


                }
            }

            NVActivityIndicator.managerHandler.showIndicator()

            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in

                NVActivityIndicator.managerHandler.stopIndicator()

                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400||result.statusCode == 401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{

                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){

                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)
                        debugLog("\(userInfo)")
                        DataSaver.dataSaverManager.saveData(key: "selectedLoc", data: userInfo?.data?.location ?? "")
                        DataSaver.dataSaverManager.saveData(key: "is_purchased", data:
                                                                userInfo?.data?.is_purchased ?? "")

                        if Constants.navigateToSetting == "1"{
                            UniversalMethod.universalManager.pushVC("Settings", self.navigationController, storyBoard: AppStoryboard.Trainer_Setting.rawValue)
                        }else{
                            NotificationCenter.default.post(name:NSNotification.Name(Constants.profileData), object:true)
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

    func getUserDetailsForEdit(){
        if Connectivity.isConnectedToInternet {

            NVActivityIndicator.managerHandler.showIndicator()

            apimethod.commonMethod(url: ApiURLs.get_user_detail, parameters: [:], method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in

                NVActivityIndicator.managerHandler.stopIndicator()

                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400||result.statusCode == 401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{

                        }
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){

                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)

                        DataSaver.dataSaverManager.saveData(key: "selectedLoc", data: userInfo?.data?.location ?? "")
                        DataSaver.dataSaverManager.saveData(key: "is_purchased", data:
                                                                userInfo?.data?.is_purchased ?? "")

                        //NotificationCenter.default.post(name:NSNotification.Name(Constants.populateProfileDataForEdit), object:true)

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

extension Trainer_Profile_View {

    func userProfileInfo(parameters:[String :Any]) {
        if Connectivity.isConnectedToInternet {

            NVActivityIndicator.managerHandler.showIndicator()

            apimethod.commonMethod(url: ApiURLs.get_user_detail, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in

                NVActivityIndicator.managerHandler.stopIndicator()

                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400){

                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){

                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)
                        debugLog("userInfo: \(userInfo)")
                        if let requestsCount = userInfo?.data?.no_of_requests{
                            if requestsCount > 0{
                                self.newRequestsView.isHidden = false
                                self.newRequestCount.text = "\(requestsCount)"
                            }else{
                                self.newRequestsView.isHidden = true
                                self.newRequestCount.text = "\(requestsCount)"
                            }
                        }

                        DataSaver.dataSaverManager.saveData(key: "is_purchased", data: userInfo?.data?.is_purchased ?? "")

                        if let is_connected_stripe = userInfo?.data?.is_connected_stripe {
                            if is_connected_stripe == "1" {
                                DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: true)
                            } else {
                                DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: false)
                            }
                        } else {
                            DataSaver.dataSaverManager.saveData(key: "is_connected_stripe", data: false)
                        }

                        // self.trainer_Age.text = "\(userInfo?.data?.age ?? "N/A") years"
                       
                        if let age = userInfo?.data?.age, !age.isEmpty{
                            
                            self.trainer_Age.text = "\(age) years"
                        }
                        self.trainer_Name.text = userInfo?.data?.firstname
                        self.trainer_Loc.text = userInfo?.data?.location
                        self.trainer_About.text = userInfo?.data?.about
                        self.followers.text = userInfo?.data?.follower
                        self.following.text = userInfo?.data?.following
                        self.rating.text = userInfo?.data?.rating
                        self.reviews.text = "\(userInfo?.data?.totalReviews ?? 0) reviews"
                        self.profileUsername.text = userInfo?.data?.username ?? "My Profile"


                        if let createdDate = userInfo?.data?.createdon, !createdDate.isEmpty {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = DateUtil.dateTimeFormatForRecentTask
                            dateFormatter.timeZone = TimeZone(identifier: "UTC")
                            if let startDateTime = dateFormatter.date(from: createdDate){
                                if let joinedDate = DateUtil.convertUTCToLocalDateTime(startDateTime, DateUtil.timeFormatForShowingRecentTask), !joinedDate.isEmpty {
                                    self.joinedDate.text = "Joined \(joinedDate)"
                                    
                                }
                            }
                        }


                        if userInfo?.data?.specialist != ""{
                            self.userInterests.text = userInfo?.data?.specialist ?? ""
                        }else{
                            self.userInterests.text = "NA"
                        }

                        if let photo = userInfo?.data?.image{
                            if photo != ""{
                                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                                

                                self.trainer_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray

                                self.trainer_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                            }else{
                                self.trainer_Image.image = #imageLiteral(resourceName: "user")
                            }
                        }

                        let achievements = userInfo?.achievement ?? []
                        for achievementDicts in achievements {
                            let imageCount = achievementDicts.image?.count
                            if imageCount ?? 0 > 0{
                                if let achievementImages = achievementDicts.image {
                                    for imageLink in achievementImages {
                                        self.certificateArray.append(imageLink)
                                    }
                                }

                            }
                        }

                        if self.certificateArray.count < 2{
                            //self.totalPhotos.text = "Photos \(self.certificateArray.count)"
                        }else{
                            //self.totalPhotos.text = "Photos \(self.certificateArray.count)"
                        }

                        if userInfo?.myGallery?.count ?? 0 < 2{
                            self.totalPhotos.text = "Photos \(userInfo?.myGallery?.count ?? 0)"
                        } else {
                            self.totalPhotos.text = "Photos \(userInfo?.myGallery?.count ?? 0)"
                        }

                        // MARK: Populate User Type
                        populateUserType(value: userInfo?.data?.type, userTypeLbl: self.userTypeLbl)

                        self.photos_Collectionview.delegate = self
                        self.photos_Collectionview.dataSource = self
                        self.photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
                        self.photos_Collectionview.reloadData()
                        
                        self.interests_collectionview.register(UINib(nibName: "User_Interest_Cell", bundle: nil), forCellWithReuseIdentifier: "User_Interest_Cell")
                        let rawSpecialist = userInfo?.data?.specialist ?? ""
                        let sortedSpecialist = rawSpecialist
                            .components(separatedBy: ",")
                            .map { $0.trimmingCharacters(in: .whitespaces) }
                            .sorted()
                        self.interests_dataSource?.user_interests_data = sortedSpecialist
                        self.interests_dataSource?.interest_Collectionview?.reloadData()

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

extension Client_Profile_View{

    func userProfileInfo(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {

            NVActivityIndicator.managerHandler.showIndicator()

            apimethod.commonMethod(url: ApiURLs.get_user_detail, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in

                NVActivityIndicator.managerHandler.stopIndicator()

                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400){

                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){

                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)

                        if let requestsCount = userInfo?.data?.no_of_requests{
                            if requestsCount > 0{
                                self.newRequestsView.isHidden = false
                                self.newRequestCount.text = "\(requestsCount)"
                            }else{
                                self.newRequestsView.isHidden = true
                                self.newRequestCount.text = "\(requestsCount)"
                            }
                        }

                        DataSaver.dataSaverManager.saveData(key: "is_purchased", data: userInfo?.data?.is_purchased ?? "")


                        // self.trainer_Age.text = "\(userInfo?.data?.age ?? "N/A") years"
//                        self.trainer_Age.text = "\(userInfo?.data?.age ?? "N/A")"
                        if let age = userInfo?.data?.age, !age.isEmpty{
                            self.trainer_Age.text = "\(age) years"
                        }
                        self.trainer_Name.text = userInfo?.data?.firstname
                        self.trainer_Loc.text = userInfo?.data?.location
                        self.trainer_About.text = userInfo?.data?.about
                        self.followers.text = userInfo?.data?.follower
                        self.following.text = userInfo?.data?.following
                        self.profileUsername.text = userInfo?.data?.username ?? "My Profile"
                        self.rating.text = userInfo?.data?.rating
                        self.reviews.text = "\(userInfo?.data?.totalReviews ?? 0) reviews"


                        if let createdDate = userInfo?.data?.createdon, !createdDate.isEmpty {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = DateUtil.dateTimeFormatForRecentTask
                            dateFormatter.timeZone = TimeZone(identifier: "UTC")
                            if let startDateTime = dateFormatter.date(from: createdDate){
                                if let joinedDate = DateUtil.convertUTCToLocalDateTime(startDateTime, DateUtil.timeFormatForShowingRecentTask), !joinedDate.isEmpty {
                                    self.joinedDate.text = "Joined \(joinedDate)"
                                    
                                }
                            }
                        }


                        if userInfo?.data?.specialist != ""{
                            self.userInterests.text = userInfo?.data?.specialist ?? ""
                        }else{
                            self.userInterests.text = "NA"
                        }

                        if let photo = userInfo?.data?.image{
                            if photo != ""{
                                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                                

                                self.trainer_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray

                                self.trainer_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                            }else{
                                self.trainer_Image.image = #imageLiteral(resourceName: "user")
                            }
                        }

                        let achievements = userInfo?.achievement ?? []
                        for achievementDicts in achievements {
                            let imageCount = achievementDicts.image?.count
                            if imageCount ?? 0 > 0{
                                if let achievementImages = achievementDicts.image {
                                    for imageLink in achievementImages {
                                        self.certificateArray.append(imageLink)
                                    }
                                }

                            }
                        }

                        if self.certificateArray.count < 2 {
                            //self.totalPhotos.text = "Photos \(self.certificateArray.count)"
                        }else{
                            //self.totalPhotos.text = "Photos \(self.certificateArray.count)"
                        }

                        if userInfo?.myGallery?.count ?? 0 < 2{
                            self.totalPhotos.text = "Photos \(userInfo?.myGallery?.count ?? 0)"
                        }else{
                            self.totalPhotos.text = "Photos \(userInfo?.myGallery?.count ?? 0)"
                        }

                        // MARK: Populate User Type
                        populateUserType(value: userInfo?.data?.type, userTypeLbl: self.userTypeLbl)

                        self.photos_Collectionview.delegate = self
                        self.photos_Collectionview.dataSource = self
                        self.photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
                        self.photos_Collectionview.reloadData()
                        
                        self.interests_collectionview.register(UINib(nibName: "User_Interest_Cell", bundle: nil), forCellWithReuseIdentifier: "User_Interest_Cell")
                        let rawSpecialist = userInfo?.data?.specialist ?? ""
                        let sortedSpecialist = rawSpecialist
                            .components(separatedBy: ",")
                            .map { $0.trimmingCharacters(in: .whitespaces) }
                            .sorted()
                        self.interests_dataSource?.user_interests_data = sortedSpecialist
                        self.interests_dataSource?.interest_Collectionview?.reloadData()

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

extension Trainer_Detail_View{

    func userProfileInfo(parameters:[String :Any]){
        if Connectivity.isConnectedToInternet {

            var newURL = String()

            if self.isComingFromInboxSection == true{
                newURL = ApiURLs.get_user_detail + "?userid=\(selectedClientID)"
                selectedUserID = selectedClientID
            }else{
                if isComingFromTrainerProfileMyClients == true && selectedClientID != ""{
                    newURL = ApiURLs.get_user_detail + "?userid=\(selectedClientID)"
                    selectedUserID = selectedClientID
                }else{
                    newURL = ApiURLs.get_user_detail + "?userid=\(searchedTrainerInfo?.userid ?? "0")"
                    selectedUserID = searchedTrainerInfo?.userid ?? "0"
                }
            }

            apimethod.commonMethod(url: newURL, parameters: parameters, method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in

                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){

                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201) {

                        userInfo = try? JSONDecoder().decode(M_UserInfo.self, from: responseData)
                        debugLog("userInfo \(userInfo)")
                        DataSaver.dataSaverManager.saveData(key: "is_purchased", data:
                                                                userInfo?.data?.is_purchased ?? "")

                        self.searchedClientUserID = userInfo?.data?.userid ?? ""

                        if (userInfo?.data?.type == "1"){
                            //isTrainer = "Trainer"
                            self.progressViewHeight.constant = 0.0
                            self.goalViewHeight.constant = 0.0
                            self.progressViewTop.constant = 0.0
                            self.progressViewBottom.constant = 0.0
                            self.myProgress_View.isHidden = true
                            self.myGoals_View.isHidden = true

                            self.achievement_View.isHidden = false
                            self.achievementsViewTop.constant = 20.0
                            self.achievementsViewHeight.constant = 50.0

                        }else if (userInfo?.data?.type == "2"){
                            //isTrainer = "Client"
                            self.progressViewHeight.constant = 50.0
                            self.goalViewHeight.constant = 50.0
                            self.progressViewTop.constant = 20.0
                            self.progressViewBottom.constant = 20.0
                            self.myProgress_View.isHidden = false
                            self.myGoals_View.isHidden = false

                            self.achievement_View.isHidden = true
                            self.achievementsViewTop.constant = 0.0
                            self.achievementsViewHeight.constant = 0.0
                        }

                        let userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
                        if userRole == Role.trainer.rawValue {
                            //                            self.rating.isHidden = true
                            //                            self.ratingIcon.isHidden = true

                            self.rating.isHidden = false
                            self.ratingIcon.isHidden = false

                        } else if userRole == Role.client.rawValue {
                            self.rating.isHidden = false
                            self.ratingIcon.isHidden = false
                        }

                        // self.trainer_Age.text = "\(userInfo?.data?.age ?? "N/A") years"
//                        self.trainer_Age.text = "\(userInfo?.data?.age ?? "N/A")"
                        if let age = userInfo?.data?.age, !age.isEmpty{
                            self.trainer_Age.text = "\(age) years"
                        }
                        self.trainer_Name.text = userInfo?.data?.firstname
                        self.trainer_Loc.text = userInfo?.data?.location
                        self.trainer_About.text = userInfo?.data?.about
                        self.followers.text = userInfo?.data?.follower
                        self.following.text = userInfo?.data?.following
                        self.rating.text = userInfo?.data?.rating
                        self.reviews.text = "\(userInfo?.data?.totalReviews ?? 0) reviews"

                        if let createdDate = userInfo?.data?.createdon, !createdDate.isEmpty {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = DateUtil.dateTimeFormatForRecentTask
                            dateFormatter.timeZone = TimeZone(identifier: "UTC")
                            if let startDateTime = dateFormatter.date(from: createdDate){
                                if let joinedDate = DateUtil.convertUTCToLocalDateTime(startDateTime, DateUtil.timeFormatForShowingRecentTask), !joinedDate.isEmpty {
                                    self.joinedDate.text = "Joined \(joinedDate)"
                                    
                                }
                            }
                        }


                        if let createdDate = userInfo?.data?.createdon, !createdDate.isEmpty {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = DateUtil.dateTimeFormatForRecentTask
                            dateFormatter.timeZone = TimeZone(identifier: "UTC")
                            if let startDateTime = dateFormatter.date(from: createdDate){
                                if let joinedDate = DateUtil.convertUTCToLocalDateTime(startDateTime, DateUtil.timeFormatForShowingRecentTask), !joinedDate.isEmpty {
                                    self.joinedDate.text = "Joined \(joinedDate)"
                                    
                                }
                            }
                        }

                        if userInfo?.data?.username != ""{
                            self.profileUsername.text = userInfo?.data?.username
                        }else{
                            self.profileUsername.text = "Search"
                        }

                        //In case when click on post's profile
                        if self.isComingFromTappedOnPostProfilePicAndRedirectOnUserInfo{
                            self.becomeClientORTrainerViewHeight.constant = 0.0
                            self.acceptRequestViewHeight.constant = 0.0
                            self.rejectRequestViewHeight.constant = 0.0
                        }else{
                            self.becomeClientORTrainerViewHeight.constant = 50.0
                            self.acceptRequestViewHeight.constant = 50.0
                            self.rejectRequestViewHeight.constant = 50.0
                        }

                        if let loggedUserType = DataSaver.dataSaverManager.fetchData(key: "userType") as? String,
                           !loggedUserType.isEmpty,
                           loggedUserType != userInfo?.data?.type {

                            self.becomeClientORTrainerViewHeight.constant = 50.0
                            self.acceptRequestViewHeight.constant = 50.0
                            self.rejectRequestViewHeight.constant = 50.0

                            if userInfo?.data?.isrequest == "4" || userInfo?.data?.isrequest == "0"{
                                if self.userRole != ""{
                                    if (self.userRole == Role.trainer.rawValue){
                                        self.becomeClientORTrainerButton.setTitle("Request to Train", for: .normal) // Become a Trainer
                                    }else if (self.userRole == Role.client.rawValue){
                                        self.becomeClientORTrainerButton.setTitle("Request to Train", for: .normal)
                                    }
                                }
                                self.becomeClientORTrainerButton.isUserInteractionEnabled = true
                                self.becomeClientORTrainerView.isHidden = false
                                self.acceptRequestView.isHidden = true
                                self.rejectRequestView.isHidden = true

                            }else if userInfo?.data?.isrequest == "1"{
                                self.becomeClientORTrainerButton.setTitle("Request Sent", for: .normal)
                                self.becomeClientORTrainerButton.isUserInteractionEnabled = false
                                self.becomeClientORTrainerView.isHidden = false
                                self.acceptRequestView.isHidden = true
                                self.rejectRequestView.isHidden = true

                            }else if userInfo?.data?.isrequest == "2"{
                                self.becomeClientORTrainerView.isHidden = true
                                self.acceptRequestView.isHidden = false
                                self.rejectRequestView.isHidden = false

                            }else if userInfo?.data?.isrequest == "3"{
                                if (self.userRole == Role.trainer.rawValue){
                                    self.becomeClientORTrainerButton.setTitle("Client", for: .normal)
                                }else if (self.userRole == Role.client.rawValue){
                                    self.becomeClientORTrainerButton.setTitle("Trainer", for: .normal)
                                }

                                self.becomeClientORTrainerButton.isUserInteractionEnabled = false
                                self.becomeClientORTrainerView.isHidden = false
                                self.acceptRequestView.isHidden = true
                                self.rejectRequestView.isHidden = true
                            }
                        } else {
                            self.becomeClientORTrainerViewHeight.constant = 0.0
                            self.acceptRequestViewHeight.constant = 0.0
                            self.rejectRequestViewHeight.constant = 0.0
                        }

                        if userInfo?.data?.specialist != ""{
                            self.userInterests.text = userInfo?.data?.specialist ?? ""
                        }else{
                            self.userInterests.text = "NA"
                        }

                        if let photo = userInfo?.data?.image{
                            if photo != ""{
                                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                                

                                self.trainer_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray

                                self.trainer_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                            }else{
                                self.trainer_Image.image = #imageLiteral(resourceName: "user")
                            }
                        }

                        let achievements = userInfo?.achievement ?? []
                        self.certificateArray.removeAll()
                        for achievementDicts in achievements {
                            let imageCount = achievementDicts.image?.count
                            if imageCount ?? 0 > 0{
                                
                                if let achievementImages = achievementDicts.image {
                                    for imageLink in achievementImages {
                                        self.certificateArray.append(imageLink)
                                    }
                                }
                                

                            }
                        }

                        // MARK: Populate User Type
                        populateUserType(value: userInfo?.data?.type, userTypeLbl: self.userTypeLbl)

                        self.photos_Collectionview.delegate = self
                        self.photos_Collectionview.dataSource = self
                        self.photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
                        self.photos_Collectionview.reloadData()
                        
                        self.interests_collectionview.register(UINib(nibName: "User_Interest_Cell", bundle: nil), forCellWithReuseIdentifier: "User_Interest_Cell")
                        let rawSpecialist = userInfo?.data?.specialist ?? ""
                        let sortedSpecialist = rawSpecialist
                            .components(separatedBy: ",")
                            .map { $0.trimmingCharacters(in: .whitespaces) }
                            .sorted()
                        
                        self.interests_dataSource?.user_interests_data = sortedSpecialist
                        self.interests_dataSource?.interest_Collectionview?.reloadData()

                        if userInfo?.data?.isfollow == 1{
                            self.followingAction_View.gradientBackground(from: self.startColor, to: self.endColor, direction: .leftToRight)
                            self.messageView.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
                            self.followingAction_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
                            self.isFollowTitle.text = "Following"
                            self.isFollowUnfollow = 1
                        }else{

                            if let existingLayer = (self.followingAction_View.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
                                existingLayer.removeFromSuperlayer()
                            }

                            self.followingAction_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
                            self.isFollowTitle.text = "Follow"
                            self.isFollowUnfollow = 0
                        }

                        if let loggedUserType = DataSaver.dataSaverManager.fetchData(key: "userType") as? String,
                           !loggedUserType.isEmpty,
                           loggedUserType == Role.client.rawValue,
                           userInfo?.data?.type == "2" {
                            if userInfo?.data?.dataPrivate == "1" {
                                self.anthropometric_View.alpha = 0.5
                                self.myProgress_View.alpha = 0.5
                                self.myGoals_View.alpha = 0.5
                                self.anthropometric_View.isUserInteractionEnabled = false
                                self.myProgress_View.isUserInteractionEnabled = false
                                self.myGoals_View.isUserInteractionEnabled = false
                            } else {
                                self.anthropometric_View.alpha = 1.0
                                self.myProgress_View.alpha = 1.0
                                self.myGoals_View.alpha = 1.0
                                self.anthropometric_View.isUserInteractionEnabled = true
                                self.myProgress_View.isUserInteractionEnabled = true
                                self.myGoals_View.isUserInteractionEnabled = true
                            }
                        } else {
                            self.anthropometric_View.alpha = 1.0
                            self.myProgress_View.alpha = 1.0
                            self.myGoals_View.alpha = 1.0
                            self.anthropometric_View.isUserInteractionEnabled = true
                            self.myProgress_View.isUserInteractionEnabled = true
                            self.myGoals_View.isUserInteractionEnabled = true
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

func populateUserType(value: String?, userTypeLbl: UILabel) {
    if let userType = value {
        if userType == Role.trainer.rawValue {
            userTypeLbl.text = "TRAINER"
        } else if userType == Role.client.rawValue {
            userTypeLbl.text = "CLIENT"
        } else {
            userTypeLbl.text = ""
        }
    } else {
        userTypeLbl.text = ""
    }
}
