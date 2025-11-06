
import UIKit
import MGSwipeTableCell


class Client_Goals: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var goals_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var next_Height: NSLayoutConstraint!
    @IBOutlet weak var skip_Height: NSLayoutConstraint!
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    var isComing_From_Tab = false
    var client_Goals = [String:Any]()
    var goalsDict = [String:Any]()
    var goalsArray = [String]()
    let defaults = UserDefaults.standard
    
    var searchedClientUserID = String()
    
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
        
        if isComing_From_Tab == true{
            next_Height.constant = 0.0
            skip_Height.constant = 0.0
            nextButton.isHidden = true
            skipButton.isHidden = true
        }
        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(isAddGoals(_:)), name: NSNotification.Name(rawValue: Constants.addGoals), object: nil)
        
        if searchedClientUserID == ""{
            addIcon.isHidden = false
            addButton.isUserInteractionEnabled = true
        }else if searchedClientUserID != ""{
            addIcon.isHidden = true
            addButton.isUserInteractionEnabled = false
        }
        
        if !AppHintsManager.shared.hasShownGoalSwipeHint {
            showSwipeHintOnce()
        }
    }
    
    @objc func isAddGoals(_ notify:NSNotification){
        let isAddGoals = notify.object as? Bool
        if isAddGoals == true{
            
            goals_Tableview.reloadData()
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func next(_ sender: UIButton) {
        let story = UIStoryboard(name: AppStoryboard.Client_Tabbar.rawValue, bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: Client_Tabbar.Client_Bar.rawValue) as! MainTabbar_Controller
        vc.selectedIndex = 4
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func skip(_ sender: UIButton) {
        let story = UIStoryboard(name: AppStoryboard.Client_Tabbar.rawValue, bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: Client_Tabbar.Client_Bar.rawValue) as! MainTabbar_Controller
        vc.selectedIndex = 4
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func add_Goals(_ sender: UIButton) {
        let ShareVC = UIStoryboard(name: AppStoryboard.Onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: Onboarding.Add_Goals.rawValue) as! Add_Goals
        ShareVC.status_Title = "My Goal"
        ShareVC.top_Title = "Add Goal"
        Constants.isEditGoal = "0"
        self.addChild(ShareVC)
        ShareVC.view.frame = self.view.frame
        self.view.addSubview(ShareVC.view)
        ShareVC.didMove(toParent: self)
//        
//         navigationController?.pushViewController(ShareVC, animated: true)
        
//        MediaTypePicker.shared.present(from: self, sourceView: view) { [weak self] media in
//            switch media {
//            case .image(let image):
//                break
//                
//            case .video(let url):
//                break
//                
//            case .none:
//                break
//            }
//        }
    }
    
    
    //MARK: Helper's Method
    
    private func showSwipeHintOnce() {
        let indexPath = IndexPath(row: 0, section: 0)

        // 1. Ensure table is not empty
        guard goals_Tableview.numberOfSections > 0,
              goals_Tableview.numberOfRows(inSection: 0) > 0 else {
            return
        }

        // 3. Wait for layout to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }

            // 4. Get the actual cell
            guard let cell = self.goals_Tableview.cellForRow(at: indexPath) as? Goal_Cell else {
                return
            }

            // 5. Show swipe
            cell.showSwipe(.rightToLeft, animated: true)

            // 6. Mark hint as shown only *after* successful swipe
            AppHintsManager.shared.hasShownGoalSwipeHint = true

            // 7. Hide after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                cell.hideSwipe(animated: true)
            }
        }
    }
}

extension Client_Goals: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = userInfo?.goal?.count else{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            nextButton.isEnabled = false
            skipButton.isEnabled = true
            skipButton.alpha = 1.0
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            nextButton.isEnabled = false
            skipButton.isEnabled = true
            skipButton.alpha = 1.0
        }else{
            empty_View.isHidden = true
            goals_Tableview.isHidden = false
            nextButton.isEnabled = true
            skipButton.isEnabled = false
            skipButton.alpha = 0.5
        }
        return count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Goal_Cell", for: indexPath) as? Goal_Cell {

            if searchedClientUserID == ""{
                let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.removeGoal(at: indexPath.row)
                    return true
                }

                let editButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "edit_icon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.editGoal(at: indexPath.row)
                    return true
                }

                cell.rightButtons = [deleteButton, editButton]
                cell.configure()
            }

            particularGoalInfo = userInfo?.goal?[indexPath.row]
            cell.goals_Text.text = particularGoalInfo?.goalDescription
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
