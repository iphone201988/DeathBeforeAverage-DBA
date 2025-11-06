
import UIKit
import MGSwipeTableCell
import AVKit
import SDWebImage
import MessageUI

class Trainer_Exercise_Programs: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var exercise_Program_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var exercise_View: UIView!
    @IBOutlet weak var programs_View: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    @IBOutlet weak var emptyViewTitle: UILabel!
    @IBOutlet weak var emptyViewDesc: UILabel!
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    var isExercise_Section = true
    var trainerSpecs = ["Male","Expert","Strongman"]
    var currentRow = Int()
    var userRole = ""
    var newUrl = ""
    
    var pageNo = 1
    
    let playerViewController = AVPlayerViewController()
    var dateFormatter = DateFormatter()
    
    
    var receiverEmail = ""
    var receiverProgramName = ""
    var loggedUserName = String()
    
    //var tagDict: M_CPEIEntity?
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        exercise_View.layer.cornerRadius = 4.0
        programs_View.layer.cornerRadius = 4.0
        
        self.exercise_View.layoutIfNeeded()
        exercise_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        exercise_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        programs_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        Constants.currentTab  = "1"
        NotificationCenter.default.addObserver(self, selector: #selector(programsInfo(_:)),
                                               name: NSNotification.Name(rawValue: Constants.getProgramsDetails), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(catalogueInfo(_:)),
                                               name: NSNotification.Name(rawValue: Constants.getCataglogueDetails), object: nil)


    }

    @objc func programsInfo(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            exercise_Program_Tableview.reloadData()
        }
    }

    @objc func catalogueInfo(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            self.exercise_Program_Tableview.delegate = self
            self.exercise_Program_Tableview.dataSource = self
            self.exercise_Program_Tableview.register(UINib(nibName: "Trainer_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Trainer_Programs_Cell")
            self.exercise_Program_Tableview.register(UINib(nibName: "Exercise_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Exercise_Programs_Cell")
            self.exercise_Program_Tableview.register(UINib(nibName: "Client_Program_Cell", bundle: nil), forCellReuseIdentifier: "Client_Program_Cell")
            self.exercise_Program_Tableview.register(UINib(nibName: "Client_Progress", bundle: nil), forCellReuseIdentifier: "Client_Progress")
            self.exercise_Program_Tableview.reloadData()
        }else{
            self.exercise_Program_Tableview.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        
        
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                
                interface_Title.text = "Program Builder"
                
                if Constants.currentTab == "1"{
                    //getExercise(parameters:[:])
                    callGetExerciseCatalogue(parameters:[:] )
                }else{
                    getPrograms(parameters:[:])
                }
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                
                loggedUserName = DataSaver.dataSaverManager.fetchData(key: "firstname") as? String ?? ""
                interface_Title.text = "\(loggedUserName )'s Programs"
                
                isExercise_Section = false
                
                //                self.exercise_View.removeGradient()
                //                programs_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
                //                programs_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
                //                exercise_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
                
                self.viewDidLayoutSubviews()
                self.view.layoutIfNeeded()
                
                Constants.currentTab = "2"
                getPrograms(parameters:[:])
                
                
                /*
                 if Constants.currentTab == "1"{
                 //getExercise(parameters:[:])
                 callGetExerciseCatalogue(parameters:[:] )
                 }else{
                 getPrograms(parameters:[:])
                 }
                 */
                
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        if userRole != ""{
            if (userRole == Role.client.rawValue){
                self.exercise_View.removeGradient()
                programs_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
                programs_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
                exercise_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        if  let remainingPagesCount = DataSaver.dataSaverManager.fetchData(key: "remainingPages") as? Int{
            _ = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if scrollView == exercise_Program_Tableview{
                if (scrollView.contentOffset.y == /*0*/ maximumOffset) {
                    if remainingPagesCount < 1{
                        // UniversalMethod.universalManager.alertMessage("No Product left", self.navigationController)
                    }else{
                        pageNo = pageNo + 1
                        if Constants.currentTab == "1"{
                            //getExercise(parameters:[:])
                            callGetExerciseCatalogue(parameters:[:] )
                        }else{
                            getPrograms(parameters:[:])
                        }
                    }
                }
            }
        }
    }
    
    
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        
        if isExercise_Section == true{
            //UniversalMethod.universalManager.pushVC("Trainer_Add_Exercise", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
            showCataloguePopup()
        }else{
            if let is_connected_stripe = DataSaver.dataSaverManager.fetchData(key: "is_connected_stripe") as? Bool, is_connected_stripe {
                UniversalMethod.universalManager.pushVC("Trainer_Add_Program", self.navigationController, storyBoard: AppStoryboard.Trainer_Program.rawValue)
            } else {
                Toast.show(message: "Activate your Stripe account to begin building programs. Please visit your account settings to do so.", controller: self)
            }
        }
    }
    
    
    @IBAction func myExercise_Action(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
            self.emptyViewTitle.text = "No Exercises Created"
            self.emptyViewDesc.text = "Looks like you haven't created any exercises yet. Click the plus in the top right corner to get started!"
            self.empty_View.isHidden = true
            self.isExercise_Section = true
            
            if self.userRole == Role.client.rawValue{
                self.interface_Title.text = "\(self.loggedUserName )'s Programs"
            }else{
                self.interface_Title.text = "Program Builder"
            }
            
            
            //            if let layer = self.programs_View.layer.sublayers? .first {
            //                layer.removeFromSuperlayer ()
            //            }
            
            self.programs_View.removeGradient()
            self.exercise_View.gradientBackground(from: self.startColor, to: self.endColor, direction: .leftToRight)
            self.exercise_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
            self.programs_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
            self.view.layoutIfNeeded()
            Constants.currentTab = "1"
            //self.getExercise(parameters:[:])
            self.callGetExerciseCatalogue(parameters:[:] )
        }
        
        
        
        /*  if isTrainer == "Trainer"{
         Constant.currentTab = "1"
         getTrainerEx(parameters:[:] )
         }else{
         self.exercise_Program_Tableview.reloadData()
         }*/
        
    }
    
    @IBAction func myPrograms_Action(_ sender: UIButton) {
        isExercise_Section = false
        
        self.emptyViewTitle.text = "No Programs Created"
        self.emptyViewDesc.text = "Looks like you haven't built any programs yet. Click the plus in the top right corner to get started!"
        self.empty_View.isHidden = true
        if self.userRole == Role.client.rawValue{
            self.interface_Title.text = "\(self.loggedUserName )'s Programs"
        }else{
            interface_Title.text = "Program Builder"
        }
        
        //        if let layer = exercise_View.layer.sublayers? .first {
        //            layer.removeFromSuperlayer ()
        //        }
        self.exercise_View.removeGradient()
        programs_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        programs_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
        exercise_View.customViewsShadow(red: 28/255, green: 20/255, blue: 54/255, alpha: 1.0, width: 0, height: 5, opacity: 0.58, radius: 9)
        
        Constants.currentTab = "2"
        getPrograms(parameters:[:])
        
        
        /* if isTrainer == "Trainer"{
         Constant.currentTab = "2"
         getTrainerClientExPro(parameters:[:] )
         }else{
         self.exercise_Program_Tableview.reloadData()
         }*/
    }
    
    //MARK: Helper's Method
    
    func showCataloguePopup(_ catalogueName:String? = nil,
                            _ catalogueID:String? = nil,
                            _ sets: String? = nil,
                            _ reps: String? = nil,
                            _ time: String? = nil){
        
        var alertTitle = String()
        
        var titleValue = ""
        if let catalogueID, !catalogueID.isEmpty {
            titleValue = "Update An Exercise Category"
        } else {
            titleValue = "Create An Exercise Category"
        }
        
        let alertController = UIAlertController(title: titleValue,
                                                message: "",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Category Name"
            if catalogueName == nil{
                textField.text = ""
                alertTitle = "Create"
                
                //MARK: Added by Geetam to adding more information about catalogue: Sets/Reps/Time
                //                alertController.addTextField { (textField: UITextField) in
                //                    textField.placeholder = "Sets"
                //                }
                //                alertController.addTextField { (textField: UITextField) in
                //                    textField.placeholder = "Reps"
                //                }
                //                alertController.addTextField { (textField: UITextField) in
                //                    textField.placeholder = "Time"
                //                }
                
            }else{
                
                //                alertController.addTextField { (textField: UITextField) in
                //                    textField.placeholder = "Sets"
                //                    textField.text = sets ?? ""
                //                }
                //
                //                alertController.addTextField { (textField: UITextField) in
                //                    textField.placeholder = "Reps"
                //                    textField.text = reps ?? ""
                //                }
                //
                //                alertController.addTextField { (textField: UITextField) in
                //                    textField.placeholder = "Time"
                //                    textField.text = time ?? ""
                //                }
                
                textField.text = catalogueName
                alertTitle = "Renamed"
                
            }
        }
        
        let saveAction = UIAlertAction(title: alertTitle, style: UIAlertAction.Style.default, handler: { alert -> Void in
            _ = alertController.textFields![0] as UITextField
            
            let catalogueName = alertController.textFields?.first?.text?.trimmed()
            
            if catalogueName != ""{
                
                if catalogueName?.count ?? 0 > 50{
                    UniversalMethod.universalManager.alertMessage("Category Name not more than 50 characters", self.navigationController)
                }else{
                    if catalogueID == nil{
                        self.callCreateExerciseCatalogue(parameters: ["title":alertController.textFields?[0].text ?? "",
                                                                      //"sets": alertController.textFields?[1].text ?? "",
                                                                      //"reps": alertController.textFields?[2].text ?? "",
                                                                      //"time": alertController.textFields?[3].text ?? ""
                                                                     ], true)
                    }else{
                        self.callCreateExerciseCatalogue(parameters: ["title":alertController.textFields?[0].text ?? "",
                                                                      "folder_id":catalogueID ?? "",
                                                                      //"sets": alertController.textFields?[1].text ?? "",
                                                                      //"reps": alertController.textFields?[2].text ?? "",
                                                                      //"time": alertController.textFields?[3].text ?? ""
                                                                     ], false)
                    }
                }
            }else{
                UniversalMethod.universalManager.alertMessage("Category Name cannot be empty", self.navigationController)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension Trainer_Exercise_Programs: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Constants.currentTab == "1"{
            
            /* guard let count = exerciseInfos?.data?.count else{
             empty_View.isHidden = false
             return 0
             }
             
             if count  > 0{
             empty_View.isHidden = true
             }else{
             empty_View.isHidden = false
             }
             return count*/
            
            guard let count = exerciseCatalogueInfos?.data?.count else{
                empty_View.isHidden = false
                return 0
            }
            
            if count == 0{
                empty_View.isHidden = false
            }else{
                empty_View.isHidden = true
            }
            return count
            
        }else{
            guard let count = programInfos?.data?.count else{
                empty_View.isHidden = false
                return 0
            }
            
            if count  > 0{
                empty_View.isHidden = true
            }else{
                empty_View.isHidden = false
            }
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //MARK: Added by Geetam to fix the issue of cell height in exercise section
        if isExercise_Section{
            return UITableView.automaticDimension //100
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // let dict = clientExProInfo?.entities?[indexPath.row]
        
        if isExercise_Section == true{
            /* let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise_Programs_Cell", for: indexPath) as! Exercise_Programs_Cell
             
             if isTrainer == "Trainer"{
             
             let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
             self?.removeExercise(at: indexPath.row)
             return true
             }
             
             let sendButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "sendIcon"), backgroundColor: #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
             self?.sendExerciseToClient(at: indexPath.row)
             return true
             }
             cell.rightButtons = [deleteButton,sendButton]
             }else{
             let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
             self?.removeExercise(at: indexPath.row)
             return true
             }
             
             cell.rightButtons = [deleteButton]
             }
             
             
             particularExercise = exerciseInfos?.data?[indexPath.row]
             cell.exerciseName.text = particularExercise?.excerciseName
             
             if let photo = particularExercise?.thumbnil{
             if photo != ""{
             let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
             cell.videoThumbnail.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "waitPostImage"), options: .highPriority)
             }else{
             cell.videoThumbnail.image = #imageLiteral(resourceName: "workoutSampleImage")
             }
             }
             
             if particularExercise?.excerciseVideo != ""{
             cell.playIcon.image = #imageLiteral(resourceName: "playButton")
             }else{
             cell.playIcon.image = #imageLiteral(resourceName: "noVideo")
             }
             cell.playButton.tag = indexPath.row
             cell.playButton.addTarget(self, action: #selector(playExerciseVideo(_sender:)), for: .touchUpInside)
             cell.configure()
             
             //cell.textLabel
             */
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Client_Progress", for: indexPath) as? Client_Progress {

                //            let particularCatalogueInfo = exerciseCatalogueInfos?.data?[indexPath.row]
                //            cell.days_Text.text = "\(particularCatalogueInfo?.title ?? "")\nSets: \(particularCatalogueInfo?.sets ?? "")\nReps: \(particularCatalogueInfo?.reps ?? "")\nTime: \(particularCatalogueInfo?.time ?? "")"
                //            cell.days_Text.text = "\(particularCatalogueInfo?.title ?? "")"
                //            cell.days_Text.numberOfLines = 4
                //            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                //            let createDate = dateFormatter.date(from: (particularCatalogueInfo?.createdon))
                //            dateFormatter.dateFormat = "EEE, MMM d"
                //            cell.time_Text.text = dateFormatter.string(from: createDate)
                //            cell.dateTimeStampViewHeight.constant = 0.0


                let particularCatalogueInfo = exerciseCatalogueInfos?.data?[indexPath.row]
                cell.days_Text.text = particularCatalogueInfo?.title
                cell.days_Text.numberOfLines = 2
                cell.dateTimeStampViewHeight.constant = 0.0

                if isTrainer == "Trainer"{
                    let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.removeExercise(at: indexPath.row)
                        return true
                    }

                    let editButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "edit_icon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.editGoal(at: indexPath.row)
                        return true
                    }

                    _ = RowActionButton(title: "", icon: #imageLiteral(resourceName: "sendIcon"), backgroundColor: #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.sendExerciseCatalogueToClient(at: indexPath.row)
                        return true
                    }

                    cell.rightButtons = [deleteButton,editButton]
                }else{
                    let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.removeExercise(at: indexPath.row)
                        return true
                    }

                    cell.rightButtons = [deleteButton]
                }

                cell.configure()

                return cell
            } else {
                return UITableViewCell()
            }
        }else{
            
            if isTrainer == "Trainer"{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "Trainer_Programs_Cell", for: indexPath) as? Trainer_Programs_Cell {

                    particularPrograms = programInfos?.data?[indexPath.row]
                    cell.program_Name.text = particularPrograms?.programName

                    currentRow = indexPath.row
                    cell.trainer_Specs_Collection.delegate = self
                    cell.trainer_Specs_Collection.dataSource = self
                    cell.trainer_Specs_Collection.register(UINib(nibName: "Trainer_Specs_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Specs_Cell")
                    cell.trainer_Specs_Collection.reloadData()

                    let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.removeProgram(at: indexPath.row)
                        return true
                    }

                    let sendButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "sendIcon"), backgroundColor: #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.sendProgramToClient(at: indexPath.row)
                        return true
                    }

                    let copyButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "copyIcon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.copyProgram(at: indexPath.row)
                        return true
                    }


                    /*         let sendButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "sendIcon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                     self?.sendProgram(at: indexPath.row)
                     return true
                     }

                     let copyButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "copyIcon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                     self?.copyProgram(at: indexPath.row)
                     return true
                     }*/

                    //cell.rightButtons = [deleteButton,copyButton,sendButton]

                    //cell.rightButtons = [deleteButton, sendButton]

                    cell.rightButtons = [deleteButton,sendButton,copyButton]

                    cell.configure()

                    return cell
                } else {
                    return UITableViewCell()
                }
            }else{
                if let cell = tableView.dequeueReusableCell(withIdentifier: "Client_Program_Cell", for: indexPath) as? Client_Program_Cell {
                    particularPrograms = programInfos?.data?[indexPath.row]
                    cell.program_Name.text = particularPrograms?.programName
                    currentRow = indexPath.row
                    cell.trainer_Specs_Collection.delegate = self
                    cell.trainer_Specs_Collection.dataSource = self
                    cell.trainer_Specs_Collection.register(UINib(nibName: "Trainer_Specs_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Specs_Cell")
                    cell.trainer_Specs_Collection.reloadData()
                    cell.emptyTags.isHidden = true
                    cell.purchaseButton.tag = indexPath.row

                    if programInfos?.data?[indexPath.row].isPurchased == "0" {
                        cell.purchaseIcon.isHidden = false
                        cell.purchaseButton.isUserInteractionEnabled = true
                    } else {
                        cell.purchaseIcon.isHidden = true
                        cell.purchaseButton.isUserInteractionEnabled = false
                    }

                    cell.purchaseButton.addTarget(self, action: #selector(tappedPurchaseProgram(_:)), for: .touchUpInside)

                    if let photoss = particularPrograms?.image{
                        if photoss != ""{
                            let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                            
                            cell.trainer_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.trainer_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                        }else{
                            cell.trainer_Pic.image = #imageLiteral(resourceName: "user")
                        }
                    }

                    let inquireButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "survey"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.inquireAboutProgram(at: indexPath.row)
                        return true
                    }
                    cell.rightButtons = [inquireButton]
                    cell.configure()
                    return cell
                } else {
                    return UITableViewCell()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isExercise_Section == false{
            
            particularPrograms = programInfos?.data?[indexPath.row]
            //   Universal_Method.universalManager.pushVC("Buy_Program", self.navigationController, storyBoard: AppStoryboard.Trainer_Program.rawValue)
            if (userRole == Role.trainer.rawValue){
                navigateOnProgramDetailsInterface()
            }else{
                if particularPrograms?.isPurchased == "0"{
                    UniversalMethod.universalManager.alertMessage("Please purchase this program first by tapping the shopping cart icon.", self)
                }else{
                    navigateOnProgramDetailsInterface()
                }
            }
            
        }else if (isExercise_Section == true){
            
            /*particularExercise = exerciseInfos?.data?[indexPath.row]
             
             /*  entityDict = clientExProInfo?.entities?[indexPath.row]*/
             let storyBoard = AppStoryboard.Trainer_Tabbar.instance
             let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Exercise_View") as! Trainer_Exercise_View
             /*  vc.desc = entityDict?.entityDescription ?? ""
              vc.name = entityDict?.name ?? ""
              vc.selectedRow = indexPath.row*/
             self.navigationController?.pushViewController(vc, animated: true)
             //UniversalMethod.universalManager.pushVC("Trainer_Exercise_View", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
             */
            
            let particularCatalogueInfo = exerciseCatalogueInfos?.data?[indexPath.row]
            let storyBoard = AppStoryboard.Trainer_Tabbar.instance
            let vc = storyBoard.instantiateViewController(withIdentifier: "ExerciseByCatalogueID") as! ExerciseByCatalogueID
            vc.catalogueID = particularCatalogueInfo?.id ?? ""
            vc.catalogueName = particularCatalogueInfo?.title ?? ""
            selectedCatalgoueID = particularCatalogueInfo?.id ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    //  UniversalMethod.universalManager.pushVC("Trainer_s_Clients", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    
    func navigateOnProgramDetailsInterface(){
        let storyBoard = AppStoryboard.Trainer_Program.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Program_Details") as! Trainer_Program_Details
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func sendExerciseToClient(at index: Int) {
        let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Trainer_s_Clients") as! Trainer_s_Clients
        let particularExercise = exerciseInfos?.data?[index]
        vc.dataID = particularExercise?.id
        vc.dataIDType = "2"
        vc.isSend = "1"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func sendExerciseCatalogueToClient(at index: Int) {
        let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Trainer_s_Clients") as! Trainer_s_Clients
        let particularCatalogueInfo = exerciseCatalogueInfos?.data?[index]
        vc.dataID = particularCatalogueInfo?.id
        vc.dataIDType = "2" //Optional in the case of send exercise catalogue
        vc.isSend = "2"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func sendProgramToClient(at index: Int) {
        let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Trainer_s_Clients") as! Trainer_s_Clients
        let particularPrograms = programInfos?.data?[index]
        vc.dataID = particularPrograms?.id
        vc.dataIDType = "1"
        vc.isSend = "1"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func removeProgram(at index: Int) {
        Constants.isEditProgram = "2"
        particularPrograms = programInfos?.data?[index]
        addProgram(parameters:["program_id":particularPrograms?.id ?? "0"] ,indexToRemove: index)
        
    }
    
    private func copyProgram(at index: Int) {
        if let programID = programInfos?.data?[index].id{
            copyProgram(parameters:["program_id":programID] )
        }
    }
    
    private func buyProgram(at index: Int) {
        
        
        let particularPrograms = programInfos?.data?[index]
        
        if particularPrograms?.isPurchased == "0"{
            let vc = AppStoryboard.Trainer_Program.instance.instantiateViewController(withIdentifier: "Buy_Program") as! Buy_Program
            vc.particularPrograms = particularPrograms
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            //UniversalMethod.universalManager.pushVC("Buy_Program", self.navigationController, storyBoard: AppStoryboard.Trainer_Program.rawValue)
        }else{
            Toast.show(message: "Already Purchased", controller: self)
        }
    }
    
    private func inquireAboutProgram(at index: Int) {
        let particularPrograms = programInfos?.data?[index]
        
        receiverEmail = particularPrograms?.email ?? ""
        receiverProgramName = particularPrograms?.programName ?? ""
        
        let mailComposeViewController = self.shareconfiguredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func sendProgram(at index: Int) {
        
        UniversalMethod.universalManager.pushVC("Send_Program_Client", self.navigationController, storyBoard: AppStoryboard.Trainer_Program.rawValue)
    }
    
    private func removeExercise(at index: Int) {
        
        let particularCatalogueInfo = exerciseCatalogueInfos?.data?[index]
        callDeleteExerciseCatalogue(parameters:["folder_id":"\(particularCatalogueInfo?.id ?? "")"] )
        //deleteExercise(parameters:["excercise_id" :exerciseInfos?.data?[index].id ?? "0"] )
    }
    
    private func editGoal(at index: Int) {
        
        let particularCatalogueInfo = exerciseCatalogueInfos?.data?[index]
        showCataloguePopup(particularCatalogueInfo?.title, particularCatalogueInfo?.id, particularCatalogueInfo?.sets, particularCatalogueInfo?.reps, particularCatalogueInfo?.time)
    }
    
    @objc func playExerciseVideo(_sender: UIButton){
        particularExercise = exerciseInfos?.data?[_sender.tag]
        if particularExercise?.excerciseVideo != ""{
            let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(particularExercise?.excerciseVideo ?? "")"
            if let videoURL = URL(string: completePicUrl) {
                let player = AVPlayer(url: videoURL)
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    self.playerViewController.player?.play()
                }
            }

        }
    }
    
    @objc func tappedPurchaseProgram(_ sender: UIButton){
        let particularPrograms = programInfos?.data?[sender.tag]
        if particularPrograms?.isPurchased == "0" {
            let vc = AppStoryboard.Trainer_Program.instance.instantiateViewController(withIdentifier: "Buy_Program") as! Buy_Program
            vc.particularPrograms = particularPrograms
            vc.stripe_secret_key = particularPrograms?.stripe_secret_key ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Toast.show(message: "Already Purchased", controller: self)
        }
    }
}

extension Trainer_Exercise_Programs: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        if indexPath.item == 0{
            label.text = particularPrograms?.sex
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        }else if (indexPath.item == 1){
            label.text = particularPrograms?.levelOfTraining
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        }else{
            label.text = particularPrograms?.category
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trainer_Specs_Cell", for: indexPath) as? Trainer_Specs_Cell {

            if indexPath.item == 0{
                cell.specs_View.backgroundColor = UIColor(named: "Gender_View")
                cell.specs_Title.text = particularPrograms?.sex
            }else if indexPath.item == 1{
                cell.specs_View.backgroundColor = UIColor(named: "Training_Type")
                cell.specs_Title.text = particularPrograms?.levelOfTraining
            }else{
                cell.specs_View.backgroundColor = UIColor(named: "Receiver_Message")
                cell.specs_Title.text = particularPrograms?.category
            }

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}

extension Trainer_Exercise_Programs: MFMailComposeViewControllerDelegate{
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients([receiverEmail])
        mailComposerVC.setSubject("Contact Us/Feedback")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        let loggedUserEmail = DataSaver.dataSaverManager.fetchData(key: "email") as? String ?? ""
        
        mailComposerVC.setPreferredSendingEmailAddress(loggedUserEmail)
        return mailComposerVC
    }
    
    func shareconfiguredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients([receiverEmail])
        mailComposerVC.setSubject("Contact Us/Feedback")
        mailComposerVC.setMessageBody("", isHTML: false)
        let loggedUserEmail = DataSaver.dataSaverManager.fetchData(key: "email") as? String ?? ""
        mailComposerVC.setPreferredSendingEmailAddress(loggedUserEmail)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
