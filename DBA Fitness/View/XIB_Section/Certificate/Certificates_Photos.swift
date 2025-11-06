
import UIKit

class Certificates_Photos: UICollectionViewCell  {

    //MARK : Outlets and Variables
    @IBOutlet weak var trainer_Photos: UIImageView!
    @IBOutlet weak var photos_View: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var deleteIcon: UIImageView!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        trainer_Photos.layer.cornerRadius = 3.0
    }

    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}

