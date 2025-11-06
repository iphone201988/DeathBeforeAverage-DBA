
import UIKit
import MGSwipeTableCell
import AVKit
import SDWebImage

class ExerciseByCatalogueID: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var exercise_Program_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var exercise_View: UIView!
    @IBOutlet weak var programs_View: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    var isExercise_Section = true
    var trainerSpecs = ["Male","Expert","Strongman"]
    var currentRow = Int()
    var userRole = ""
    var newUrl = ""
    
    var pageNo = 1
    var catalogueID = String()
    var catalogueName = String()
    
    var addEditDisableForTrainerDueToNavigateFromTrainerTraining = Bool()
    var editDisableForTrainerDueToNaviagateFromTrainerTrainingThenCatalogue = Bool()
    
    let playerViewController = AVPlayerViewController()
    var dateFormatter = DateFormatter()
    var isShowDoneButtonForAddCatalogueExerciseInParticularWorkout = false
    
    var selectedCatalogueExerciseID = [String]()
    var selectedCatalogueExerciseDict = [[String:String]]()
    var selectedCatalogueExercise = [String:String]()
    
    //var tagDict: M_CPEIEntity?
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interface_Title.text = "\(catalogueName) Exercise"
        
        NotificationCenter.default.addObserver(self, selector: #selector(catalogueInfo(_:)), name: NSNotification.Name(rawValue: Constants.getCataglogueDetails), object: nil)
    }
    
    @objc func catalogueInfo(_ notify:NSNotification){
        DispatchQueue.main.async {
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                addIcon.isHidden = false
                addButton.isUserInteractionEnabled = true
                editDisableForTrainerDueToNaviagateFromTrainerTrainingThenCatalogue = false
                if addEditDisableForTrainerDueToNavigateFromTrainerTraining == true{
                    addIcon.isHidden = true
                    addButton.isUserInteractionEnabled = false
                    editDisableForTrainerDueToNaviagateFromTrainerTrainingThenCatalogue = true
                }
                
                if isShowDoneButtonForAddCatalogueExerciseInParticularWorkout{
                    addButton.setTitle("Done", for: .normal)
                    addIcon.isHidden = true
                }else{
                    addButton.setTitle("", for: .normal)
                    addIcon.isHidden = false
                }
                
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                addIcon.isHidden = true
                addButton.isUserInteractionEnabled = false
            }
        }
        
        getExerciseByFolderID(parameters:[:], catalogueID)
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        if isShowDoneButtonForAddCatalogueExerciseInParticularWorkout{
            
            if selectedCatalogueExerciseID.count > 0{
                
                //let separatedCommaCatalogueExerciseIDs = selectedCatalogueExerciseID.joined(separator: ",")
                
                if let jsonString = toJsonString(self.selectedCatalogueExerciseDict){
                    
                    self.mergeTrainingExcercise(parameters:["training_id":particularProgramTraining?.id ?? "",
                                                            "program_id":particularProgramTraining?.programID ?? "",
                                                            "folder_id":self.catalogueID,
                                                            "exercise_id":jsonString])
                }
            }
            
        }else{
            UniversalMethod.universalManager.pushVC("Trainer_Add_Exercise", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
        }
    }
    
    //MARK: Helper's Method
}

extension ExerciseByCatalogueID: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = exerciseInfos?.data?.count else{
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise_Programs_Cell", for: indexPath) as? Exercise_Programs_Cell {

            if isTrainer == "Trainer" {

                if addEditDisableForTrainerDueToNavigateFromTrainerTraining != true{
                    let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.removeExercise(at: indexPath.row)

                        return true
                    }

                    //                let sendButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "sendIcon"), backgroundColor: #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    //                    self?.sendExerciseToClient(at: indexPath.row)
                    //                    return true
                    //                }

                    //cell.rightButtons = [deleteButton,sendButton]

                    cell.rightButtons = [deleteButton]
                }
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
                    cell.videoThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
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

            if isShowDoneButtonForAddCatalogueExerciseInParticularWorkout{
                if selectedCatalogueExerciseID.contains(particularExercise?.id ?? ""){
                    cell.backgroundColor = UIColor(named: "#C1BDCD")
                }else{
                    cell.backgroundColor = .clear
                }
            }else{
                cell.backgroundColor = .clear
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        particularExercise = exerciseInfos?.data?[indexPath.row]
        if isShowDoneButtonForAddCatalogueExerciseInParticularWorkout{
            if let particularExerciseID = particularExercise?.id{
                if selectedCatalogueExerciseID.count == 0{
                    selectedCatalogueExerciseID.append(particularExerciseID)
                    showCataloguePopup(particularExerciseID,
                                       particularExercise?.sets,
                                       particularExercise?.reps,
                                       particularExercise?.time)
                }else{
                    if selectedCatalogueExerciseID.contains(particularExerciseID){
                        if let containedValuePosition = selectedCatalogueExerciseID.firstIndex(of: particularExerciseID){
                            selectedCatalogueExerciseID.remove(at: containedValuePosition)
                            
                            _ = selectedCatalogueExerciseDict.enumerated().compactMap({ index, element in
                                if element["exercise_id"] == particularExerciseID{
                                    selectedCatalogueExerciseDict.remove(at: index)
                                }
                            })
                            
                            if let jsonString = toJsonString(self.selectedCatalogueExerciseDict){
                                
                            }
                        }
                    }else{
                        selectedCatalogueExerciseID.append(particularExerciseID)
                        showCataloguePopup(particularExerciseID,
                                           particularExercise?.sets,
                                           particularExercise?.reps,
                                           particularExercise?.time)
                    }
                }
            }
            
            self.exercise_Program_Tableview.reloadData()
            
        }else{
            /*  entityDict = clientExProInfo?.entities?[indexPath.row]*/
            let storyBoard = AppStoryboard.Trainer_Tabbar.instance
            let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Exercise_View") as! Trainer_Exercise_View
            /*  vc.desc = entityDict?.entityDescription ?? ""
             vc.name = entityDict?.name ?? ""
             vc.selectedRow = indexPath.row*/
            vc.addEditDisableForTrainerDueToNavigateFromTrainerTraining = editDisableForTrainerDueToNaviagateFromTrainerTrainingThenCatalogue
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            //UniversalMethod.universalManager.pushVC("Trainer_Exercise_View", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    //  UniversalMethod.universalManager.pushVC("Trainer_s_Clients", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    
    private func sendExerciseToClient(at index: Int) {
        let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Trainer_s_Clients") as! Trainer_s_Clients
        let particularExercise = exerciseInfos?.data?[index]
        vc.dataID = particularExercise?.id
        vc.dataIDType = "2"
        vc.isSend = "1"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func removeExercise(at index: Int) {
        
        //        let particularCatalogueInfo = catalogueID//exerciseCatalogueInfos?.data?[index]
        callDeleteExerciseCatalogue(parameters:["folder_id":"\(catalogueID)", "exercise_id": "\(exerciseInfos?.data?[index].id ?? "")"], indexToRemove: index)
        //deleteExercise(parameters:["excercise_id" :exerciseInfos?.data?[index].id ?? "0"] )
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
    
    func showCataloguePopup(_ catalogueExerciseID:String? = nil,
                            _ sets:String? = nil,
                            _ reps:String? = nil,
                            _ time:String? = nil){
        
        let alertController = UIAlertController(title: "DBA Fitness", message: "",
                                                preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField : UITextField) -> Void in
            
            textField.placeholder = "Sets"
            textField.text = sets ?? ""
            textField.keyboardType = .default

            alertController.addTextField { (textField: UITextField) in
                textField.placeholder = "Reps"
                textField.text = reps ?? ""
                textField.keyboardType = .default
            }
            
            alertController.addTextField { (textField: UITextField) in
                textField.placeholder = "Time"
                textField.text = time ?? ""
                textField.keyboardType = .default
            }
        }
        
        let saveAction = UIAlertAction(title: "Done",
                                       style: UIAlertAction.Style.default,
                                       handler: { alert -> Void in

            let totalSets = alertController.textFields?.first?.text?.trimmed()
            let totalResps = alertController.textFields?[1].text?.trimmed()
            let totalTime = alertController.textFields?[2].text?.trimmed()
            
            self.selectedCatalogueExercise["exercise_id"] = catalogueExerciseID
            self.selectedCatalogueExercise["sets"] = totalSets
            self.selectedCatalogueExercise["reps"] = totalResps
            self.selectedCatalogueExercise["time"] = totalTime
            self.selectedCatalogueExerciseDict.append(self.selectedCatalogueExercise)
            
            if let jsonString = toJsonString(self.selectedCatalogueExerciseDict){
                
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

public func toJsonString(_ dict:[[String : String]]) -> String?{
    let encoder = JSONEncoder()
    if let jsonData = try? encoder.encode(dict) {
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    }
    return nil
}
