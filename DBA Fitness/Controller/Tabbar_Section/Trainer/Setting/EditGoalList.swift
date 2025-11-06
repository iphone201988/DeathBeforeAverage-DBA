
import UIKit
import MGSwipeTableCell


class EditGoalList: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var goals_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!

    var isComing_From_Tab = false
    var client_Goals = [String:Any]()
    var goalsDict = [String:Any]()
    var goalsArray = [String]()
    let defaults = UserDefaults.standard
    
    private var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    private var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        goals_Tableview.delegate = self
        goals_Tableview.dataSource = self
        goals_Tableview.register(UINib(nibName: "Goal_Cell", bundle: nil), forCellReuseIdentifier: "Goal_Cell")
        goals_Tableview.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(isAddGoals(_:)), name: NSNotification.Name(rawValue: Constants.addGoals), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @objc func isAddGoals(_ notify:NSNotification){
        let isAddGoals = notify.object as? Bool
        if isAddGoals == true{
            
            goals_Tableview.reloadData()
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func add_Goals(_ sender: UIButton) {
        let ShareVC = UIStoryboard(name: AppStoryboard.Onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: Onboarding.Add_Goals.rawValue) as! Add_Goals
        ShareVC.status_Title = "Goal"
        ShareVC.top_Title = "Add Goal"
        Constants.isEditGoal = "0"
        self.addChild(ShareVC)
        ShareVC.view.frame = self.view.frame
        self.view.addSubview(ShareVC.view)
        ShareVC.didMove(toParent: self)
    }
    
    
    //MARK: Helper's Method
}

extension EditGoalList: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = userInfo?.goal?.count else{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
        }else{
            empty_View.isHidden = true
            goals_Tableview.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Goal_Cell", for: indexPath) as? Goal_Cell {

            let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                self?.removeGoal(at: indexPath.row)
                return true
            }

            let editButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "edit_icon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                self?.editGoal(at: indexPath.row)
                return true
            }

            cell.rightButtons = [deleteButton, editButton]

            particularGoalInfo = userInfo?.goal?[indexPath.row]
            cell.goals_Text.text = particularGoalInfo?.goalDescription

            cell.configure()

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        particularGoalInfo = userInfo?.goal?[indexPath.row]
        let ShareVC = UIStoryboard(name: AppStoryboard.Onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: Onboarding.Add_Goals.rawValue) as! Add_Goals
        ShareVC.status_Title = "Goal Description"
        ShareVC.top_Title = "Goal"
        Constants.isEditGoal = "2"
        self.addChild(ShareVC)
        ShareVC.view.frame = self.view.frame
        self.view.addSubview(ShareVC.view)
        ShareVC.didMove(toParent: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    private func removeGoal(at index: Int) {
        
        particularGoalInfo = userInfo?.goal?[index]
        addGoal(parameters:["goal_id":particularGoalInfo?.id ?? "0"] )
    }
    
    private func editGoal(at index: Int) {
        
        particularGoalInfo = userInfo?.goal?[index]
        let ShareVC = UIStoryboard(name: AppStoryboard.Onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: Onboarding.Add_Goals.rawValue) as! Add_Goals
        ShareVC.status_Title = "Now Editing"
        ShareVC.top_Title = "Edit Goal"
        Constants.isEditGoal = "1"
        self.addChild(ShareVC)
        ShareVC.view.frame = self.view.frame
        self.view.addSubview(ShareVC.view)
        ShareVC.didMove(toParent: self)
    }
}


