
import UIKit
import MGSwipeTableCell

class Trainer_Nutrition_Schedule: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var exercise_Program_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    var trainerSpecs = ["Male","Expert","Strongman"]
    var client_Goals = ["Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var selectedRow = Int()
    var userRole = ""
    var headerTitle = String()
    var contentType = String()
    var isNavigateViaSentProgramDetails = false
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        exercise_Program_Tableview.delegate = self
        exercise_Program_Tableview.dataSource = self
        exercise_Program_Tableview.register(UINib(nibName: "Nutrition_Days_Cell", bundle: nil), forCellReuseIdentifier: "Nutrition_Days_Cell")
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "Role") as? String ?? ""
        
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
            }
        }
        addIcon.isHidden = true
        addButton.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if headerTitle != ""{
            interface_Title.text = headerTitle
        }
        
        if isNavigateViaSentProgramDetails { }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        
        if isTrainer == "Trainer"{
        }else{
        }
        
    }
    
    //MARK: Helper's Method
    
}

extension Trainer_Nutrition_Schedule: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = client_Goals.count as? Int else{
            empty_View.isHidden = false
            exercise_Program_Tableview.isHidden = true
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            exercise_Program_Tableview.isHidden = true
        }else{
            empty_View.isHidden = true
            exercise_Program_Tableview.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Nutrition_Days_Cell", for: indexPath) as? Nutrition_Days_Cell {

            cell.days_Text.text = client_Goals[indexPath.row]

            if isTrainer == "Trainer"{
                /* let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                 self?.removeProgram(at: indexPath.row)
                 return true
                 }*/

                let copyButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "copyIcon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.copyProgram(at: indexPath.row)
                    return true
                }
                // cell.rightButtons = [deleteButton,copyButton]
                cell.rightButtons = [copyButton]
                cell.configure()
            }else{

            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = AppStoryboard.Trainer_Nutrition.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Meal_View") as! Trainer_Meal_View
        Constants.selectedMealDay = "\(indexPath.row + 1)"
        vc.headerTitle = client_Goals[indexPath.row]
        vc.contentType = contentType
        vc.isNavigateViaSentProgramDetails = isNavigateViaSentProgramDetails
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //UniversalMethod.universalManager.pushVC("Trainer_Meal_View", self.navigationController, storyBoard: AppStoryboard.Trainer_Nutrition.rawValue)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    private func removeProgram(at index: Int) {
        
    }
    private func copyProgram(at index: Int) {
        
        let vc = AppStoryboard.Trainer_Nutrition.instance.instantiateViewController(withIdentifier: "Trainer_Meal_Paster") as! Trainer_Meal_Paster
        vc.source_id = "\(index + 1)"
        vc.program_id = particularPrograms?.id ?? ""
        Constants.selectedMealDay = "\(index + 1)"
        vc.isCopyNutritionDay = true
        vc.contentType = self.contentType
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //UniversalMethod.universalManager.pushVC("Trainer_Meal_Paster", self.navigationController, storyBoard: AppStoryboard.Trainer_Nutrition.rawValue)
    }
}



