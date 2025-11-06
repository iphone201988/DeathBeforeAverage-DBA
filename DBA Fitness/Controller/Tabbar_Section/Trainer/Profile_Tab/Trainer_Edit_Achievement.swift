
import UIKit
import SDWebImage

class Trainer_Edit_Achievement: UIViewController, UITextFieldDelegate {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var achievements_View: UIView!
    @IBOutlet weak var trophy_View: UIView!
    @IBOutlet weak var numberOf_Certificate: UILabel!
    @IBOutlet weak var achievement_Year: UITextField!
    @IBOutlet weak var competition_Name: UITextField!
    @IBOutlet weak var juniors_Position: UITextField!
    @IBOutlet weak var weight_Position: UITextField!
    @IBOutlet weak var trophyIcon: UIImageView!
    @IBOutlet weak var certificate_Collectionview: UICollectionView!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var aboutAchievement: UITextView!
    @IBOutlet weak var saveTitle: UILabel!
    @IBOutlet weak var addCertificateTitle: UILabel!
    @IBOutlet weak var addCertificateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var photosArray = [URL]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        achievement_Year.placeholderColor(color: UIColor.white)
        competition_Name.placeholderColor(color: UIColor.white)
        //juniors_Position.placeholderColor(color: UIColor.white)
        //weight_Position.placeholderColor(color: UIColor.white)
        
        certificate_Collectionview.delegate = self
        certificate_Collectionview.dataSource = self
        certificate_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
        
        achievements_View.layer.cornerRadius = 7.0
        trophy_View.layer.cornerRadius = 4.0
        trophy_View.layer.borderWidth = 1.0
        trophy_View.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        trophy_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        trophyIcon.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.3, radius: 5.5)
        
        achievement_Year.delegate = self
        achievement_Year.addDoneButtonOnKeyboard()
        competition_Name.delegate = self
        competition_Name.addDoneButtonOnKeyboard()
        juniors_Position.delegate = self
        juniors_Position.addDoneButtonOnKeyboard()
        weight_Position.delegate = self
        weight_Position.addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let certificateCount = particularAcheivementInfo?.image?.count
        if certificateCount ?? 0 > 0{
            if certificateCount ?? 0 < 2{
                numberOf_Certificate.text = "\(certificateCount ?? 0) certificate"
            }else{
                numberOf_Certificate.text = "\(certificateCount ?? 0) certificates"
            }
        }else{
            numberOf_Certificate.text = "0 certificate"
        }
        achievement_Year.text = particularAcheivementInfo?.year
        competition_Name.text = particularAcheivementInfo?.event
        //juniors_Position.text = particularAcheivementInfo?.juniorAbsolute
        aboutAchievement.delegate = self
        aboutAchievement.addDoneButtonOnKeyboard()
        if let about = particularAcheivementInfo?.juniorAbsolute{
            aboutAchievement.text = about
            aboutAchievement.textColor = UIColor.white
        }else{
            aboutAchievement.text = "Write about achievement"
            aboutAchievement.textColor = UIColor.lightGray
        }
        
        weight_Position.text = particularAcheivementInfo?.menUpTo90_Kg
        certificate_Collectionview.reloadData()
        
        if Constants.isSearchedTrainerAchievement == "1"{
            saveTitle.isHidden = true
            addCertificateButton.isUserInteractionEnabled = false
            addCertificateTitle.text = numberOf_Certificate.text
            achievement_Year.isUserInteractionEnabled = false
            competition_Name.isUserInteractionEnabled = false
            aboutAchievement.isUserInteractionEnabled = false
            saveButton.isUserInteractionEnabled = false
        }else{
            saveTitle.isHidden = false
            addCertificateButton.isUserInteractionEnabled = true
            addCertificateTitle.text = "Add or Remove Certificate"
            achievement_Year.isUserInteractionEnabled = true
            competition_Name.isUserInteractionEnabled = true
            aboutAchievement.isUserInteractionEnabled = true
            saveButton.isUserInteractionEnabled = true
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func next(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skip(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func back(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        if achievement_Year.text != "" && competition_Name.text != "" && aboutAchievement.text != "" && aboutAchievement.text != "Write about achievement"{
            
            let refreshAlert = UIAlertController(title: "DBA Fitness", message: "During updating, don't close or minimize your app", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                self.addAchievement(year:self.achievement_Year.text ?? "", event:self.competition_Name.text ?? "", image:self.photosArray, junior_absolute:self.aboutAchievement.text ?? "", men_up_to_90_kg: self.weight_Position.text ?? "", apiUrl:ApiURLs.add_achievement, achievement_id:particularAcheivementInfo?.id ?? "0")
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
            
            //addAchievement(year:achievement_Year.text ?? "", event:competition_Name.text ?? "", image:photosArray, junior_absolute:juniors_Position.text ?? "", men_up_to_90_kg: weight_Position.text ?? "", apiUrl:ApiURLs.add_achievement, achievement_id:particularAcheivementInfo?.id ?? "0")
        }else{
            UniversalMethod.universalManager.alertMessage("All fields are required", self.navigationController)
            // All fields required except certificate
        }
    }
    
    @IBAction func add_Certificate(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Load_Certificates", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
        //UniversalMethod.universalManager.pushVC("Trainer_Gallery_View", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
    }
    
    //MARK: Helper's Method
    
}

extension Trainer_Edit_Achievement: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let count = particularAcheivementInfo?.image?.count else{
            emptyGallery.isHidden = false
            return 0
        }
        if count > 0{
            emptyGallery.isHidden = true
        }else{
            emptyGallery.isHidden = false
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let modelName = UIDevice.modelName
        if (modelName == "iPhone X" || modelName == "iPhone XS" || modelName == "iPhone XS Max" || modelName == "iPhone XR") {
            return CGSize(width: 125.0, height: 130.0)
        }else {
            return CGSize(width: 125.0, height: 130.0)
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
            cell.photos_View_Height.constant = 120.0

            if let photoss = particularAcheivementInfo?.image?[indexPath.row]{
                if photoss != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                    
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
        
        particularCertificateInfo = particularAcheivementInfo?.image?[indexPath.item]
        UniversalMethod.universalManager.pushVC("Trainer_Selected_AchievementCertificate", self.navigationController, storyBoard: AppStoryboard.Gallery_Section.rawValue)
    }
}

extension Trainer_Edit_Achievement: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            if aboutAchievement.text == "" || aboutAchievement.text == "Write about achievement"{
                textView.text = ""
            }
            textView.textColor = UIColor.white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "Write about achievement"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
