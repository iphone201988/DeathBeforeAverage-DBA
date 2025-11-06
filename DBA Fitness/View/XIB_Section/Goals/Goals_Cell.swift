

import UIKit

class Goals_Cell: UITableViewCell  {

    //MARK : Outlets and Variables
    
    @IBOutlet weak var goals_View: UIView!
    @IBOutlet weak var goals_Text: UILabel!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        goals_View.layer.cornerRadius = 5.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}

