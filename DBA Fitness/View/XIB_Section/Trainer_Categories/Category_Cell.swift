
import UIKit

class Category_Cell: UITableViewCell  {

    //MARK : Outlets and Variables
    
    @IBOutlet weak var category_Name: UILabel!
    @IBOutlet weak var isSelect_Category: UIImageView!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}

