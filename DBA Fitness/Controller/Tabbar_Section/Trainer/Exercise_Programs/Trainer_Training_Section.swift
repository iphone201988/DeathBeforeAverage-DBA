
import UIKit
import MGSwipeTableCell
import AVKit
import SDWebImage

class Trainer_Training_Section: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var exercise_Program_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    
    @IBOutlet weak var addIcon: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    var dayID = Int()
    var selectedRow = Int()
    var currentRow = Int()
    var trainerSpecs = [String]()
    var tags:String?
    //var trainingDict: M_CPEITraining?
    var gender = ""
    var level = ""
    var category = ""
    var programID = Int()
    var userRole = ""
    var pageNo = 1
    let playerViewController = AVPlayerViewController()
    var isNavigateViaSentProgramDetails = false
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    //  var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if tags != ""{
            trainerSpecs = tags?.components(separatedBy: ",") ?? [""]
        }
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        
        
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                addIcon.isHidden = true
                addButton.isUserInteractionEnabled = false
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                addIcon.isHidden = true
                addButton.isUserInteractionEnabled = false
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(programsInfo(_:)), name: NSNotification.Name(rawValue: Constants.getProgramsDetails), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProgramTraining(parameters:[:] )
        
        if isNavigateViaSentProgramDetails {
            addIcon.isHidden = true
            addButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func programsInfo(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            exercise_Program_Tableview.reloadData()
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        let storyBoard = AppStoryboard.Trainer_Training.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Add_Training") as! Trainer_Add_Training
        vc.programID = programID
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
        //UniversalMethod.universalManager.pushVC("Trainer_Add_Training", self.navigationController, storyBoard: AppStoryboard.Trainer_Training.rawValue)
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
                        getProgramTraining(parameters:[:] )
                    }
                }
            }
        }
    }
    
}

extension Trainer_Training_Section: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = programTrainingInfo?.data?.count else{
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Trainer_Trainings_Cell", for: indexPath) as? Trainer_Trainings_Cell {

            particularProgramTraining = programTrainingInfo?.data?[indexPath.row]

            if userRole == Role.trainer.rawValue{
                let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                    self?.removeProgram(at: indexPath.row)
                    return true
                }
                cell.rightButtons = [deleteButton]
                cell.configure()
            }

            cell.emptyTag.isHidden = true
            cell.training_Name.text = particularProgramTraining?.trainingName
            cell.training_Name.numberOfLines = 4
            currentRow = indexPath.row
            cell.training_Collection.delegate = self
            cell.training_Collection.dataSource = self
            cell.training_Collection.register(UINib(nibName: "Trainer_Specs_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Specs_Cell")
            cell.training_Collection.reloadData()

            if particularProgramTraining?.trainingVideo != ""{
                cell.playIcon.image = #imageLiteral(resourceName: "playButton")
            }else{
                cell.playIcon.image = #imageLiteral(resourceName: "noVideo")
            }

            if let photo = particularProgramTraining?.training_thumbnil{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    cell.training_Thumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.training_Thumbnail.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "waitPostImage"), options: .highPriority)
                }else{
                    cell.training_Thumbnail.image = #imageLiteral(resourceName: "workoutSampleImage")
                }
            }

            cell.playVideo.tag = indexPath.row
            cell.playVideo.addTarget(self, action: #selector(playTrainingVideo(_sender:)), for: .touchUpInside)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        particularProgramTraining = programTrainingInfo?.data?[indexPath.row]
//        UniversalMethod.universalManager.pushVC("Trainer_Training_View", self.navigationController, storyBoard: AppStoryboard.Trainer_Training.rawValue)
        
        let storyBoard = AppStoryboard.Trainer_Training.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Training_View") as! Trainer_Training_View
        vc.isNavigateViaSentProgramDetails = isNavigateViaSentProgramDetails
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    private func removeProgram(at index: Int) {
        
        particularProgramTraining = programTrainingInfo?.data?[index]
        deleteProgramTraining(parameters:["day_id": dayID, "training_id" :particularProgramTraining?.id ?? "0"] )
        // training_day
    }
    
    @objc func playTrainingVideo(_sender: UIButton){
        particularProgramTraining = programTrainingInfo?.data?[_sender.tag]
        if particularProgramTraining?.trainingVideo != ""{
            let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(particularProgramTraining?.trainingVideo ?? "")"
            if let videoURL = URL(string: completePicUrl) {
                let player = AVPlayer(url: videoURL)
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    self.playerViewController.player?.play()
                }
            }

        }
    }
}

extension Trainer_Training_Section: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        //        if indexPath.item == 0{
        //            label.text = particularPrograms?.sex
        //            let widthOfLabel = label.text?.widthOfString(usingFont: UIFont(name: "Nunito-SemiBold", size: 10) ?? .systemFont(ofSize: 10)) ?? label.frame.width
        //            return CGSize(width: widthOfLabel + 20, height: 40.0)
        //        }else if (indexPath.item == 1){
        //            label.text = particularPrograms?.levelOfTraining
        //            let widthOfLabel = label.text?.widthOfString(usingFont: UIFont(name: "Nunito-SemiBold", size: 10) ?? .systemFont(ofSize: 10)) ?? label.frame.width
        //            return CGSize(width: widthOfLabel + 20, height: 40.0)
        //        }else{
        //            label.text = particularPrograms?.category
        //            let widthOfLabel = label.text?.widthOfString(usingFont: UIFont(name: "Nunito-SemiBold", size: 10) ?? .systemFont(ofSize: 10)) ?? label.frame.width
        //            return CGSize(width: widthOfLabel + 20, height: 40.0)
        //        }

        if indexPath.item == 0 {
            label.text = particularPrograms?.sex
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        } else if (indexPath.item == 1) {
            label.text = particularPrograms?.levelOfTraining
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        } else {
            label.text = particularPrograms?.category
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        }


    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trainer_Specs_Cell", for: indexPath) as? Trainer_Specs_Cell {

            if indexPath.item == 0{
                cell.specs_View.backgroundColor = UIColor(named: "Gender_View")
                cell.specs_Title.text = particularPrograms?.sex
            }else if indexPath.item == 1{
                cell.specs_View.backgroundColor = UIColor(named: "Training_Type")
                cell.specs_Title.text = particularPrograms?.levelOfTraining
            }else{
                cell.specs_View.backgroundColor = UIColor(named: "Receiver_Message")
                cell.specs_Title.text = particularPrograms?.category
            }

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}



