
import UIKit
import AVKit
import SDWebImage
import UniformTypeIdentifiers

class Trainer_Training_View: UIViewController, UIScrollViewDelegate {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var thumbnail_Image: UIImageView!
    @IBOutlet weak var thumbnail_View: GradientView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var training_Info_View: UIView!
    @IBOutlet weak var day_Collection: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var videoThumbCollection: UICollectionView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var emptyDays: UILabel!
    @IBOutlet weak var trainingName: UILabel!
    @IBOutlet weak var trainingDesc: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dragDelegate = self
            tableView.dropDelegate = self
            tableView.dragInteractionEnabled = true
        }
    }
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var addExerciseIconWidth: NSLayoutConstraint!
    @IBOutlet weak var addTrainingExerciseButton: UIButton!
    @IBOutlet weak var addExerciseIcon: UIImageView!
    @IBOutlet weak var reorderBtn: UIButton!
    
    var days = [String]()
    var dayIndex = [Int]()
    var selectedRow = Int()
    var selectedTrainingRow = Int()
    var tags:String?
    var userRole = ""
    var trainingDayName = ""
    //  var trainingDict: M_CPEITraining?
    let playerViewController = AVPlayerViewController()
    
    var selectedDaysArray = [String]()
    var selectedWorkoutDay = [[String:String]]()
    var daysDict = [["name":"Monday", "id":"1"],
                    ["name":"Tuesday", "id":"2"],
                    ["name":"Wednesday", "id":"3"],
                    ["name":"Thursday", "id":"4"],
                    ["name":"Friday", "id":"5"],
                    ["name":"Saturday", "id":"6"],
                    ["name":"Sunday", "id":"7"]]
    
    var type = Int()
    var isBackToWorkoutDaysVC = false
    var workoutExercisesDetail = [M_ExerciseData]()
    var isWorkoutExercisesShuffled: Bool = false
    var isNavigateViaSentProgramDetails = false
    
    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        training_Info_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        // thumbnail_View.layer.cornerRadius = 4.0
        thumbnail_Image.layer.cornerRadius = 4.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTrainingExerciseTableView(_:)), name: NSNotification.Name(rawValue: "reloadTrainingExerciseTableView"), object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updatedExerciseInfos(_:)),
                                               name: NSNotification.Name(rawValue: "updatedExerciseInfos"),
                                               object: nil)
        
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        if let patternImage = UIImage(named: "workoutWideSampleImage") {
            reorderBtn.backgroundColor = UIColor(patternImage: patternImage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        day_Collection.delegate = self
        day_Collection.dataSource = self
        day_Collection.register(UINib(nibName: "Days_Cell", bundle: nil), forCellWithReuseIdentifier: "Days_Cell")
        
        videoThumbCollection.delegate = self
        videoThumbCollection.dataSource = self
        videoThumbCollection.register(UINib(nibName: "VideoThumb_Cell", bundle: nil), forCellWithReuseIdentifier: "VideoThumb_Cell")
        
        day_Collection.reloadData()
        videoThumbCollection.reloadData()
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
                
        if userRole != "" {
            if (userRole == Role.trainer.rawValue) {
                isTrainer = "Trainer"
                editLabel.isHidden = false
                editButton.isUserInteractionEnabled = true
                
                addExerciseIconWidth.constant = 40.0
                addTrainingExerciseButton.isUserInteractionEnabled = true
                addExerciseIcon.isHidden = false
                type = 1
                
                reorderBtn.isHidden = false
                tableView.dragInteractionEnabled = true
                
            } else if (userRole == Role.client.rawValue) {
                isTrainer = "Client"
                editLabel.isHidden = true
                editButton.isUserInteractionEnabled = false
                
                addExerciseIconWidth.constant = 0.0
                addTrainingExerciseButton.isUserInteractionEnabled = false
                addExerciseIcon.isHidden = true
                type = 2
                
                reorderBtn.isHidden = true
                tableView.dragInteractionEnabled = false
            }
        } else {
            reorderBtn.isHidden = true
        }
        
        days.removeAll()
        trainingName.text = particularProgramTraining?.trainingName ?? ""
        trainingDesc.text = particularProgramTraining?.trainingDescription ?? ""
        
        if let photo = particularProgramTraining?.training_thumbnil{
            if photo != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                thumbnail_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                thumbnail_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "workoutSampleImage"), options: .highPriority)
            }else{
                thumbnail_Image.image = #imageLiteral(resourceName: "workoutSampleImage")
            }
        }
        
        //particularProgramTraining
        
        let selectedDayArray = particularProgramTraining?.trainingDay?.components(separatedBy: ",")
        
        selectedWorkoutDay.removeAll()
        
        _ = selectedDayArray?.map({ id in
            if let dayID = Int(id){
                let indexVal = dayID - 1
                if indexVal >= 0{
                    selectedWorkoutDay.append(daysDict[indexVal])
                }
            }
        })
        
        selectedDaysArray.removeAll()
        _ = selectedWorkoutDay.map({ dict in
            selectedDaysArray.append(dict["name"] ?? "")
        })
        
        getAllTrainingExercise(parameters:[:], type: type)
        
        if isNavigateViaSentProgramDetails {
            editLabel.isHidden = true
            editButton.isUserInteractionEnabled = false
            
            addExerciseIconWidth.constant = 0.0
            addTrainingExerciseButton.isUserInteractionEnabled = false
            addExerciseIcon.isHidden = true
            
            reorderBtn.isHidden = true
            tableView.dragInteractionEnabled = false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView.layer.removeAllAnimations()
        let tableViewHeight = tableView.contentSize.height
        if tableViewHeight > 10.0 {
            tableHeight.constant = tableViewHeight
        } else {
            tableHeight.constant = 250.0
        }
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    //MARK : IB's Action
    @IBAction func tappedReorder(_ sender: UIButton) {
        if workoutExercisesDetail.count > 0 {
            var tbl1_obj: [[String: Any]] = []
            var tbl2_obj: [[String: Any]] = []
            for (index, exercise) in workoutExercisesDetail.enumerated() {
                let position = index + 1
                if exercise.is_flag == "1" {
                    if let id = exercise.id {
                        let dict = ["id": id, "position": position] as [String : Any]
                        tbl1_obj.append(dict)
                    }
                }
                
                if exercise.is_flag == "2" {
                    if let id = exercise.id {
                        let dict = ["id": id, "position": position] as [String : Any]
                        tbl2_obj.append(dict)
                    }
                }
            }
            
            let params = ["tbl1": tbl1_obj, "tbl2": tbl2_obj]
            guard let jsonData = convertToJSONData(params: params) else { return }
            update_exercise_positions_remote_request(jsonData: jsonData)
        }
    }
    
    @IBAction func tappedAddTrainingExercise(_ sender: UIButton) {
        if isWorkoutExercisesShuffled {
            self.popupAlert(title: "Death Before Average",
                            message: "It appears that the order of the workout's exercises has changed. Please save your changes by tapping Re-Order before continuing. You will lose your ordering if you don't.",
                            actionTitles: ["Continue, without save", "Cancel"],
                            actions: [ { _ in
                DispatchQueue.main.async {
                    self.showActionSheet()
                }
            }, { _ in }, nil])
        } else {
            showActionSheet()
        }
    }
    
    fileprivate func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Add exercise", style: .default, handler: { (alertAction: UIAlertAction) in
            //Catalogue
            let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Catalogue") as! Catalogue
            vc.training_id = particularProgramTraining?.id ?? ""
            vc.program_id = particularProgramTraining?.programID ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            /*
             self.mergeTrainingExcercise(parameters:["training_id":particularProgramTraining?.id ?? "",
             "program_id":particularProgramTraining?.programID ?? ""])
             */
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Add new exercise", style: .default, handler: { (alertAction: UIAlertAction) in
            let vc = AppStoryboard.Trainer_Tabbar.instance.instantiateViewController(withIdentifier: "Trainer_Add_Exercise") as! Trainer_Add_Exercise
            vc.training_id = particularProgramTraining?.id ?? ""
            vc.program_id = particularProgramTraining?.programID ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (alertAction: UIAlertAction) in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: UIButton) {
        if isBackToWorkoutDaysVC {
            if let vc = navigationController?.viewControllers.filter({ $0 is WorkoutDaysVC }).first {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        if isWorkoutExercisesShuffled {
            self.popupAlert(title: "Death Before Average",
                            message: "It appears that the order of the workout's exercises has changed. Please save your changes by tapping Re-Order before continuing. You will lose your ordering if you don't.",
                            actionTitles: ["Continue, without save", "Cancel"],
                            actions: [ { _ in
                DispatchQueue.main.async {
                    UniversalMethod.universalManager.pushVC("TrainerEditTraining",
                                                            self.navigationController,
                                                            storyBoard: AppStoryboard.Trainer_Training.rawValue)
                }
            }, { _ in }, nil])
        } else {
            UniversalMethod.universalManager.pushVC("TrainerEditTraining",
                                                    self.navigationController,
                                                    storyBoard: AppStoryboard.Trainer_Training.rawValue)
        }
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        
    }
    
    @IBAction func exercise1(_ sender: UIButton) {
        
    }
    
    @IBAction func exercise2(_ sender: UIButton) {
        
    }
    
    @IBAction func addExercise(_ sender: UIButton) {
        
    }
    
    //MARK: Helper's Method
    
    @objc func reloadTrainingExerciseTableView(_ notify:NSNotification){
        let isGetted = notify.object as? Bool
        if isGetted == true{
            getAllTrainingExercise(parameters:[:], type: type)
        }else{
            
        }
    }
    
    @objc func updatedExerciseInfos(_ notify: NSNotification) {
        workoutExercisesDetail = exerciseInfos?.data ?? []
        tableView.reloadData()
    }
}

extension Trainer_Training_View: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == videoThumbCollection{
            return 1
        }else{
            //emptyDays.isHidden = true
            //return 1
            
            return selectedDaysArray.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == videoThumbCollection{
            return CGSize(width: self.videoThumbCollection.frame.size.width , height: self.videoThumbCollection.frame.size.height)
        }else{
            let label = UILabel(frame: CGRect.zero)
            
            /*
             if particularProgramTraining?.trainingDay == "1"{
             label.text = "Mon"
             trainingDayName = "Mon"
             }else if (particularProgramTraining?.trainingDay == "2"){
             label.text = "Tue"
             trainingDayName = "Tue"
             }else if (particularProgramTraining?.trainingDay == "3"){
             label.text = "Wed"
             trainingDayName = "Wed"
             }else if (particularProgramTraining?.trainingDay == "4"){
             label.text = "Thur"
             trainingDayName = "Thur"
             }else if (particularProgramTraining?.trainingDay == "5"){
             label.text = "Fri"
             trainingDayName = "Fri"
             }else if (particularProgramTraining?.trainingDay == "6"){
             label.text = "Sat"
             trainingDayName = "Sat"
             }else if (particularProgramTraining?.trainingDay == "7"){
             label.text = "Sun"
             trainingDayName = "Sun"
             }
             */
            
            label.text = selectedDaysArray[indexPath.row]
            
            label.sizeToFit()
            // return CGSize(width: label.frame.width + 10, height: 35.0)
            return CGSize(width: label.frame.width + 10, height: 35.0)
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
        
        if collectionView == videoThumbCollection{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoThumb_Cell", for: indexPath) as? VideoThumb_Cell {
                cell.layer.cornerRadius = 4.0
                
                if particularProgramTraining?.trainingVideo != ""{
                    cell.playIcon.image = #imageLiteral(resourceName: "playButton")
                }else{
                    cell.playIcon.image = #imageLiteral(resourceName: "noVideo")
                }
                
                return cell
            } else {
                return UICollectionViewCell()
            }
        }else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Days_Cell", for: indexPath) as? Days_Cell {
                // cell.days_Name.text = trainingDayName
                cell.days_Name.text = selectedDaysArray[indexPath.row]
                return cell
            } else {
                return UICollectionViewCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == videoThumbCollection{
            if indexPath.item == 0{
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
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        pageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        pageController?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension Trainer_Training_View: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        guard let count = exerciseInfos?.data?.count else{
        //            emptyView.isHidden = false
        //            return 0
        //        }
        
        
        
        let count = workoutExercisesDetail.count
        
        if count  > 0{
            emptyView.isHidden = true
        }else{
            emptyView.isHidden = false
        }
        return count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // particularExercise = exerciseInfos?.data?[indexPath.row]
        particularExercise = workoutExercisesDetail[indexPath.row]
        
        if particularExercise?.type == "0"{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Client_Progress", for: indexPath) as? Client_Progress {
                cell.days_Text.text = particularExercise?.folder_name
                cell.days_Text.numberOfLines = 2
                cell.dateTimeStampViewHeight.constant = 0.0
                return cell
            } else {
                return UITableViewCell()
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise_Programs_Cell", for: indexPath) as? Exercise_Programs_Cell {
                
                cell.backgroundColor = .clear
                
                // particularExercise = exerciseInfos?.data?[indexPath.row]
                particularExercise = workoutExercisesDetail[indexPath.row]
                cell.exerciseName.text = particularExercise?.excerciseName
                
                if let photo = particularExercise?.thumbnil{
                    if photo != ""{
                        let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                        cell.videoThumbnail.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        cell.videoThumbnail.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "waitPostImage"), options: .highPriority)
                    }else{
                        cell.videoThumbnail.image = #imageLiteral(resourceName: "workoutSampleImage")
                    }
                }
                
                if particularExercise?.excerciseVideo != ""{
                    cell.playIcon.image = #imageLiteral(resourceName: "playButton")
                }else{
                    cell.playIcon.image = #imageLiteral(resourceName: "noVideo")
                }
                
                cell.videoThumbnail.layer.cornerRadius = 5.0
                
                cell.playButton.tag = indexPath.row
                cell.playButton.addTarget(self, action: #selector(playExerciseVideo(_sender:)), for: .touchUpInside)
                
                if userRole == Role.trainer.rawValue && isNavigateViaSentProgramDetails == false {
                    let deleteButton = RowActionButton(title: "", icon: #imageLiteral(resourceName: "delete_icon"), backgroundColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.2196078431, alpha: 1), padding: 15) { [weak self, indexPath] _ -> Bool in
                        self?.removeProgram(at: indexPath.row)
                        return true
                    }
                    cell.rightButtons = [deleteButton]
                    cell.configure()
                }
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isWorkoutExercisesShuffled {
            self.popupAlert(title: "Death Before Average",
                            message: "It appears that the order of the workout's exercises has changed. Please save your changes by tapping Re-Order before continuing. You will lose your ordering if you don't.",
                            actionTitles: ["Continue, without save", "Cancel"],
                            actions: [ { _ in
                DispatchQueue.main.async {
                    self.performDidSelectEvent(indexPath)
                }
            }, { _ in }, nil])
        } else {
            performDidSelectEvent(indexPath)
        }
    }
    
    fileprivate func performDidSelectEvent(_ indexPath: IndexPath) {
        // particularExercise = exerciseInfos?.data?[indexPath.row]
        particularExercise = workoutExercisesDetail[indexPath.row]
        
        if particularExercise?.type == "0"{
            
            let storyBoard = AppStoryboard.Trainer_Tabbar.instance
            let vc = storyBoard.instantiateViewController(withIdentifier: "ExerciseByCatalogueID") as! ExerciseByCatalogueID
            vc.catalogueID = particularExercise?.folder_id ?? ""
            vc.catalogueName = particularExercise?.folder_name ?? ""
            selectedCatalgoueID = particularExercise?.folder_id ?? ""
            vc.addEditDisableForTrainerDueToNavigateFromTrainerTraining = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if particularExercise?.type == "1"{
            /*  entityDict = clientExProInfo?.entities?[indexPath.row]*/
            let storyBoard = AppStoryboard.Trainer_Tabbar.instance
            let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Exercise_View") as! Trainer_Exercise_View
            /*  vc.desc = entityDict?.entityDescription ?? ""
             vc.name = entityDict?.name ?? ""
             vc.selectedRow = indexPath.row*/
            vc.training_id = particularProgramTraining?.id ?? ""
            vc.program_id = particularProgramTraining?.programID ?? ""
            vc.databaseTblID = particularExercise?.is_flag ?? ""
            vc.isEnableEditModeWhenNavigateViaWorkout = true
            vc.isNavigateViaSentProgramDetails = isNavigateViaSentProgramDetails
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            //UniversalMethod.universalManager.pushVC("Trainer_Exercise_View", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
        }
    }
    
    func popupAlert(title: String?,
                    message: String?,
                    actionTitles: [String?],
                    actions: [((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            if index == 0 {
                action.setValue(UIColor.red, forKey: "titleTextColor")
            }
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
    // MARK: - UITableViewDragDelegate
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = workoutExercisesDetail[indexPath.row]
        
        // Customize the cell being dragged
        if let cell = tableView.cellForRow(at: indexPath) as? Exercise_Programs_Cell {
            // Clear the background color or set to another color
            cell.backgroundColor = UIColor(named: "#494459")
        }
        
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = workoutExercisesDetail.remove(at: sourceIndexPath.row)
        workoutExercisesDetail.insert(mover, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: any UITableViewDropCoordinator) { }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        // Restore the cell's appearance after dragging ends
        self.isWorkoutExercisesShuffled = true
        self.tableView.reloadData()
    }
    
    private func removeProgram(at index: Int) {
        if isWorkoutExercisesShuffled {
            self.popupAlert(title: "Death Before Average",
                            message: "It appears that the order of the workout's exercises has changed. Please save your changes by tapping Re-Order before continuing. You will lose your ordering if you don't.",
                            actionTitles: ["Continue, without save", "Cancel"],
                            actions: [ { _ in
                DispatchQueue.main.async {
                    self.performDeleteWorkoutExercise(index)
                }
            }, { _ in }, nil])
        } else {
            performDeleteWorkoutExercise(index)
        }
    }
    
    fileprivate func performDeleteWorkoutExercise(_ index: Int) {
        //is_catalogue:1 (if is_catalogue=2 then send id if 1 then send e_id)
        // let exerciseInfo = exerciseInfos?.data?[index]
        let exerciseInfo = workoutExercisesDetail[index]
        var params = [String: Any]()
        if exerciseInfo.is_catalogue == "1" {
            if let eId = exerciseInfo.e_id {
                params = ["id": eId, "is_catalogue": "1"]
                deleteWorkoutExercise(parameters: params)
            }
        } else if exerciseInfo.is_catalogue == "2" {
            if let id = exerciseInfo.id {
                params = ["id": id, "is_catalogue": "2"]
                deleteWorkoutExercise(parameters: params)
            }
        }
    }
    
    @objc func playExerciseVideo(_sender: UIButton){
        // particularExercise = exerciseInfos?.data?[_sender.tag]
        particularExercise = workoutExercisesDetail[_sender.tag]
        if particularExercise?.excerciseVideo != ""{
            let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(particularExercise?.excerciseVideo ?? "")"
            if let videoURL = URL(string: completePicUrl) {
                let player = AVPlayer(url: videoURL)
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    self.playerViewController.player?.play()
                }
            }
        }
    }
    
    func mergeTrainingExcercise(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.merge_training_excercise, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        
                        self.getAllTrainingExercise(parameters:[:], type: self.type)
                        
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
    
    func deleteWorkoutExercise(parameters:[String: Any]) {
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            apimethod.commonMethod(url: ApiURLs.deleteExercise, parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        self.getAllTrainingExercise(parameters:[:], type: self.type)
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
    
    fileprivate func update_exercise_positions_remote_request(jsonData: Data) {
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            apimethod.commonMethod(url: ApiURLs.update_exercise_positions,
                                   parameters: [:],
                                   method: "RAW_JSON",
            raw_json_data: jsonData) { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                        if result.statusCode == 401{
                            logoutFromAPP()
                        }else{
                            UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                        }
                        
                    }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                        self.getAllTrainingExercise(parameters:[:], type: self.type)
                    }else if(result.statusCode==500){
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
            }
        } else {
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}


func convertDataToJSONString(data: Data) -> String? {
    do {
        // Attempt to serialize the data into a JSON object
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        // Convert the JSON object back to a JSON string with pretty printing
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        
        // Convert the JSON data to a string
        return String(data: jsonData, encoding: .utf8)
    } catch {
        print("Error converting JSON data to JSON string: \(error)")
        return nil
    }
}


// Convert the dictionary to JSON data
func convertToJSONData(params: [String: [[String: Any]]]) -> Data? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        return jsonData
    } catch {
        print("Error converting dictionary to JSON data: \(error)")
        return nil
    }
}
