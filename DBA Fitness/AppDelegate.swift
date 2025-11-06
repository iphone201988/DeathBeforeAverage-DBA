/*
 import UIKit
 import GooglePlaces
 import UserNotifications
 import UserNotificationsUI

 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {


 var window: UIWindow?

 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 // Override point for customization after application launch.

 GMSPlacesClient.provideAPIKey("AIzaSyBFpwNsc5OXr8hYK3wWyU5E9jxW8Xdb6ys")

 UNUserNotificationCenter.current().delegate = self
 Constant.notificationCenter.delegate = self

 let options: UNAuthorizationOptions = [.alert, .sound, .badge]
 Constant.notificationCenter.requestAuthorization(options: options) {
 (didAllow, error) in
 if !didAllow {
 }else{
 DispatchQueue.main.async {
 UIApplication.shared.registerForRemoteNotifications()
 }
 }
 }

 resetRoot()
 return true
 }

 func resetRoot() {
 /*guard let rootVC = UIStoryboard.init(name: AppStoryboard.Client_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: Client_Tabbar.Client_Bar.rawValue) as? MainTabbar_Controller else {
  return
  }

  guard let rootVC = UIStoryboard.init(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: Trainer_Tabbar.Trainer_Bar.rawValue) as? MainTabbar_Controller else {
  return
  }*/


 guard let rootVC = UIStoryboard.init(name: AppStoryboard.Auth.rawValue, bundle: nil).instantiateViewController(withIdentifier: Auth.Login.rawValue) as? Login else {
 return
 }

 let navigationController = UINavigationController(rootViewController: rootVC)
 navigationController.isNavigationBarHidden = true
 UIApplication.shared.windows.first?.rootViewController = navigationController
 UIApplication.shared.windows.first?.makeKeyAndVisible()

 //        let mainStoryboard = UIStoryboard(name: "Trainer_Tabbar", bundle: nil)
 //        let VC = mainStoryboard.instantiateViewController(withIdentifier: "Client_Tab_Bar") as! Client_Tab_Bar
 //        var navigationController = UINavigationController(rootViewController: VC)
 //        navigationController.isNavigationBarHidden = true
 //        navigationController = UINavigationController(rootViewController: VC)
 //        navigationController.isNavigationBarHidden = true // or not, your choice.
 //        self.window = UIWindow(frame: UIScreen.main.bounds)
 //        self.window!.rootViewController = navigationController

 }

 }

 func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
 let DTokenId = deviceToken.map { data in String(format: "%02.2hhx", data) }
 Constant.DeviceTokenId = DTokenId.joined()
 DataSaver.dataSaverManager.saveData(key: "DeviceToken", data: Constant.DeviceTokenId)
 let token = DataSaver.dataSaverManager.fetchData(key: "DeviceToken") as? String ?? ""
 }

 func application(_ application: UIApplication,didFailToRegisterForRemoteNotificationsWithError error: Error) {
 Constant.DeviceTokenId = UIDevice.current.identifierForVendor!.uuidString
 let data = Data(Constant.DeviceTokenId.utf8)
 let DTokenId = data.map { data in String(format: "%02.2hhx", data) }
 Constant.DeviceTokenId = DTokenId.joined()
 DataSaver.dataSaverManager.saveData(key: "DeviceToken", data: Constant.DeviceTokenId)
 }

 //MARK: UserNotification's Delegate

 extension AppDelegate: UNUserNotificationCenterDelegate {

 func userNotificationCenter(_ center: UNUserNotificationCenter,
 willPresent notification: UNNotification,
 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 let userInfo = notification.request.content.userInfo
 completionHandler([.alert, .sound, .badge])
 }


 func userNotificationCenter(_ center: UNUserNotificationCenter,
 didReceive response: UNNotificationResponse,
 withCompletionHandler completionHandler: @escaping () -> Void) {
 let userInfo = response.notification.request.content.userInfo
 x(userInfo: userInfo)
 }

 // iOS9, called when presenting notification in foreground
 func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
 x(userInfo: userInfo)
 }

 func x(userInfo: [AnyHashable : Any]){

 var title = String()
 var notification_Id = String()
 DispatchQueue.main.async {

 // Call is read notification api

 var _ : NSDictionary = userInfo as NSDictionary
 if let info = userInfo["aps"] as? Dictionary<String, AnyObject>{
 title = info["alert"] as? String ?? ""
 notification_Id = info["alert"] as? String ?? ""
 }

 if UIApplication.shared.applicationState == .active {    }else{    }

 }
 }
 }

 extension Data {
 var hexString: String {
 let hexString = map { String(format: "%02.2hhx", $0) }.joined()
 return hexString
 }
 }
 */


// com.NightCoders.DBAFitness ** old
// com.DBA.DBA ** new
/*
 deathbeforeaverage@gmail.com

 old: AzutG!lp09%
 new: ZetB!DBAFitness!88
 */

/* Sandbox credential
 testernew@test.com
 Techwinlabs123!


 Below are the credentials for DBA stripe:
 codyrb1996@gmail.com
 ZetB!GokuSSJ3

 Below XCode credential w.e.f 31.01.2023 (most recent)
 account: deathbeforeaverage@gmail.com
 password: ZetB!DBAFitness!88

 */

import UIKit
import CoreData
import FBSDKLoginKit
//import GoogleSignIn
import UserNotifications
import UserNotificationsUI
import GooglePlaces
import Stripe
import Alamofire
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //AIzaSyBFpwNsc5OXr8hYK3wWyU5E9jxW8Xdb6ys
        // pk_test_51Hjzs8JmSSMjRbH3IPK5dwCJEkvr3xi0N91S1Ns9srNToC0moTesVLG2Rzo75krM1QpC3AADgsfJT2V3AgEWe0qS00rRPWID1n
        //
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSPlacesClient.provideAPIKey("AIzaSyBbaogEE1RE4Qhn51dyV4AjLbbBN1UVdBc")

        guard let userRole =  DataSaver.dataSaverManager.fetchData(key: "userType") as? String else{
            return false
        }

        guard let sessionkey =  DataSaver.dataSaverManager.fetchData(key: "sessionkey") as? String else{
            return false
        }

        guard let userid =  DataSaver.dataSaverManager.fetchData(key: "userid") as? String else{
            return false
        }


        if sessionkey != "" && userid != ""{

            if userRole == "0"{
                UniversalMethod.universalManager.navigateToChooseRole()
            }else if (userRole == "1"){
                UniversalMethod.universalManager.navigateToTrainer()
            }else if (userRole == "2"){
                UniversalMethod.universalManager.navigateToClient()
            }
        }

        // handle notification when app is closed.
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        let notification = launchOptions?[.remoteNotification]

        if let data = notification, let notificationData = data as? [AnyHashable : Any] {
            self.application(application, didReceiveRemoteNotification: notificationData)
        }

        if let launchOpts = launchOptions as [UIApplication.LaunchOptionsKey: Any]? {
            if let notificationPayload = launchOpts[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary {
                let section = notificationPayload["section"]
                let strRep = "\(section ?? "DBA")"
                let senderID = notificationPayload["sender_id"]
                let senderName = notificationPayload["sender_name"]
                let userID = notificationPayload["userid"]
                var strRepPostID = ""
                if let postID = notificationPayload["post_id"] as? String, !postID.isEmpty {
                    strRepPostID = "\(postID)"
                }

                let strRepSenderID = "\(senderID ?? "")"
                let strRepSenderName = "\(senderName ?? "")"
                let strRepUserID = "\(userID ?? "")"

                DataSaver.dataSaverManager.saveData(key: "isNewNotification", data: true)
                NotificationCenter.default.post(name:NSNotification.Name("isNewNotification"), object:true)
                NotificationCenter.default.post(name:NSNotification.Name("callApiRequest"), object:true)
                NotificationCenter.default.post(name:NSNotification.Name(Constants.getProgramsDetails), object:true)
                DispatchQueue.main.async {
                    if let topVc = UIApplication.shared.keyWindow?.topViewController() {
                        PushNotificationType.performActionAccordingToType(type: strRep,
                                                                          vc: topVc,
                                                                          senderID: strRepSenderID,
                                                                          senderName: strRepSenderName,
                                                                          userID: strRepUserID,
                                                                          postID: strRepPostID)
                    }
                }
            }
        } else {
            //go with the regular flow
        }

        // Below one is Original Clients Test Key
        STPPaymentConfiguration.shared.publishableKey = "pk_test_51Hjzs8JmSSMjRbH3IPK5dwCJEkvr3xi0N91S1Ns9srNToC0moTesVLG2Rzo75krM1QpC3AADgsfJT2V3AgEWe0qS00rRPWID1n"

        IQKeyboardManager.shared.enable = false

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Constants.stopUploadingDuetoBackground = "1"
        NotificationCenter.default.post(name:NSNotification.Name(Constants.isBackground), object:true)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        getNotificationSettings()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name:NSNotification.Name("callApiRequest"), object:true)
    }

    func getNotificationSettings() {

        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {

            } else if settings.authorizationStatus == .denied {

            } else if settings.authorizationStatus == .authorized {

                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let DTokenId = deviceToken.map { data in String(format: "%02.2hhx", data) }
        Constant.DeviceTokenId = DTokenId.joined()
        DataSaver.dataSaverManager.saveData(key: "DeviceToken", data: Constant.DeviceTokenId)

    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
            Constant.DeviceTokenId = UIDevice.current.identifierForVendor!.uuidString
            let data = Data(Constant.DeviceTokenId.utf8)
            let DTokenId = data.map { data in String(format: "%02.2hhx", data) }
            Constant.DeviceTokenId = DTokenId.joined()
            DataSaver.dataSaverManager.saveData(key: "DeviceToken", data: Constant.DeviceTokenId)
        }
}

//MARK: UserNotification's Delegate

/*
 type = 1;  //sent you a message // payload =7
 type= 2;  //sent you a program //payload =5
 type = 10;  //started following you  // payload =10
 type = 3;  // commented on your post  //payload =1
 type= 4;  //liked your post  //payload =4
 type = 5;  //submitted a rating //payload =3
 type = 7;  //wants to train you //payload =8
 type = 11;  // Accepted your training Request //payload =11
 type = 9;  // Rejected your training Request //payload =11
 */

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // moveOnParticularControllerAccordingToNotificationSectionInfo(userInfo: userInfo)
        DataSaver.dataSaverManager.saveData(key: "isNewNotification", data: true)
        NotificationCenter.default.post(name:NSNotification.Name("isNewNotification"), object:true)
        NotificationCenter.default.post(name:NSNotification.Name("callApiRequest"), object:true)
        if let topVc = UIApplication.shared.keyWindow?.topViewController() {
            if topVc is Chat_VC {
                completionHandler([.sound])
            } else {
                completionHandler([.alert, .sound])
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        moveOnParticularControllerAccordingToNotificationSectionInfo(userInfo: userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //Kill case fall in this method
        moveOnParticularControllerAccordingToNotificationSectionInfo(userInfo: userInfo)
        if application.applicationState == .background ||
            application.applicationState == .inactive || application.applicationState == .active {
            // UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }

    func moveOnParticularControllerAccordingToNotificationSectionInfo(userInfo: [AnyHashable : Any]) {

        DataSaver.dataSaverManager.saveData(key: "isNewNotification", data: true)
        NotificationCenter.default.post(name:NSNotification.Name("isNewNotification"), object:true)
        NotificationCenter.default.post(name:NSNotification.Name(Constants.getProgramsDetails), object:true)
        NotificationCenter.default.post(name:NSNotification.Name("callApiRequest"), object:true)
        let section = userInfo["section"]
        let strRep = "\(section ?? "DBA")"
        let senderID = userInfo["sender_id"]
        let senderName = userInfo["sender_name"]
        let strRepSenderID = "\(senderID ?? "")"
        let strRepSenderName = "\(senderName ?? "")"
        let userID = userInfo["userid"]

        if let postID = userInfo["post_id"] as? String, !postID.isEmpty {
            let strRepPostID = "\(postID)"
            Constants.strRepPostID = strRepPostID
        }

        let strRepUserID = "\(userID ?? "")"

        Constants.strRepSenderID = strRepSenderID
        Constants.strRepSenderName = strRepSenderName
        Constants.strRepUserID = strRepUserID

        //        if let topVc = UIApplication.shared.keyWindow?.topViewController() {
        //            let alert = UIAlertController(title: "Message", message: "\(userInfo)", preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive , handler:{ (UIAlertAction)in }))
        //            alert.addAction(UIAlertAction(title: "Ok", style: .default , handler:{ (UIAlertAction)in }))
        //            topVc.present(alert, animated: true)
        //        }

        NotificationCenter.default.post(
            name: NSNotification.Name(
                Constants.performActionAccordingToPushNotificationTypeWhenAppIsKill
            ),
            object: userInfo
        )

        if strRep == PushNotificationType.chating.rawValue {
            if let vc = self.window?.topViewController(){
                var tabBarItem = vc.tabBarController?.tabBar.items?[3]
                tabBarItem?.badgeValue = "1"
                tabBarItem?.badgeColor = UIColor(named: "Receiver_Message")

                tabBarItem = vc.tabBarController?.tabBar.items?[4]
                tabBarItem?.badgeValue = "1"
                tabBarItem?.badgeColor = UIColor(named: "Receiver_Message")

                // vc.tabBarController?.selectedIndex = 3
                // NotificationCenter.default.post(name:NSNotification.Name("isNewNotification"), object:true)
            }
        } else {

        }
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension UIWindow{
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}

enum PushNotificationType: String {

    case comment = "1" // to particular feed - done
    case userFollow = "2" //
    case addRatingAndComment = "3" // to particular user - done
    case postLike = "4" // to particular feed - done
    case sendProgramOrExerciseToClient = "5" // to program - done
    case shareExerciseFolder = "6" // - done
    case chating = "7" // to chat - done
    case becomeTrainerOrClient = "8" // to requests - done
    case acceptRequest = "9" // to particular user - done
    case startedFollowingYou = "10" // to following list
    case acceptedYourTrainingRequest = "11" // to particular user or Accepted/Rejected your training Request

    static func performActionAccordingToType(type: String,
                                             vc: UIViewController,
                                             senderID: String? = nil,
                                             senderName: String? = nil,
                                             userID: String? = nil,
                                             postID: String? = nil) {

        let pushType = PushNotificationType(rawValue: type)

        switch pushType {
        case .comment, .postLike:
            if let specialID = postID, !specialID.isEmpty {
                NVActivityIndicator.managerHandler.showIndicator()
                getAllPosts(selectedPostId: specialID, vc: vc)
            } else {
                vc.tabBarController?.selectedIndex = 0
            }

        case .userFollow, .acceptRequest, .acceptedYourTrainingRequest:
            if let userID, !userID.isEmpty {
                navigateToTrainerDetailView(userID: userID, vc: vc)
            } else {
                vc.tabBarController?.selectedIndex = 4
            }

        case .addRatingAndComment:
            if let userID, !userID.isEmpty {
                navigateToTrainerDetailView(userID: userID, vc: vc)
            } else {
                vc.tabBarController?.selectedIndex = 1
            }

        case .sendProgramOrExerciseToClient:
            vc.tabBarController?.selectedIndex = 2

        case .shareExerciseFolder:
            vc.tabBarController?.selectedIndex = 3

        case .chating: //vc.tabBarController?.selectedIndex = 3
            if vc is Chat_VC {
                Constants.isMessageTab = "1"
                let destVC = Chat_VC()
                if let senderID, !senderID.isEmpty {
                    destVC.reciver_id = senderID
                }

                if let senderName, !senderName.isEmpty {
                    destVC.selectedReceiverName = senderName
                }
                NotificationCenter.default.post(name:NSNotification.Name("callApiRequest"), object:true)
            } else {
                Constants.isMessageTab = "1"
                let destVC = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Chat_VC") as! Chat_VC

                if let senderID, !senderID.isEmpty {
                    destVC.reciver_id = senderID
                }

                if let senderName, !senderName.isEmpty {
                    destVC.selectedReceiverName = senderName
                }

                destVC.hidesBottomBarWhenPushed = true
                vc.navigationController?.pushViewController(destVC, animated: false)
            }

        case .becomeTrainerOrClient:
            // vc.tabBarController?.selectedIndex = 4
            UniversalMethod.universalManager.pushVC(
                "FriendsAndRequestsList",
                vc.navigationController!,
                storyBoard: AppStoryboard.Trainer_Tabbar.rawValue
            )

        case .startedFollowingYou:
            let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: "FollowerANDFollowingList") as! FollowerANDFollowingList
            ShareVC.type = "1"
            ShareVC.hidesBottomBarWhenPushed = true
            vc.navigationController?.pushViewController(ShareVC, animated: true)

        default: break
        }
    }

    static func navigateToTrainerDetailView(userID: String, vc: UIViewController) {
        let destVC = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "Trainer_Detail_View") as! Trainer_Detail_View
        destVC.isComingFromTrainerProfileMyClients = true
        destVC.selectedClientID = userID
        destVC.userID = userID
        destVC.hidesBottomBarWhenPushed = true
        vc.navigationController?.pushViewController(destVC, animated: true)
    }
}

func getAllPosts(selectedPostId: String, vc: UIViewController) {

    guard let navigationController = vc.navigationController else {
        NVActivityIndicator.managerHandler.stopIndicator()
        return
    }

    if Connectivity.isConnectedToInternet {
        let newURL = ApiURLs.get_global_and_personal_feed + "3" + "&post_id=\(selectedPostId)"
        apimethod.commonMethod(url: newURL, parameters: [:], method: "GET") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
            NVActivityIndicator.managerHandler.stopIndicator()
            if success, let result = response as? HTTPURLResponse {
                
                if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                    if result.statusCode == 401{
                        logoutFromAPP()
                    }
                }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                    let allPosts = try? JSONDecoder().decode(M_AllPosts.self, from: responseData)
                    let dataStatus = allPosts?.status
                    if (dataStatus == 200 && allPosts?.data != nil) {
                        if let postData = allPosts?.data?.first {
                            particularPostInfo = postData
                            UniversalMethod.universalManager.pushVC("Trainer_Post_Details", navigationController, storyBoard: AppStoryboard.Trainer_Post_Section.rawValue)
                        }
                    } else {
                        Toast.show(message: "Something went wrong, please try again.", controller: vc)
                    }
                }else if(result.statusCode==500){
                    UniversalMethod.universalManager.alertMessage("Internal Server Error", navigationController)
                }
            }
        }
    }else{
        UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", navigationController)
    }

}
