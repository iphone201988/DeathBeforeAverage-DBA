
import UIKit

class Days_Cell: UICollectionViewCell  {

    //MARK : Outlets and Variables
    
    @IBOutlet weak var days_View: GradientView!
    @IBOutlet weak var days_Name: UILabel!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
     days_View.layer.cornerRadius = 3.0
    }

    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}

