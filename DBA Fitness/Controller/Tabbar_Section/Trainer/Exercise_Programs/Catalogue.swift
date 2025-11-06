
import UIKit
import MGSwipeTableCell
import AVKit
import SDWebImage
import MessageUI

class Catalogue: UIViewController {
    
    //MARK : Outlets
    @IBOutlet weak var exercise_Program_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var exercise_View: UIView!
    @IBOutlet weak var programs_View: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    
    //MARK : Variables
    var dateFormatter = DateFormatter()
    var training_id = String()
    var program_id = String()
    var selectedCatalogueID = [String]()
    var isShowDoneButtonForAddCatalogueExerciseInParticularWorkout = false
    
    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(catalogueInfo(_:)), name: NSNotification.Name(rawValue: Constants.getCataglogueDetails), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callGetExerciseCatalogue(parameters:[:] )
        selectedCatalogueID.removeAll()
    }
    
    //MARK : IB's Action
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        if selectedCatalogueID.count > 0{
            let separatedCommaCatalogueIDs = selectedCatalogueID.joined(separator: ",")
            self.mergeTrainingExcercise(parameters:["training_id":particularProgramTraining?.id ?? "",
                                                    "program_id":particularProgramTraining?.programID ?? "",
                                                    "folder_id":separatedCommaCatalogueIDs])
        }
    }
    
    //MARK: Helper's Method
    @objc func catalogueInfo(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            self.exercise_Program_Tableview.delegate = self
            self.exercise_Program_Tableview.dataSource = self
            self.exercise_Program_Tableview.register(UINib(nibName: "Client_Progress", bundle: nil), forCellReuseIdentifier: "Client_Progress")
            self.exercise_Program_Tableview.reloadData()
        }else{
            self.exercise_Program_Tableview.reloadData()
        }
    }
}

extension Catalogue: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Client_Progress", for: indexPath) as? Client_Progress {
            let particularCatalogueInfo = exerciseCatalogueInfos?.data?[indexPath.row]
            cell.days_Text.text = particularCatalogueInfo?.title
            cell.days_Text.numberOfLines = 2
            cell.dateTimeStampViewHeight.constant = 0.0

            if selectedCatalogueID.contains(particularCatalogueInfo?.id ?? ""){
                cell.backgroundColor = UIColor(named: "#C1BDCD")
            }else{
                cell.backgroundColor = .clear
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*  let particularCatalogueInfo = exerciseCatalogueInfos?.data?[indexPath.row]
         if selectedCatalogueID.count > 0{
         if selectedCatalogueID.contains(particularCatalogueInfo?.id ?? ""){
         let indexVal = selectedCatalogueID.firstIndex(of: particularCatalogueInfo?.id ?? "")
         if let index = indexVal{
         selectedCatalogueID.remove(at: index)
         }
         }else{
         selectedCatalogueID.append(particularCatalogueInfo?.id ?? "")
         }
         }else{
         selectedCatalogueID.append(particularCatalogueInfo?.id ?? "")
         }

         self.exercise_Program_Tableview.reloadData()*/
        
        let particularCatalogueInfo = exerciseCatalogueInfos?.data?[indexPath.row]
        let storyBoard = AppStoryboard.Trainer_Tabbar.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "ExerciseByCatalogueID") as! ExerciseByCatalogueID
        vc.catalogueID = particularCatalogueInfo?.id ?? ""
        vc.catalogueName = particularCatalogueInfo?.title ?? ""
        selectedCatalgoueID = particularCatalogueInfo?.id ?? ""
        vc.isShowDoneButtonForAddCatalogueExerciseInParticularWorkout = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension Catalogue{
    func mergeTrainingExcercise(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.merge_training_excercise, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        self.navigationController?.popViewController(animated: true)
                        
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

extension ExerciseByCatalogueID{
    func mergeTrainingExcercise(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.merge_training_excercise,
                                   parameters: parameters,
                                   method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        self.navigationController?.popViewController(animated: true)
                        
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
