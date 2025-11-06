
import UIKit
import MGSwipeTableCell

class Searched_Trainer_Achievement: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var achievements_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    var achievements: [M_UserAchievements]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        achievements_Tableview.delegate = self
        achievements_Tableview.dataSource = self
        achievements_Tableview.register(UINib(nibName: "My_Achievement_Cell", bundle: nil), forCellReuseIdentifier: "My_Achievement_Cell")
        achievements_Tableview.reloadData()
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper's Method
}

extension Searched_Trainer_Achievement: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if achievements?.count ?? 0 > 0{
            guard let count = achievements?.count else{
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
        }else{
            
        
        guard let count = userInfo?.achievement?.count else{
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "My_Achievement_Cell", for: indexPath) as? My_Achievement_Cell {
            var acheivementDict : M_UserAchievements?
            if achievements?.count ?? 0 > 0{
                 acheivementDict = achievements?[indexPath.row]
            }else{
                 acheivementDict = userInfo?.achievement?[indexPath.row]
            }
//            let acheivementDict = userInfo?.achievement?[indexPath.row]
            let certificateCount = acheivementDict?.image?.count

            /* if certificateCount ?? 0 > 0{
             cell.numberOf_Certificate.text = "\(certificateCount ?? 0) certificate"
             }else{
             cell.numberOf_Certificate.text = "N/A certificate"
             }*/

            if certificateCount ?? 0 > 0{
                if certificateCount ?? 0 < 2{
                    cell.numberOf_Certificate.text = "\(certificateCount ?? 0) certificate"
                }else{
                    cell.numberOf_Certificate.text = "\(certificateCount ?? 0) certificates"
                }
            }else{
                cell.numberOf_Certificate.text = "0 certificate"
            }

            cell.achievement_Year.text = acheivementDict?.year
            cell.competition_Name.text = acheivementDict?.event
            //cell.juniors_Position.text = acheivementDict?.juniorAbsolute
            cell.aboutAchievement.text = acheivementDict?.juniorAbsolute
            cell.weight_Position.text = acheivementDict?.menUpTo90_Kg

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if achievements?.count ?? 0 > 0{
            particularAcheivementInfo = achievements?[indexPath.row]
        }else{
            particularAcheivementInfo = userInfo?.achievement?[indexPath.row]
        }
//        particularAcheivementInfo = userInfo?.achievement?[indexPath.row]
        Constants.isSearchedTrainerAchievement = "1"
        UniversalMethod.universalManager.pushVC("Trainer_Edit_Achievement", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }

}

