
import UIKit
import AVKit
import SDWebImage

class Trainer_Exercise_View: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var thumbnail_Image: UIImageView!
    @IBOutlet weak var photos_Collectionview: UICollectionView!
    @IBOutlet weak var thumbnail_View: GradientView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseDesc: UILabel!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var interfaceTitle: UILabel!
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var exerciseInfo: UILabel!
    
    @IBOutlet weak var setsTF: UITextField!
    @IBOutlet weak var repsTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    
    var name = String()
    var desc = String()
    var exercise_info = String()
    var selectedRow = Int()
    var userRole = ""
    let playerViewController = AVPlayerViewController()
    var training_id = String()
    var program_id = String()
    var addEditDisableForTrainerDueToNavigateFromTrainerTraining = Bool()
    var isEnableEditModeWhenNavigateViaWorkout: Bool = false
    var databaseTblID: String = ""
    var isNavigateViaSentProgramDetails = false
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setsTF.placeholderColor(color: UIColor.white)
        repsTF.placeholderColor(color: UIColor.white)
        timeTF.placeholderColor(color: UIColor.white)
        
        main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        thumbnail_View.layer.cornerRadius = 4.0
        thumbnail_Image.layer.cornerRadius = 4.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                editLabel.isHidden = false
                editButton.isUserInteractionEnabled = true
                deleteIcon.isHidden = false
                deleteButton.isUserInteractionEnabled = true
                
                if addEditDisableForTrainerDueToNavigateFromTrainerTraining == true{
                    editLabel.isHidden = true
                    editButton.isUserInteractionEnabled = false
                    deleteIcon.isHidden = true
                    deleteButton.isUserInteractionEnabled = false
                }
                
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                editLabel.isHidden = true
                editButton.isUserInteractionEnabled = false
                deleteIcon.isHidden = true
                deleteButton.isUserInteractionEnabled = false
            }
        }
        initialSetUp()
        
        
        /* if let count = particularExercise?.excerciseImage?.count{
         if count > 0{
         let firstIndex = particularExercise?.excerciseImage?.first
         if firstIndex == ""{
         emptyGallery.isHidden = false
         }else{
         emptyGallery.isHidden = true
         }
         }else{
         emptyGallery.isHidden = false
         }
         }else{
         emptyGallery.isHidden = false
         }*/
        
        if isNavigateViaSentProgramDetails {
            editLabel.isHidden = true
            editButton.isUserInteractionEnabled = false
            deleteIcon.isHidden = true
            deleteButton.isUserInteractionEnabled = false
        }
        
    }
    
    func initialSetUp(){
        exerciseName.text = particularExercise?.excerciseName ?? "N/A"
        interfaceTitle.text = particularExercise?.excerciseName ?? "N/A"
        exerciseDesc.text = particularExercise?.excerciseDescription ?? "N/A"
        //exerciseInfo.text = particularExercise?.exercise_info ?? "N/A"
        
        setsTF.text = particularExercise?.sets ?? ""
        repsTF.text = particularExercise?.reps ?? ""
        timeTF.text = particularExercise?.time ?? ""
        
        if particularExercise?.excerciseVideo != ""{
            playIcon.image = #imageLiteral(resourceName: "playButton")
        }else{
            playIcon.image = #imageLiteral(resourceName: "noVideo")
        }
        
        if let photo = particularExercise?.thumbnil{
            if photo != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                thumbnail_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                thumbnail_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "waitPostImage"), options: .highPriority)
            }else{
                thumbnail_Image.image = #imageLiteral(resourceName: "workoutSampleImage")
            }
        }
        
        photos_Collectionview.delegate = self
        photos_Collectionview.dataSource = self
        photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
        photos_Collectionview.reloadData()
        
        if training_id != "" && program_id != ""{
            editLabel.isHidden = true
            editButton.isUserInteractionEnabled = false
            deleteIcon.isHidden = true
            deleteButton.isUserInteractionEnabled = false
            
            if isEnableEditModeWhenNavigateViaWorkout {

                userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
                if userRole != "" {
                    if (userRole == Role.trainer.rawValue){
                        editLabel.isHidden = false
                        editButton.isUserInteractionEnabled = true
                        
                    } else if (userRole == Role.client.rawValue) {
                        editLabel.isHidden = true
                        editButton.isUserInteractionEnabled = false
                    }
                }
  
                //deleteIcon.isHidden = false
                //deleteButton.isUserInteractionEnabled = true
            }
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        let storyboard = AppStoryboard.Trainer_Tabbar.instance
        //let loginScene = storyboard.instantiateViewController(withIdentifier: "Trainer_Add_Exercise") as! Trainer_Add_Exercise
        let loginScene = storyboard.instantiateViewController(withIdentifier: "TrainerEditExercise") as! TrainerEditExercise
        loginScene.training_id = training_id
        loginScene.program_id = program_id
        loginScene.databaseTblID = databaseTblID
        loginScene.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(loginScene, animated: true)
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
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
    
    @IBAction func deleteExerciseVideo(_ sender: UIButton) {
        if particularExercise?.excerciseVideo != ""{
            deleteExerciseVideo(parameters:["excercise_id":particularExercise?.id ?? ""] )
        }else{
            UniversalMethod.universalManager.alertMessage("No Exercise Video", self.navigationController)
        }
    }
    
    
    //MARK: Helper's Method
}

extension Trainer_Exercise_View: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        /*   if isTrainer == "Trainer"{
         if let count = entityDict?.files?.count{
         
         if count > 0{
         emptyGallery.isHidden = true
         }else{
         emptyGallery.isHidden = false
         }
         
         }else{
         emptyGallery.isHidden = false
         }
         
         return entityDict?.files?.count ?? 0
         }else{
         if let count = entityDict?.trainer?.user?.files?.count{
         
         if count > 0{
         emptyGallery.isHidden = true
         }else{
         emptyGallery.isHidden = false
         }
         
         }else{
         emptyGallery.isHidden = false
         }
         
         return entityDict?.trainer?.user?.files?.count ?? 0
         }*/
        
        emptyGallery.isHidden = true
        
        guard var count = particularExercise?.excerciseImage?.count else{
            //emptyGallery.isHidden = false
            return 0
        }
        if count > 0{
            let firstIndex = particularExercise?.excerciseImage?.first
            if firstIndex == ""{
                count = 0
                //emptyGallery.isHidden = false
            }else{
                //emptyGallery.isHidden = true
            }
        }else{
            //emptyGallery.isHidden = false
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

            if let photo = particularExercise?.excerciseImage?[indexPath.row]{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    cell.trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.trainer_Photos.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.trainer_Photos.image = #imageLiteral(resourceName: "user")
                }
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
        vc.imageURL = particularExercise?.excerciseImage?[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
