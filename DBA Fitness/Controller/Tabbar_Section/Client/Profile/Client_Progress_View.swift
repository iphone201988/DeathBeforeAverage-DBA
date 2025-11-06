
import UIKit
import MGSwipeTableCell

class Client_Progress_View: UIViewController {
    
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
    var userRole = ""
    var pageNo = 1
    
    var client_Goals = ["Meal 1","Meal 2", "Meal 3", "Meal 4", "Meal 5", "Meal 6", "Meal 7"]
    
    var dateFormatter = DateFormatter()
    
    var searchedClientUserID = String()
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        exercise_Program_Tableview.delegate = self
        exercise_Program_Tableview.dataSource = self
        exercise_Program_Tableview.register(UINib(nibName: "Client_Progress", bundle: nil), forCellReuseIdentifier: "Client_Progress")
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                addIcon.image = #imageLiteral(resourceName: "plus")
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                addIcon.image = #imageLiteral(resourceName: "plus")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProgress(parameters:[:] )
        
        if searchedClientUserID == ""{
            addIcon.isHidden = false
            addButton.isUserInteractionEnabled = true
        }else if searchedClientUserID != ""{
            addIcon.isHidden = true
            addButton.isUserInteractionEnabled = false
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        let storyBoard = AppStoryboard.Client_Progress.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Client_Edit_Progress") as! Client_Edit_Progress
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Helper's Method
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if  let remainingPagesCount = DataSaver.dataSaverManager.fetchData(key: "remainingPages") as? Int{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if scrollView == exercise_Program_Tableview{
                if (scrollView.contentOffset.y == /*0*/ maximumOffset) {
                    if remainingPagesCount < 1{
                        // UniversalMethod.universalManager.alertMessage("No Product left", self.navigationController)
                    }else{
                        pageNo = pageNo + 1
                        getProgress(parameters:[:] )
                    }
                }
            }
        }
    }
}

extension Client_Progress_View: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = clientProgressInfo?.data?.count else{
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Client_Progress", for: indexPath) as? Client_Progress {

            particularClientProgress = clientProgressInfo?.data?[indexPath.row]
            cell.days_Text.text = "Progress - \(particularClientProgress?.datumDescription ?? "N/A")"

//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let createDate = dateFormatter.date(from: particularClientProgress?.createdon ?? "") ?? Date()
//            dateFormatter.dateFormat = "EEE, MMM d"
//            cell.time_Text.text = dateFormatter.string(from: createDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Set the input format as UTC

            // Convert the date from UTC to a Date object
            let createDate = dateFormatter.date(from: particularClientProgress?.createdon ?? "") ?? Date()

            // Convert and display it in the current time zone
            dateFormatter.dateFormat = "EEE, MMM d"
            dateFormatter.timeZone = TimeZone.current // Set the output format to the user's local time zone

            cell.time_Text.text = dateFormatter.string(from: createDate)


            if isTrainer == "Trainer"{
                let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.removeProgram(at: indexPath.row)
                    return true
                }

                let copyButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "edit_icon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.copyProgram(at: indexPath.row)
                    return true
                }

                //cell.rightButtons = [deleteButton,copyButton]
                //cell.configure()
            }else{

                let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.removeProgram(at: indexPath.row)
                    return true
                }

                let copyButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "edit_icon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.copyProgram(at: indexPath.row)
                    return true
                }

                cell.rightButtons = [deleteButton,copyButton]
                cell.configure()


            }

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        particularClientProgress = clientProgressInfo?.data?[indexPath.row]
        //UniversalMethod.universalManager.pushVC("Progress_Detail_View", self.navigationController, storyBoard: AppStoryboard.Client_Progress.rawValue)
        
        let vc = AppStoryboard.Client_Progress.instance.instantiateViewController(withIdentifier: "Progress_Detail_View") as! Progress_Detail_View
        vc.searchedClientUserID = self.searchedClientUserID
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    private func removeProgram(at index: Int) {
        particularClientProgress = clientProgressInfo?.data?[index]
        deleteProgress(parameters:["progress_id" :particularClientProgress?.id ?? "0"] )
    }
    
    private func copyProgram(at index: Int) {
        /*  let storyBoard = AppStoryboard.Client_Progress.instance
         let vc = storyBoard.instantiateViewController(withIdentifier: "Client_Edit_Progress") as! Client_Edit_Progress
         vc.desc = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
         self.navigationController?.pushViewController(vc, animated: true)*/
        particularClientProgress = clientProgressInfo?.data?[index]
        //UniversalMethod.universalManager.pushVC("Progress_Detail_View", self.navigationController, storyBoard: AppStoryboard.Client_Progress.rawValue)
        let storyBoard = AppStoryboard.Client_Progress.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditProgress") as! EditProgress
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



