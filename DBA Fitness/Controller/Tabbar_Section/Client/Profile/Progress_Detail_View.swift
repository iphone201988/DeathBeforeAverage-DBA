
import UIKit
import SDWebImage

class Progress_Detail_View: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var photos_Collectionview: UICollectionView!
    @IBOutlet weak var main_View: UIView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseDesc: UILabel!
    @IBOutlet weak var time_View: UIView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var totalPhotos: UILabel!
    @IBOutlet weak var emptyGallery: UILabel!
    @IBOutlet weak var progressDate: UILabel!
    @IBOutlet weak var cameraIcon: UIImageView!
    
    var name = String()
    var desc = String()
    var currentDate = Date()
    var dateFormatter = DateFormatter()
    var searchedClientUserID = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        main_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        time_View.customView(borderWidth:1.0, cornerRadius:3.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
        time_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)

        NotificationCenter.default.addObserver(self, selector: #selector(updateEditProgress(_:)),
                                               name: NSNotification.Name(rawValue: Constants.updateEditProgress),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // particularClientProgress
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let createDate = dateFormatter.date(from: particularClientProgress?.createdon ?? "") ?? Date()
        dateFormatter.dateFormat = "EEE, MMM d"
        progressDate.text = dateFormatter.string(from: createDate)
        exerciseDesc.text = particularClientProgress?.datumDescription
        
        if particularClientProgress?.image?.count ?? 0 < 2{
            let firstIndex = particularClientProgress?.image?.first
            if firstIndex != ""{
                totalPhotos.text = "Photos \(particularClientProgress?.image?.count ?? 0)"
                cameraIcon.isHidden = false
            }else{
                totalPhotos.text = ""
                cameraIcon.isHidden = true
            }
        }else{
            totalPhotos.text = "Photos \(particularClientProgress?.image?.count ?? 0)"
            cameraIcon.isHidden = false
        }
        photos_Collectionview.delegate = self
        photos_Collectionview.dataSource = self
        photos_Collectionview.register(UINib(nibName: "Trainer_Photos_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Photos_Cell")
        
        
        if searchedClientUserID == ""{
            editLabel.isHidden = false
            editButton.isUserInteractionEnabled = true
        }else if searchedClientUserID != ""{
            editLabel.isHidden = true
            editButton.isUserInteractionEnabled = false
        }
        
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func edit(_ sender: UIButton) {
        let storyBoard = AppStoryboard.Client_Progress.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "EditProgress") as! EditProgress
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Helper's Method
    @objc func updateEditProgress(_ notify:NSNotification){
        photos_Collectionview.reloadData()
        if particularClientProgress?.image?.count ?? 0 < 2{
            let firstIndex = particularClientProgress?.image?.first
            if firstIndex != ""{
                totalPhotos.text = "Photos \(particularClientProgress?.image?.count ?? 0)"
                cameraIcon.isHidden = false
            }else{
                totalPhotos.text = ""
                cameraIcon.isHidden = true
            }
        }else{
            totalPhotos.text = "Photos \(particularClientProgress?.image?.count ?? 0)"
            cameraIcon.isHidden = false
        }
    }
}

extension Progress_Detail_View: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard var count = particularClientProgress?.image?.count else{
            emptyGallery.isHidden = false
            return 0
        }
        if count > 0{
            let firstIndex = particularClientProgress?.image?.first
            if firstIndex == ""{
                count = 0
            }
            emptyGallery.isHidden = true
        }else{
            emptyGallery.isHidden = false
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

            if let photo = particularClientProgress?.image?[indexPath.row]{
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
        
        
        let photo = particularClientProgress?.image?[indexPath.row]
        
        let vc = UIStoryboard(name: AppStoryboard.Gallery_Section.rawValue, bundle: nil).instantiateViewController(withIdentifier: "ShowingAttachment") as! ShowingAttachment
        vc.imageURL = photo
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
