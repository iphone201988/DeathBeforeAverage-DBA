
import UIKit

class Trainer_Program_Details: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var training_Goal: UITextField!
    @IBOutlet weak var dayOfWeek: UITextField!
    @IBOutlet weak var training_View: UIView!
    @IBOutlet weak var nutrition_View: UIView!
    @IBOutlet weak var supplement_View: UIView!
    @IBOutlet weak var specs_Collectionview: UICollectionView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var programsName: UILabel!
    @IBOutlet weak var programsDesc: UILabel!
    @IBOutlet weak var emptyTags: UILabel!
    @IBOutlet weak var trainerGoal: UILabel!
    
    var trainerSpecs = [String]()
    var tags:String?
    var goals:String?
    var programName:String?
    var programTenure = Int()
    var programDesc:String?
    var selectedRow = Int()
    var gender = ""
    var level = ""
    var category = ""
    var userRole = ""
    var isDisableAddNewWorkouts = false
    var isNavigateViaSentProgramDetails = false
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specs_Collectionview.delegate = self
        specs_Collectionview.dataSource = self
        specs_Collectionview.register(UINib(nibName: "Trainer_Specs_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Specs_Cell")
        
        // Do any additional setup after loading the view.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        training_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        nutrition_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        supplement_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                editLabel.isHidden = false
                editButton.isUserInteractionEnabled = true
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                editLabel.isHidden = true
                editButton.isUserInteractionEnabled = false
            }
        }
        
        trainerGoal.text = "Goal: \(particularPrograms?.goals ?? "N/A")"
        dayOfWeek.text = particularPrograms?.daysPerWeek
        programsName.text = particularPrograms?.programName
        programsDesc.text = particularPrograms?.programDescription
        
        if isNavigateViaSentProgramDetails {
            editLabel.isHidden = true
            editButton.isUserInteractionEnabled = false
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func edit(_ sender: UIButton) {
        
        let storyBoard = AppStoryboard.Trainer_Program.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Edit_Program") as! Trainer_Edit_Program
        vc.selectedRow = selectedRow
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //UniversalMethod.universalManager.pushVC("Trainer_Edit_Program", self.navigationController, storyBoard: AppStoryboard.Trainer_Program.rawValue)
    }
    
    @IBAction func back(_ sender: UIButton) {
        
        //self.navigationController?.popViewController(animated: true)
        
        if isNavigateViaSentProgramDetails {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popToViewController(ofClass: Trainer_Exercise_Programs.self)
        }
    }
    
    @IBAction func training_Action(_ sender: UIButton) {
        /*
         trainerProgram = clientExProInfo?.entities?[selectedRow]
         let storyBoard = AppStoryboard.Trainer_Training.instance
         let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Training_Section") as! Trainer_Training_Section
         vc.selectedRow = selectedRow
         vc.tags = trainerProgram?.tags
         vc.gender = trainerProgram?.sex ?? "N/A"
         vc.level = trainerProgram?.level ?? "N/A"
         vc.category = trainerProgram?.category ?? "N/A"
         vc.programID = trainerProgram?.id ?? 0
         self.navigationController?.pushViewController(vc, animated: true)
         */
        
        
        //       UniversalMethod.universalManager.pushVC("WorkoutDaysVC", self.navigationController,
        //                                               storyBoard: AppStoryboard.Trainer_Training.rawValue)
        
        if let programID = particularPrograms?.id, !programID.isEmpty {
            let storyBoard = AppStoryboard.Trainer_Training.instance
            let vc = storyBoard.instantiateViewController(withIdentifier: "WorkoutDaysVC") as! WorkoutDaysVC
            vc.programID = 1

            if userRole != ""{
                if (userRole == Role.trainer.rawValue){
                    isDisableAddNewWorkouts = false
                }else if (userRole == Role.client.rawValue){
                    isDisableAddNewWorkouts = true
                }
            }

            vc.isDisableAddNewWorkouts = isDisableAddNewWorkouts
            vc.isNavigateViaSentProgramDetails = isNavigateViaSentProgramDetails
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            Toast.show(message: "Not valid program ID", controller: self)
        }
        
        //w.e.f comment on 28.12.2022
        /*
         let storyBoard = AppStoryboard.Trainer_Training.instance
         let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Training_Section") as! Trainer_Training_Section
         vc.dayID = 1 //this is totally optional
         self.navigationController?.pushViewController(vc, animated: true)
         */
    }
    
    @IBAction func nutrition_Action(_ sender: UIButton) {
        
        let storyBoard = AppStoryboard.Trainer_Nutrition.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Nutrition_Schedule") as! Trainer_Nutrition_Schedule
        vc.selectedRow = selectedRow
        vc.contentType = "1"
        vc.isNavigateViaSentProgramDetails = isNavigateViaSentProgramDetails
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //UniversalMethod.universalManager.pushVC("Trainer_Nutrition_Schedule", self.navigationController, storyBoard: AppStoryboard.Trainer_Nutrition.rawValue)
    }
    
    @IBAction func supplement_Action(_ sender: UIButton) {
        
        /* if isTrainer == "Trainer"{
         UniversalMethod.universalManager.pushVC("Trainer_Add_Supplement", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
         }else{
         UniversalMethod.universalManager.pushVC("Trainer_View_Supplement", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
         }*/
        
        
        /*   /*  trainerProgram = clientExProInfo?.entities?[selectedRow]*/
         let storyBoard = AppStoryboard.Trainer_Tabbar.instance
         let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_View_Supplement") as! Trainer_View_Supplement
         /* vc.clientSupplements = trainerProgram?.supplements?.first.supplementDescription
          vc.clientSupplementName = trainerProgram?.supplements?.first.name
          vc.programsID = trainerProgram?.id ?? 0
          vc.selectedIndex = selectedRow*/
         self.navigationController?.pushViewController(vc, animated: true)*/
        
        let storyBoard = AppStoryboard.Trainer_Nutrition.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Nutrition_Schedule") as! Trainer_Nutrition_Schedule
        vc.headerTitle = "Supplement Week Day"
        vc.contentType = "2"   //type=1 for meal ,2 for suppliment
        vc.isNavigateViaSentProgramDetails = isNavigateViaSentProgramDetails
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Helper's Method
}


extension Trainer_Program_Details: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyTags.isHidden = true
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        if indexPath.item == 0 {
            label.text = particularPrograms?.sex
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        } else if (indexPath.item == 1) {
            label.text = particularPrograms?.levelOfTraining
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        } else {
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


