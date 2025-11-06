
import UIKit
import MGSwipeTableCell

class Trainer_Meal_Paster: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var exercise_Program_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    @IBOutlet weak var pasteButton: GradientButton!

    var client_Goals = ["Monday", "Tuesday", "Wednesday", "Thursday","Friday", "Saturday","Sunday"]
    var source_id = String()
    var program_id = String()
    var destination_id = String()
    var selectedWeekDay = String()
    var isCopyNutritionDay = Bool()
    var selectedIndex = [Int:Bool]()
    var headerTitle = String()
    var daysID = [String]()
    var contentType = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        exercise_Program_Tableview.delegate = self
        exercise_Program_Tableview.dataSource = self
        exercise_Program_Tableview.register(UINib(nibName: "Nutrition_Days_Cell", bundle: nil), forCellReuseIdentifier: "Nutrition_Days_Cell")
        pasteButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interface_Title.text = headerTitle
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func paster(_ sender: UIButton) {
        /* if Constants.selectedMealDay == destination_id{
         UniversalMethod.universalManager.alertMessage("Please choose another day of week", self.navigationController)
         }else{
         copyPasteMeal(parameters:["source_id":source_id,"destination_id":destination_id, "program_id":program_id], isCopyNutritionDay:isCopyNutritionDay )
         }*/
        daysID.removeAll()
        _ = selectedIndex.enumerated().compactMap { index, element in
            if selectedIndex[element.key] == true{
                let newValue = (element.key + 1)
                daysID.append(("\(newValue)"))
            }
        }
        let stringFormattedDaysID = daysID.joined(separator: ",")
        copyPasteMeal(parameters:["source_id":source_id,"destination_id":stringFormattedDaysID, "program_id":program_id, "type":contentType], isCopyNutritionDay:isCopyNutritionDay )
    }
    
    //MARK: Helper's Method
    
}

extension Trainer_Meal_Paster: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return client_Goals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Nutrition_Days_Cell", for: indexPath) as? Nutrition_Days_Cell {
            cell.isSelected_Icon.isHidden = false
            cell.days_Text.text = client_Goals[indexPath.row]

            if selectedIndex[indexPath.row] == true{
                cell.isSelected_Icon.image = #imageLiteral(resourceName: "checkBoxSelected")
            }else{
                cell.isSelected_Icon.image = #imageLiteral(resourceName: "checkBoxUnselected")
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedIndex.removeAll()
        //selectedIndex[indexPath.row] = true
        destination_id = "\(indexPath.row + 1)"
        if Constants.selectedMealDay == destination_id{
            UniversalMethod.universalManager.alertMessage("You should not choose the same day of the week.", self.navigationController)
        }else{
            if selectedIndex.count > 0{
                if selectedIndex.keys.contains(indexPath.row){
                    if selectedIndex[indexPath.row] == true{
                        selectedIndex[indexPath.row] = false
                    }else{
                        selectedIndex[indexPath.row] = true
                    }
                }else{
                    selectedIndex[indexPath.row] = true
                }
            }else{
                selectedIndex[indexPath.row] = true
            }
            exercise_Program_Tableview.reloadData()
        }
    }
}




