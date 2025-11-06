
import UIKit
import MGSwipeTableCell
import SDWebImage

class All_Trainers: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var goals_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noTrainerMessage: UILabel!
    @IBOutlet weak var findRightTrainerMessage: UILabel!

    var currentRowIndex = Int()
    var newURL = String()
    var searchedString = String()
    var replaced = String()
    var stringRep = String()
    var pageNo = 1
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchTF.placeholderColor(color: UIColor.white)
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        searchView.layer.cornerRadius = 20.0
        searchView.layer.borderWidth = 1.0
        searchView.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        searchView.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.72, radius: 10.5)
        
        // getSearchedTrainerList(parameters:[:] )
        searchTF.delegate = self
        searchTF.addDoneButtonOnKeyboard()
        searchTF.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(searchedTrainer(_:)), name: NSNotification.Name(rawValue: Constants.searchTrainer), object: nil)
        
    }
    
    @objc func searchedTrainer(_ notify:NSNotification){

        /* let isNewAnswer = notify.object as? Bool
         if isNewAnswer == true{
         
         if Constant.choosedSpecialist.count > 0{
         stringRep = Constant.choosedSpecialist.joined(separator: "%2C")
         }else{
         stringRep = ""
         }
         
         getSearchedTrainerList(parameters:[:] )
         }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = false
        getAllTrainer(parameters:[:])
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filter_Action(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Filter_Trainer", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
    }
    
    //MARK: Helper's Method
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if  let remainingPagesCount = DataSaver.dataSaverManager.fetchData(key: "remainingPages") as? Int{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if scrollView == goals_Tableview{
                if (scrollView.contentOffset.y == /*0*/ maximumOffset) {
                    if remainingPagesCount < 1{
                        // UniversalMethod.universalManager.alertMessage("No Product left", self.navigationController)
                    }else{
                        pageNo = pageNo + 1
                        getAllTrainer(parameters:[:])
                    }
                }
            }
        }
    }
    
}

extension All_Trainers: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        empty_View.isHidden = false
        
        guard let count = allTrainerInfo?.data?.count else{
            noTrainerMessage.isHidden = false
            findRightTrainerMessage.isHidden = false
            goals_Tableview.isHidden = true
            return 0
        }
        if count > 0{
            noTrainerMessage.isHidden = true
            findRightTrainerMessage.isHidden = true
            goals_Tableview.isHidden = false
        }else{
            noTrainerMessage.isHidden = false
            findRightTrainerMessage.isHidden = false
            goals_Tableview.isHidden = true
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Trainers_List_Cell", for: indexPath) as? Trainers_List_Cell {
            let searchedDict = allTrainerInfo?.data?[indexPath.row]
            currentRowIndex = indexPath.row
            categoryArrayIndex = indexPath.row

            let userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""

            if (userRole == Role.trainer.rawValue){

                cell.photos_CollectionViewHeight.constant = 0.0
                cell.emptyView.isHidden = true
                cell.photos_CollectionViewBottom.constant = 0.0

//                cell.ratingViewHeight.constant = 0.0
//                cell.rating_View.isHidden = true
//                cell.ratingTrainer.isUserInteractionEnabled = false

                cell.ratingViewHeight.constant = 40.0
                cell.rating_View.isHidden = false
                cell.ratingTrainer.isUserInteractionEnabled = true
                cell.achivementTitleLabel.text = ""

            }else if (userRole == Role.client.rawValue) {
                cell.achivementTitleLabel.text = "Achievements"
                cell.ratingViewHeight.constant = 40.0
                cell.rating_View.isHidden = false
                cell.ratingTrainer.isUserInteractionEnabled = true


                cell.photos_Collectionview.delegate = self
                cell.photos_Collectionview.dataSource = self
                cell.photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
                cell.photos_Collectionview.tag = indexPath.row
                cell.photos_Collectionview.reloadData()

                if let count = searchedDict?.certificateImage?.count{
                    if count > 0{
                        let firstIndex = searchedDict?.certificateImage?.first
                        if firstIndex == ""{
                            cell.emptyView.isHidden = false
                        }else{
                            cell.emptyView.isHidden = true
                        }
                    }else{
                        cell.emptyView.isHidden = false
                    }
                }else{
                    cell.emptyView.isHidden = false
                }

            }

            if searchedDict?.is_rating_enable == "0" {
                cell.rating_View.alpha = 0.6
                cell.ratingTrainer.isUserInteractionEnabled = false
            } else {
                cell.rating_View.alpha = 1.0
                cell.ratingTrainer.isUserInteractionEnabled = true
            }

            cell.ratingTrainer.tag = indexPath.row
            cell.ratingTrainer.addTarget(self, action: #selector(ratingView(sender:)), for: .touchUpInside)
            cell.name.text = searchedDict?.firstname
            cell.location_Trainer.text = searchedDict?.location
            cell.about_Trainer.text = searchedDict?.about
            cell.userEmail.text = searchedDict?.email

            if let createdDate = searchedDict?.createdon, !createdDate.isEmpty {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateUtil.dateTimeFormatForRecentTask
                dateFormatter.timeZone = TimeZone(identifier: "UTC")
                if let startDateTime = dateFormatter.date(from: createdDate){
                    if let joinedDate = DateUtil.convertUTCToLocalDateTime(startDateTime, DateUtil.timeFormatForShowingRecentTask), !joinedDate.isEmpty {
                        cell.joinedDate.text = "Joined \(joinedDate)"

                    }
                }
            }

            //cell.filterType.text = searchedDict?.specialist

            if searchedDict?.specialist != ""{
                let array = searchedDict?.specialist?.components(separatedBy: ",")
                //categoryArray = array ?? []
                //cell.filterType.text = array?.first
            }else{
                //cell.filterType.text = "N/A"
            }

            if searchedDict?.rating != "0.0"{
                cell.rating.text = searchedDict?.rating
                cell.ratingIcon.image = #imageLiteral(resourceName: "StarIcon")
            }else{
                cell.rating.text = "N/A"
                cell.ratingIcon.image = #imageLiteral(resourceName: "white-star")
            }

            if let photo = searchedDict?.image{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"

                    cell.user_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray

                    cell.user_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.user_Pic.image = #imageLiteral(resourceName: "user")
                }
            }

            if searchedDict?.isPurchased == "0"{
                cell.image_View.removeGradient()
                cell.image_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.53, radius: 6.5)
            }else{
                cell.image_View.removeGradient()
                cell.image_View.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
            }

            cell.categoryCollectionView.reloadData()

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchedTrainerInfo = allTrainerInfo?.data?[indexPath.row]
        let vc = AppStoryboard.Client_Search.instance.instantiateViewController(withIdentifier: "Trainer_Detail_View") as! Trainer_Detail_View
        vc.userID = searchedTrainerInfo?.userid ?? "0"
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //        UniversalMethod.universalManager.pushVC("Trainer_Detail_View", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    @objc func ratingView(sender:UIButton){
        DispatchQueue.main.async {
            searchedTrainerInfo = allTrainerInfo?.data?[sender.tag]
            //            if searchedTrainerInfo?.is_rating_enable != "0"{
            //                UniversalMethod.universalManager.pushVC("Rate_Trainer", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
            //            }else{
            //                UniversalMethod.universalManager.alertMessage("Either you're hadn't buy a program or If you purchased program already, So you can rate this trainer after 30 days(start from purchasing date).", self.navigationController)
            //            }
            
//            UniversalMethod.universalManager.pushVC("Rate_Trainer", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)

            let storyBoard = AppStoryboard.Client_Search.instance
            let destVC = storyBoard.instantiateViewController(withIdentifier: "Rate_Trainer") as! Rate_Trainer
            let userInfo = ParticularUserInfoForRatingView(userid: searchedTrainerInfo?.userid,
                                                           firstname: searchedTrainerInfo?.firstname,
                                                           lastname: searchedTrainerInfo?.lastname,
                                                           image: searchedTrainerInfo?.image,
                                                           rating: searchedTrainerInfo?.rating)
            destVC.particularUserInfoForRatingView = userInfo
            destVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(destVC, animated: true)

        }
    }
}

extension All_Trainers: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let filesDict = allTrainerInfo?.data?[collectionView.tag]
        guard var count = filesDict?.certificateImage?.count else{
            return 0
        }
        if count > 0{
            let firstIndex = filesDict?.certificateImage?.first
            if firstIndex == ""{
                count = 0
            }
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let modelName = UIDevice.modelName
        if (modelName == "iPhone X" || modelName == "iPhone XS" || modelName == "iPhone XS Max" || modelName == "iPhone XR") {
            return CGSize(width: 85.0, height: 90.0)
        }else {
            return CGSize(width: 85.0, height: 90.0)
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trainer_Photos_Cell", for: indexPath) as? Trainer_Photos_Cell {
            let filesDict = allTrainerInfo?.data?[collectionView.tag]
            if let photo = filesDict?.certificateImage?[indexPath.row]{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.trainer_Photos.image = #imageLiteral(resourceName: "user")
                }
            }

            let tag = (currentRowIndex * 1000) + indexPath.row
            cell.tag = tag
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let filesDict = allTrainerInfo?.data?[collectionView.tag]
//        let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
//        vc.imageURL = filesDict?.certificateImage?[indexPath.row]
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
//        searchedTrainerInfo = allTrainerInfo?.data?[currentRowIndex]
        
        let vc = UIStoryboard(name: AppStoryboard.Client_Search.rawValue, bundle: nil).instantiateViewController(withIdentifier: "Searched_Trainer_Achievement") as! Searched_Trainer_Achievement
        vc.achievements = allTrainerInfo?.data?[collectionView.tag].achievements
        self.navigationController?.pushViewController(vc, animated: true)
        
        
//        particularAcheivementInfo = allTrainerInfo?.data?[collectionView.tag].achievements?.first
//    Constants.isSearchedTrainerAchievement = "1"
//    UniversalMethod.universalManager.pushVC("Trainer_Edit_Achievement", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
}

extension All_Trainers: UITextFieldDelegate{
    @objc func textIsChanging(_ textField:UITextField){
        DispatchQueue.main.async {
            self.searchedString = textField.text ?? ""
            self.getAllTrainer(parameters:[:], isHideIndicator: true)
        }
    }
}
