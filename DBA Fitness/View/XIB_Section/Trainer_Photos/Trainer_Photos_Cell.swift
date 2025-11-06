

import UIKit

class Trainer_Photos_Cell: UICollectionViewCell  {

    //MARK : Outlets and Variables
    
    @IBOutlet weak var trainer_Photos: UIImageView!
    @IBOutlet weak var photos_View: UIView!
    @IBOutlet weak var photos_View_Height: NSLayoutConstraint!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var deleteIcon: UIImageView!

    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photos_View.layer.cornerRadius = 7.0
    }

    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}
