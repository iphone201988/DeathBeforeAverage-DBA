
import UIKit
import MGSwipeTableCell

class Setting_Cell: UITableViewCell {

    //MARK: Outlets & Variables
    
    @IBOutlet weak var menu_Name: UITextField!
    @IBOutlet weak var menu_Icon: UIImageView!
    @IBOutlet weak var underline_View: UIView!
    @IBOutlet weak var switch_Button: UISwitch!
    
    //MARK: Controller's Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    
}
