
import UIKit
import MGSwipeTableCell

class Trainer_Meal_View: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var exercise_Program_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    @IBOutlet weak var emptyViewHeader: UILabel!
    @IBOutlet weak var emptyViewSubHeader: UILabel!
    
    var trainerSpecs = ["Male","Expert","Strongman"]
    var client_Goals = ["Meal 1","Meal 2", "Meal 3", "Meal 4", "Meal 5", "Meal 6", "Meal 7"]
    var selectedRow = Int()
    var selectedDay = Int()
    // var mealDict = [M_CPEINutrition]()
    var headerTitle = String()
    var userRole = ""
    
    var contentType = String()
    var isNavigateViaSentProgramDetails = false
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(programsInfo(_:)), name: NSNotification.Name(rawValue: Constants.getProgramsDetails), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interface_Title.text = headerTitle
        
        if contentType == "1"{
            emptyViewHeader.text = "No Nutrition"
            emptyViewSubHeader.text = "Looks like you haven't added any nutrition yet."
        }else{
            emptyViewHeader.text = "No Supplement"
            emptyViewSubHeader.text = "Looks like you haven't added any supplement yet."
        }
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        
        
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                addIcon.image = #imageLiteral(resourceName: "plus")
                addIcon.isHidden = false
                addButton.isUserInteractionEnabled = true
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                addIcon.image = #imageLiteral(resourceName: "QR_Scan")
                addIcon.isHidden = true
                addButton.isUserInteractionEnabled = false
            }
        }
        Constants.isAddMeal = "0"
        programMeal(parameters:["day_id":Constants.selectedMealDay, "program_id":particularPrograms?.id ?? "0", "type": contentType] )
        
        if isNavigateViaSentProgramDetails {
            addIcon.image = #imageLiteral(resourceName: "QR_Scan")
            addIcon.isHidden = true
            addButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func programsInfo(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            self.exercise_Program_Tableview.delegate = self
            self.exercise_Program_Tableview.dataSource = self
            self.exercise_Program_Tableview.register(UINib(nibName: "Nutrition_Days_Cell", bundle: nil), forCellReuseIdentifier: "Nutrition_Days_Cell")
            self.exercise_Program_Tableview.reloadData()
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        
        let storyBoard = AppStoryboard.Trainer_Nutrition.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Add_Meal") as! Trainer_Add_Meal
        vc.selectedDay = selectedDay
        vc.contentType = contentType
        //vc.headerTitle = client_Goals[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //UniversalMethod.universalManager.pushVC("Trainer_Add_Meal", self.navigationController, storyBoard: AppStoryboard.Trainer_Nutrition.rawValue)
    }
    
    //MARK: Helper's Method
    
}

extension Trainer_Meal_View: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let count  = programMealInfo?.data?.count else{
            empty_View.isHidden = false
            exercise_Program_Tableview.isHidden = true
            return 0
        }
        
        if count > 0{
            empty_View.isHidden = true
            exercise_Program_Tableview.isHidden = false
        }else{
            empty_View.isHidden = false
            exercise_Program_Tableview.isHidden = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Nutrition_Days_Cell", for: indexPath) as? Nutrition_Days_Cell {

            //cell.days_Text.text = "Meal \(indexPath.row + 1)"//client_Goals[indexPath.row]

            // let dict = mealDict[indexPath.row]
            // cell.days_Text.text = "Meal \(indexPath.row + 1) - \(dict.name ?? "")"

            let mealDict = programMealInfo?.data?[indexPath.row]


            if contentType == "1"{
                cell.days_Text.text = "Meal \(indexPath.row + 1) - \(mealDict?.mealTitle ?? "")"
            }else{
                cell.days_Text.text = "Supplement \(indexPath.row + 1) - \(mealDict?.mealTitle ?? "")"
            }

            if isTrainer == "Trainer"{
                let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 0.886130137, green: 0, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.removeProgram(at: indexPath.row)
                    return true
                }

                let copyButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "copyIcon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.copyProgram(at: indexPath.row)
                    return true
                }

                let editButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "edit_icon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.5125749144, blue: 0, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.editProgram(at: indexPath.row)
                    return true
                }

                cell.rightButtons = [deleteButton,copyButton,editButton]
                cell.configure()



            }else{

            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        editProgram(at: indexPath.row)
        
        //UniversalMethod.universalManager.pushVC("Trainer_Meal_Details", self.navigationController, storyBoard: AppStoryboard.Trainer_Nutrition.rawValue)
    }
    private func removeProgram(at index: Int) {
        
        particularProgramMeal = programMealInfo?.data?[index]
        //deleteMeal(parameters:["meal_id":particularProgramMeal?.id ?? "0"] )
        
        deleteMeal(parameters:["meal_id":particularProgramMeal?.id ?? "0", "day_id":Constants.selectedMealDay, "program_id":particularPrograms?.id ?? "0", "type": contentType] )
    }
    private func copyProgram(at index: Int) {
        let vc = AppStoryboard.Trainer_Nutrition.instance.instantiateViewController(withIdentifier: "Trainer_Meal_Paster") as! Trainer_Meal_Paster
        vc.source_id = programMealInfo?.data?[index].id ?? ""
        vc.program_id = particularPrograms?.id ?? ""
        vc.headerTitle = headerTitle
        vc.isCopyNutritionDay = false
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //UniversalMethod.universalManager.pushVC("Trainer_Meal_Paster", self.navigationController, storyBoard: AppStoryboard.Trainer_Nutrition.rawValue)
    }
    private func editProgram(at index: Int){
        let storyBoard = AppStoryboard.Trainer_Nutrition.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Meal_Details") as! Trainer_Meal_Details
        vc.selectedRow = index
        vc.contentType = contentType
        vc.isNavigateViaSentProgramDetails = isNavigateViaSentProgramDetails
        particularProgramMeal = programMealInfo?.data?[index]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



