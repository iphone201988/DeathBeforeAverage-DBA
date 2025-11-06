

import UIKit
import MGSwipeTableCell

class Client_List_Cell: UITableViewCell {
    
    //MARK: Outlets & Variables
    
    @IBOutlet weak var pic_View: UIView!
    @IBOutlet weak var client_Pic: UIImageView!
    @IBOutlet weak var client_Name: UILabel!
    @IBOutlet weak var selection_Icon: UIImageView!
    
    //MARK: Controller's Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pic_View.setViewCircle()
        pic_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.53, radius: 6.5)
        client_Pic.setRoundImage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
