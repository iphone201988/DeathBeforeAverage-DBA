
import UIKit
import SDWebImage

class Gallery_Cell: UICollectionViewCell  {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var trainer_Photos: UIImageView!
    @IBOutlet weak var photos_View: UIView!
    @IBOutlet weak var photos_View_Height: NSLayoutConstraint!
    @IBOutlet weak var trainer_photos_height: NSLayoutConstraint!
    @IBOutlet weak var photoDescription: UILabel!
    @IBOutlet weak var postViewBtn: UIButton!
    @IBOutlet weak var postView: UIView!
    
    //MARK : Controller Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //trainer_Photos.layer.cornerRadius = 4.0
        photos_View.layer.cornerRadius = 6
        photos_View.layer.masksToBounds = true
    }
    
    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                trainer_Photos.image = photo.image
                // captionLabel.text = photo.caption
                //  commentLabel.text = photo.comment
            }
        }
    }
    
    func configureCell(_ particularGalleryDict: M_UserMyGallery?){
        if let photoss = particularGalleryDict?.image{
            if photoss != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                
                trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                trainer_Photos.sd_setImage(with: URL(string: completePicUrl),
                                           placeholderImage: #imageLiteral(resourceName: "user"),
                                           options: .highPriority)
            }else{
                trainer_Photos.image = #imageLiteral(resourceName: "user")
            }
        }
        
        trainer_Photos.layer.cornerRadius = 20.0
    }
    
    
    func configureCellForCertificate(_ imageUrl:String?){
        if let photoss = particularGalleryDict?.image{
            if photoss != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photoss)"
                
                trainer_Photos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                trainer_Photos.sd_setImage(with: URL(string: completePicUrl),
                                           placeholderImage: #imageLiteral(resourceName: "user"),
                                           options: .highPriority)
            }else{
                trainer_Photos.image = #imageLiteral(resourceName: "user")
            }
        }
        
        trainer_Photos.layer.cornerRadius = 20.0
    }
}


