
import UIKit
import MGSwipeTableCell

class Location_Cell: UITableViewCell {

    //MARK: Outlets & Variables
    @IBOutlet weak var searchedLocation: UILabel!
    
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
