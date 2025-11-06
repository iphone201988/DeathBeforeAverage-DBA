
import UIKit

class WorkoutDaysVC: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var addBtn: UIButton!

    var daysList = ["Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var programID = Int()
    var isDisableAddNewWorkouts = false
    var isNavigateViaSentProgramDetails = false
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "Nutrition_Days_Cell", bundle: nil), forCellReuseIdentifier: "Nutrition_Days_Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isDisableAddNewWorkouts == true {
            addIcon.isHidden = true
            addBtn.isHidden = true
        } else {
            addIcon.isHidden = false
            addBtn.isHidden = false
        }
        
        if isNavigateViaSentProgramDetails {
            addIcon.isHidden = true
            addBtn.isHidden = true
        }
    }
    
    //MARK : IB's Action
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_workouts(_ sender: UIButton) {
        let storyBoard = AppStoryboard.Trainer_Training.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Add_Training") as! Trainer_Add_Training
        vc.programID = programID
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        //UniversalMethod.universalManager.pushVC("Trainer_Add_Training", self.navigationController, storyBoard: AppStoryboard.Trainer_Training.rawValue)
    }
    
    //MARK: Helper's Method
    
}

extension WorkoutDaysVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Nutrition_Days_Cell", for: indexPath) as? Nutrition_Days_Cell {

            cell.days_Text.text = daysList[indexPath.row]

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = AppStoryboard.Trainer_Training.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Training_Section") as! Trainer_Training_Section
        vc.dayID = indexPath.row + 1
        vc.isNavigateViaSentProgramDetails = isNavigateViaSentProgramDetails
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
