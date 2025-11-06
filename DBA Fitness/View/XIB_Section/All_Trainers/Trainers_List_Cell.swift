
import UIKit

class Trainers_List_Cell: UITableViewCell  {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var achivementTitleLabel: UILabel!
    @IBOutlet weak var search_View: UIView!
    @IBOutlet weak var image_View: UIView!
    @IBOutlet weak var user_Pic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var about_Trainer: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var rating_View: UIView!
    @IBOutlet weak var filterType: UILabel!
    @IBOutlet weak var type_View: UIView!
    @IBOutlet weak var photos_Collectionview: UICollectionView!
    @IBOutlet weak var location_Trainer: UILabel!
    @IBOutlet weak var ratingTrainer: UIButton!
    @IBOutlet weak var ratingIcon: UIImageView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var photos_CollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var photos_CollectionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var ratingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var joinedDate: UILabel!
    @IBOutlet weak var userEmail: UILabel!

    var array: [String]?
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        image_View.setViewCircle()

        user_Pic.setRoundImage()
        search_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        rating_View.customView(borderWidth:1, cornerRadius:4.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
        type_View.customView(borderWidth:1, cornerRadius:4.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
        
        rating_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        type_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        ratingIcon.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.3, radius: 5.5)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: "CategorySpecialist", bundle: nil), forCellWithReuseIdentifier: "CategorySpecialist")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() { }
    
    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}

extension Trainers_List_Cell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let searchedDict = allTrainerInfo?.data?[categoryArrayIndex ?? 0]
        array = searchedDict?.specialist?.components(separatedBy: ",")
        guard let count = array?.count else{
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = array?[indexPath.item]
        label.sizeToFit()
        //return CGSize(width: label.frame.width + 50, height: 50.0)
        return CGSize(width: label.intrinsicContentSize.width + 10, height: 38)

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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategorySpecialist", for: indexPath) as? CategorySpecialist {
            cell.type_Name.text = array?[indexPath.item]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

