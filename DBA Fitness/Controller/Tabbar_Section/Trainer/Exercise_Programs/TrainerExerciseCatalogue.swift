
import UIKit
import MGSwipeTableCell

class TrainerExerciseCatalogue: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var achievements_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!

    private var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    private var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    var dateFormatter = DateFormatter()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(catalogueInfo(_:)), name: NSNotification.Name(rawValue: Constants.getCataglogueDetails), object: nil)
        callGetExerciseCatalogue(parameters:[:] )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Achievements(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Create An Exercise Category", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Category Name"
        }
        let saveAction = UIAlertAction(title: "Create", style: UIAlertAction.Style.default, handler: { alert -> Void in
            
            
            let catalogue = alertController.textFields?.first?.text?.trimmed()
            
            if catalogue != ""{
                self.callCreateExerciseCatalogue(parameters:["title":alertController.textFields?[0].text ?? ""] )
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
    
    //MARK: Helper's Method
    @objc func catalogueInfo(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            achievements_Tableview.delegate = self
            achievements_Tableview.dataSource = self
            achievements_Tableview.register(UINib(nibName: "Client_Progress", bundle: nil), forCellReuseIdentifier: "Client_Progress")
            achievements_Tableview.reloadData()
        }else{
            achievements_Tableview.reloadData()
        }
    }
}

extension TrainerExerciseCatalogue: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = exerciseCatalogueInfos?.data?.count else{
            empty_View.isHidden = false
            achievements_Tableview.isHidden = true
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            achievements_Tableview.isHidden = true
        }else{
            empty_View.isHidden = true
            achievements_Tableview.isHidden = false
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
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let createDate = dateFormatter.date(from: particularCatalogueInfo?.createdon ?? "") ?? Date()
            dateFormatter.dateFormat = "EEE, MMM d"
            cell.time_Text.text = dateFormatter.string(from: createDate)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    private func removeGoal(at index: Int) {
        
    }
    
    private func editGoal(at index: Int) {
        
        Constants.selectedAchievementIndex = index
        particularAcheivementInfo = userInfo?.achievement?[index]
        Constants.isSearchedTrainerAchievement = "0"
        UniversalMethod.universalManager.pushVC("Trainer_Edit_Achievement", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
}
