

import UIKit

class Trainer_Specs_Cell: UICollectionViewCell  {

    //MARK : Outlets and Variables
    
    @IBOutlet weak var specs_View: UIView!
    @IBOutlet weak var specs_Title: UILabel!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        specs_View.layer.cornerRadius = 3.0
    }

    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}

