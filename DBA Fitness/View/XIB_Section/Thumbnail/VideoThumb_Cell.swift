
import UIKit

class VideoThumb_Cell: UICollectionViewCell  {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var trainer_Photos: UIImageView!
    @IBOutlet weak var photos_View: UIView!
    @IBOutlet weak var photos_View_Height: NSLayoutConstraint!
    @IBOutlet weak var playIcon: UIImageView!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // trainer_Photos.layer.cornerRadius = 4.0
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
}


