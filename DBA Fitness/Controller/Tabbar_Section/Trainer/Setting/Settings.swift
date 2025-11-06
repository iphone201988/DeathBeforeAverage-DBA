
import UIKit
import MGSwipeTableCell
import SafariServices
import WebKit

class Settings: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var setting_Tableview: UITableView!
    @IBOutlet weak var mainView: UIView!
    
    var client_settings_Menu = [
        ["pic":"profileSettingsIcon","name":"Edit Profile"],
        ["pic":"profileSettingsIcon","name":"Edit Bio"],
        ["pic":"AnthropometricIcon","name":"Edit Anthropometric Data"],
        ["pic":"flagIcon","name":"My Goals"],
        ["pic":"reviews","name":"My Reviews"],
        ["pic":"card","name":"My Cards"],
        ["pic":"purchase","name":"Purchased Programs List"],
        ["pic":"bell (3)","name":"Push Notifications"],
        ["pic":"privateaccountIcon","name":"Private Account"],
        ["pic":"delete_icon","name":"Delete Profile"],
        ["pic":"reset-password","name":"Reset Password"],
//        ["pic":"","name":""],
        ["pic":"logoutIcon","name":"Logout"]]
    
    var trainer_settings_Menu = [
        ["pic":"profileSettingsIcon","name":"Edit Profile"],
        ["pic":"profileSettingsIcon","name":"Edit Bio"],
        ["pic":"AnthropometricIcon","name":"Edit Anthropometric Data"],
        //["pic":"Create Exercise Catalogue","name":"Create Exercise Catalogue"],
        //["pic":"card","name":"My Cards"],
        //["pic":"card","name":"Subscription"],
        //["pic":"card","name":"Restore Purchases"],
        
        ["pic":"purchase","name":"Purchased Programs List"],
        
        ["pic":"bell (3)","name":"Push Notifications"],
        ["pic":"privateaccountIcon","name":"Private Account"],
        ["pic":"card","name":"Subscription"],
        ["pic":"stripe","name":"Stripe Account"],
        ["pic":"delete_icon","name":"Delete Profile"],
        ["pic":"reset-password","name":"Reset Password"],
        ["pic":"reviews","name":"My Reviews"],
//        ["pic":"","name":""],
        ["pic":"logoutIcon","name":"Logout"]]
    
    var isOnStatus = ""
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(populateUpdateProfileInfo(_:)),
                                               name: NSNotification.Name(rawValue: Constants.populateProfileDataForEdit),
                                               object: nil)
        
        setting_Tableview.delegate = self
        setting_Tableview.dataSource = self
        setting_Tableview.register(UINib(nibName: "Setting_Cell", bundle: nil), forCellReuseIdentifier: "Setting_Cell")
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        let userRole =  DataSaver.dataSaverManager.fetchData(key: "userType") as? String
        if (userRole == "1"){
            isTrainer = "Trainer"
        }else if (userRole == "2"){
            isTrainer = "Client"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper's Method
    @objc func populateUpdateProfileInfo(_ notify:NSNotification){
        let isUpdated = notify.object as? Bool
        if isUpdated == true{
            getUserDetailsForEdit()
        }
    }
}

extension Settings: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTrainer == "Trainer"{
            return trainer_settings_Menu.count
        }else{
            return client_settings_Menu.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isTrainer == "Trainer"{
            if indexPath.row == 5 {
                return 0
            }
        } else {
            if indexPath.row == 8 {
                return 0
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let  cell = tableView.dequeueReusableCell(withIdentifier: "Setting_Cell", for: indexPath) as? Setting_Cell {

            if isTrainer == "Trainer"{
                cell.isHidden = false
                cell.underline_View.isHidden = false
                cell.switch_Button.isHidden = true
                let dict = trainer_settings_Menu[indexPath.row] as NSDictionary
                cell.menu_Name.text = (dict["name"] as? String ?? "")
                cell.menu_Icon.image = UIImage(named: dict["pic"] as? String ?? "")!.withTintColor(.white)
//                if indexPath.row == 11{
//                    cell.isHidden = true
//                }
                if indexPath.row == 11{
                    cell.underline_View.isHidden = true
                }
                if indexPath.row == 4 || indexPath.row == 5 {
                    cell.switch_Button.isHidden = false
                    if indexPath.row == 5{
                        let statusValue = DataSaver.dataSaverManager.fetchData(key: "isPrivate") as? String
                        if statusValue == "0"{
                            cell.switch_Button.setOn(false, animated: false)
                        }else{
                            cell.switch_Button.setOn(true, animated: false)
                        }
                        cell.switch_Button.addTarget(self, action: #selector(makePrivateAccount(_sender:)), for: .valueChanged)
                    }else if (indexPath.row == 4){
                        let statusValue = DataSaver.dataSaverManager.fetchData(key: "notification_alert") as? String
                        if statusValue == "0"{
                            cell.switch_Button.setOn(false, animated: false)
                        }else{
                            cell.switch_Button.setOn(true, animated: false)
                        }
                        cell.switch_Button.addTarget(self, action: #selector(setNotificationToggle(_sender:)), for: .valueChanged)
                    }
                }
            }else{
                cell.isHidden = false
                cell.underline_View.isHidden = false
                cell.switch_Button.isHidden = true
                let dict = client_settings_Menu[indexPath.row] as NSDictionary
                cell.menu_Name.text = (dict["name"] as? String ?? "")
                cell.menu_Icon.image = UIImage(named: dict["pic"] as? String ?? "")!.withTintColor(.white)
//                if indexPath.row == 11{
//                    cell.isHidden = true
//                }
                if indexPath.row == 11{
                    cell.underline_View.isHidden = true
                }
                if indexPath.row == 7 || indexPath.row == 8{   // setNotificationToggle
                    cell.switch_Button.isHidden = false
                    if indexPath.row == 8{
                        let statusValue = DataSaver.dataSaverManager.fetchData(key: "isPrivate") as? String
                        if statusValue == "0"{
                            cell.switch_Button.setOn(false, animated: false)
                        }else{
                            cell.switch_Button.setOn(true, animated: false)
                        }
                        cell.switch_Button.addTarget(self, action: #selector(makePrivateAccount(_sender:)), for: .valueChanged)
                    }else if (indexPath.row == 7){
                        let statusValue = DataSaver.dataSaverManager.fetchData(key: "notification_alert") as? String
                        if statusValue == "0"{
                            cell.switch_Button.setOn(false, animated: false)
                        }else{
                            cell.switch_Button.setOn(true, animated: false)
                        }
                        cell.switch_Button.addTarget(self, action: #selector(setNotificationToggle(_sender:)), for: .valueChanged)
                    }
                }
            }
            
           // cell.menu_Icon.image = UIImage(named: dict["pic"] as? String ?? "")!.withTintColor(.white)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isTrainer == "Trainer" {
            if indexPath.row == 0{
                let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Setting.rawValue, bundle: nil).instantiateViewController(withIdentifier: "Edit_Trainer_Profile") as! Edit_Trainer_Profile
                self.addChild(ShareVC)
                ShareVC.view.frame = self.view.frame
                self.view.addSubview(ShareVC.view)
                ShareVC.didMove(toParent: self)
            }else if (indexPath.row == 1){
                let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Setting.rawValue, bundle: nil).instantiateViewController(withIdentifier: "Edit_Trainer_About") as! Edit_Trainer_About
                self.addChild(ShareVC)
                ShareVC.view.frame = self.view.frame
                self.view.addSubview(ShareVC.view)
                ShareVC.didMove(toParent: self)
            }else if (indexPath.row == 2){
                let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Setting.rawValue, bundle: nil).instantiateViewController(withIdentifier: "Edit_Trainer_Anthropometric") as! Edit_Trainer_Anthropometric
                self.addChild(ShareVC)
                ShareVC.view.frame = self.view.frame
                self.view.addSubview(ShareVC.view)
                ShareVC.didMove(toParent: self)
            }
            /*else if (indexPath.row == 3){
             
             let storyBoard = AppStoryboard.Trainer_Setting.instance
             let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_PaymentCards") as! Trainer_PaymentCards
             //let vc = storyBoard.instantiateViewController(identifier: "Trainer_PaymentCards") as! Trainer_PaymentCards
             vc.isPurchaseSection = false
             self.navigationController?.pushViewController(vc, animated: true)
             
             // Universal_Method.universalManager.pushVC("Trainer_PaymentCards", self.navigationController, storyBoard: AppStoryboard.Trainer_Setting.rawValue)
             }*/
            /*else if (indexPath.row == 4){
             UniversalMethod.universalManager.pushVC("Upgrade_Subscription", self.navigationController, storyBoard: AppStoryboard.Trainer_Setting.rawValue)
             }
             else if (indexPath.row == 5){
             
             }*/
            else if (indexPath.row == 3){
                let storyBoard = AppStoryboard.Trainer_Tabbar.instance
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProgramPurchasedORPurchaserList") as! ProgramPurchasedORPurchaserList
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else if (indexPath.row == 4){
                
            }else if (indexPath.row == 6){
//                let purchasedStatus = DataSaver.dataSaverManager.fetchData(key: "is_purchased") as? String
//                if purchasedStatus == "0" {
                    //  UniversalMethod.universalManager.pushVC("Upgrade_Subscription", self.navigationController, storyBoard: AppStoryboard.Trainer_Setting.rawValue)
                    
                    let storyBoard = AppStoryboard.Trainer_Setting.instance
                    let vc = storyBoard.instantiateViewController(withIdentifier: "Upgrade_Subscription") as! Upgrade_Subscription
                    vc.entryPoint = .Setting
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
//                }else{
//                    UniversalMethod.universalManager.alertMessage("Already Subscription Purchased", self.navigationController)
//                }
            } else if (indexPath.row == 7){
                //                if let url = URL(string: Constants.stripeAccountRedirectURL){
                //                    let vc = SFSafariViewController(url: url)
                //                    present(vc, animated: true, completion: nil)
                //                }

                if let is_connected_stripe = DataSaver.dataSaverManager.fetchData(key: "is_connected_stripe") as? Bool, is_connected_stripe {
                    Toast.show(message: "Your account already linked with Stripe", controller: self)
                } else {
                    let storyBoard = AppStoryboard.Trainer_Setting.instance
                    let vc = storyBoard.instantiateViewController(withIdentifier: "StripeAccountIntegration") as! StripeAccountIntegration
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }else if (indexPath.row == 8){
                self.popupAlert(title: "Death Before Average",
                                message: "Are you sure you want to delete account?",
                                actionTitles: ["Yes", "No"],
                                actions: [ { _ in
                    DispatchQueue.main.async {
                        self.deleteUser(parameters:[:] )
                    }
                }, { _ in }, nil])
            } else if (indexPath.row == 9){
                let storyBoard = AppStoryboard.Trainer_Setting.instance
                let vc = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else if (indexPath.row == 10){
                // my review
//                UniversalMethod.universalManager.pushVC("Client_Review", self.navigationController,
//                                                        storyBoard: AppStoryboard.Trainer_Setting.rawValue)

                let storyBoard = AppStoryboard.Trainer_Setting.instance
                let vc = storyBoard.instantiateViewController(withIdentifier: "Client_Review") as! Client_Review
                vc.isComingFromSettingMyReviews = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)


            } else if (indexPath.row == 11){
                self.popupAlert(title: "Death Before Average",
                                message: "Are you sure you want to logout account?",
                                actionTitles: ["Yes", "No"],
                                actions: [ { _ in
                    DispatchQueue.main.async {
                        logoutFromAPP()
                    }
                }, { _ in }, nil])
            }
        }else{
            
            if indexPath.row == 0{
                /* let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Setting.rawValue, bundle: nil).instantiateViewController(withIdentifier: "Client_Edit_Profile") as! Client_Edit_Profile*/
                let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Setting.rawValue, bundle: nil).instantiateViewController(withIdentifier: "Edit_Trainer_Profile") as! Edit_Trainer_Profile
                self.addChild(ShareVC)
                ShareVC.view.frame = self.view.frame
                self.view.addSubview(ShareVC.view)
                ShareVC.didMove(toParent: self)
            }else if (indexPath.row == 1){
                let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Setting.rawValue, bundle: nil).instantiateViewController(withIdentifier: "Edit_Trainer_About") as! Edit_Trainer_About
                self.addChild(ShareVC)
                ShareVC.view.frame = self.view.frame
                self.view.addSubview(ShareVC.view)
                ShareVC.didMove(toParent: self)
            }else if (indexPath.row == 2){
                let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Setting.rawValue, bundle: nil).instantiateViewController(withIdentifier: "Edit_Trainer_Anthropometric") as! Edit_Trainer_Anthropometric
                self.addChild(ShareVC)
                ShareVC.view.frame = self.view.frame
                self.view.addSubview(ShareVC.view)
                ShareVC.didMove(toParent: self)
            }else if (indexPath.row == 3){
                // edit goals
                let storyBoard = AppStoryboard.Trainer_Setting.instance
                let vc = storyBoard.instantiateViewController(withIdentifier: "EditGoalList") as! EditGoalList
                //let vc = storyBoard.instantiateViewController(identifier: "EditGoalList") as! EditGoalList
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                /* let ShareVC = UIStoryboard(name: AppStoryboard.Onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: Onboarding.Add_Goals.rawValue) as! Add_Goals
                 ShareVC.status_Title = "Now Editing"
                 ShareVC.top_Title = "Edit Goal"
                 self.addChild(ShareVC)
                 ShareVC.view.frame = self.view.frame
                 self.view.addSubview(ShareVC.view)
                 ShareVC.didMove(toParent: self)*/
            }else if (indexPath.row == 4){
                // my review
//                UniversalMethod.universalManager.pushVC("Client_Review", self.navigationController, storyBoard: AppStoryboard.Trainer_Setting.rawValue)

                let storyBoard = AppStoryboard.Trainer_Setting.instance
                let vc = storyBoard.instantiateViewController(withIdentifier: "Client_Review") as! Client_Review
                vc.isComingFromSettingMyReviews = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)

            }else if (indexPath.row == 5){
                // my card
                
                let storyBoard = AppStoryboard.Trainer_Setting.instance
                let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_PaymentCards") as! Trainer_PaymentCards
                vc.isPurchaseSection = false
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            //            else if (indexPath.row == 6){
            //                let purchasedStatus = DataSaver.dataSaverManager.fetchData(key: "is_purchased") as? String
            //                if purchasedStatus == "0"{
            //                    UniversalMethod.universalManager.pushVC("Upgrade_Subscription", self.navigationController, storyBoard: AppStoryboard.Trainer_Setting.rawValue)
            //                }else{
            //                    UniversalMethod.universalManager.alertMessage("Already Subscription Purchased", self.navigationController)
            //                }
            //            }
            else if (indexPath.row == 6){
                let storyBoard = AppStoryboard.Trainer_Tabbar.instance
                let vc = storyBoard.instantiateViewController(withIdentifier: "ProgramPurchasedORPurchaserList") as! ProgramPurchasedORPurchaserList
                vc.isDisableAddNewWorkouts = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else if (indexPath.row == 9){
                self.popupAlert(title: "Death Before Average",
                                message: "Are you sure you want to delete account?",
                                actionTitles: ["Yes", "No"],
                                actions: [ { _ in
                    DispatchQueue.main.async {
                        self.deleteUser(parameters:[:] )
                    }
                }, { _ in }, nil])
            }else if indexPath.row == 10 {
                let storyBoard = AppStoryboard.Trainer_Setting.instance
                let vc = storyBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else if (indexPath.row == 11){
                self.popupAlert(title: "Death Before Average",
                                message: "Are you sure you want to logout account?",
                                actionTitles: ["Yes", "No"],
                                actions: [ { _ in
                    DispatchQueue.main.async {
                        logoutFromAPP()
                    }
                }, { _ in }, nil])
            }
        }
    }
    
    
    //    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
    //            completionHandler(true)
    //        }
    //
    //        let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
    //            completionHandler(true)
    //        }
    //        let swipeActionConfig = UISwipeActionsConfiguration(actions: [rename, delete])
    //        swipeActionConfig.performsFirstActionWithFullSwipe = false
    //        return swipeActionConfig
    //    }
    
    @objc func makePrivateAccount (_sender: UISwitch){
        if _sender.isOn{
            privateAccount(parameters:["private" :"1"] )
        }else{
            privateAccount(parameters:["private" :"0"] )
        }
    }
    
    @objc func setNotificationToggle (_sender: UISwitch){
        if _sender.isOn{
            notificationToggle(parameters:["notification_alert" :"1"] )
        }else{
            notificationToggle(parameters:["notification_alert" :"0"] )
        }
    }
    
    func popupAlert(title: String?,
                    message: String?,
                    actionTitles: [String?],
                    actions: [((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            if index == 0 {
                action.setValue(UIColor.red, forKey: "titleTextColor")
            }
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

func logoutFromAPP(){
    logout(parameters:[:] )
}
