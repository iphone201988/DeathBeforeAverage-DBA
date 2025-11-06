
import UIKit
import MGSwipeTableCell

class Trainer_Achievement: UIViewController {
    @IBOutlet weak var certificateSegmentedController: UISegmentedControl!
    //MARK : Outlets and Variables
    
    @IBOutlet weak var achievements_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var certificate_CollectionView: UICollectionView!
    @IBOutlet weak var segmentedControllerMyAchievement: UISegmentedControl!
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    //  var client_Goals = [String]()
    
    private var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    private var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    var allCertificates: [String] = []

    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gatherAllCertificates()
//        certificateSegmentedController.selectedSegmentIndex =
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateDeleteAchievement(_:)),
                                               name: NSNotification.Name(rawValue: Constants.updateDeleteAchievement),
                                               object: nil)
        
        certificate_CollectionView.delegate = self
        certificate_CollectionView.dataSource = self
        certificate_CollectionView.register(UINib(nibName: "Gallery_Cell", bundle: nil), forCellWithReuseIdentifier: "Gallery_Cell")
        
        achievements_Tableview.delegate = self
        achievements_Tableview.dataSource = self
        achievements_Tableview.register(UINib(nibName: "My_Achievement_Cell", bundle: nil), forCellReuseIdentifier: "My_Achievement_Cell")
        
        achievements_Tableview.reloadData()
        
        segmentedControllerMyAchievement.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        
 

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gatherAllCertificates()
//        achievements_Tableview.delegate = self
//        achievements_Tableview.dataSource = self
//        achievements_Tableview.register(UINib(nibName: "My_Achievement_Cell", bundle: nil), forCellReuseIdentifier: "My_Achievement_Cell")
//        achievements_Tableview.reloadData()
    }
    
    
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Achievements(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Trainer_Add_Achievement", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
    
    @IBAction func didTappedSegmentedController(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
                // Show Achievements, Hide Certificates
                achievements_Tableview.isHidden = false
                certificate_CollectionView.isHidden = true
                achievements_Tableview.reloadData()
            
            } else {
                // Show Certificates, Hide Achievements
                achievements_Tableview.isHidden = true
                certificate_CollectionView.isHidden = false
                gatherAllCertificates()
                certificate_CollectionView.reloadData()
            }//
//
    }
    func gatherAllCertificates() {
            allCertificates = userInfo?.achievement?.compactMap { $0.image }.flatMap { $0 } ?? []
            certificate_CollectionView.reloadData()
        }

    //MARK: Helper's Method
    @objc func updateDeleteAchievement(_ notify:NSNotification){
        achievements_Tableview.reloadData()
    }
}

extension Trainer_Achievement: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "My_Achievement_Cell", for: indexPath) as? My_Achievement_Cell {

            particularAcheivementInfo = userInfo?.achievement?[indexPath.row]

            let editButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "edit_icon"), backgroundColor: #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                self?.editGoal(at: indexPath.row)
                return true
            }

            let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                self?.removeAchievement(at: indexPath.row)
                return true
            }

            cell.rightButtons = [deleteButton, editButton]
            cell.configure()

            let certificateCount = particularAcheivementInfo?.image?.count

            if certificateCount ?? 0 > 0{
                if certificateCount ?? 0 < 2{
                    cell.numberOf_Certificate.text = "\(certificateCount ?? 0) certificate"
                }else{
                    cell.numberOf_Certificate.text = "\(certificateCount ?? 0) certificates"
                }
            }else{
                cell.numberOf_Certificate.text = "0 certificate"
            }
            cell.achievement_Year.text = particularAcheivementInfo?.year
            cell.competition_Name.text = particularAcheivementInfo?.event
            //cell.juniors_Position.text = particularAcheivementInfo?.juniorAbsolute
            cell.aboutAchievement.text = particularAcheivementInfo?.juniorAbsolute
            cell.weight_Position.text = particularAcheivementInfo?.menUpTo90_Kg
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        particularAcheivementInfo = userInfo?.achievement?[indexPath.row]
        Constants.isSearchedTrainerAchievement = "1"
        UniversalMethod.universalManager.pushVC("Trainer_Edit_Achievement", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    private func removeAchievement(at index: Int) {
        let particularAcheivementInfo = userInfo?.achievement?[index]
        self.addAchievement(year: nil,
                            event: nil,
                            image: nil,
                            junior_absolute: nil,
                            men_up_to_90_kg: nil,
                            apiUrl:ApiURLs.add_achievement,
                            achievement_id:particularAcheivementInfo?.id ?? "0",
                            type: "1")
    }
    
    
    
    
    private func editGoal(at index: Int) {
        
        Constants.selectedAchievementIndex = index
        particularAcheivementInfo = userInfo?.achievement?[index]
        particularCertificateInfoAchievement = userInfo?.myGallery?[index]
        Constants.isSearchedTrainerAchievement = "0"
        UniversalMethod.universalManager.pushVC("Trainer_Edit_Achievement", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
    
}



extension Trainer_Achievement: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCertificates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gallery_Cell", for: indexPath) as? Gallery_Cell else {
            return UICollectionViewCell()
        }
        let imageUrl = allCertificates[indexPath.row]
        cell.configureCellForCertificate(imageUrl) // Ensure Gallery_Cell has a method to load an image
        cell.photos_View.backgroundColor = .clear
           return cell
//        if let imageUrl = particularCertificateInfoAchievement?.image?[indexPath.row]{
////
////            cell.configureCell(imageUrl)
//        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell selection if needed
    }
    
    // Adjust size based on layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (certificate_CollectionView.frame.size.width/2) - 10, height: certificate_CollectionView.frame.size.width/2) // Adjust the size as per your design
    }
}


