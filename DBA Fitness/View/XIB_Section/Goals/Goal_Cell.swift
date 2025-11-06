import UIKit
import MGSwipeTableCell

class Goal_Cell: MGSwipeTableCell {

    //MARK: Outlets & Variables
    
    @IBOutlet weak var goals_View: UIView!
    @IBOutlet weak var goals_Text: UILabel!
    
    //MARK: Controller's Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        goals_View.layer.cornerRadius = 7.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
          
          selectionStyle = .none
          //goals_Text.text = text
          rightSwipeSettings.buttonsDistance = 5
          rightSwipeSettings.bottomMargin = 5
          rightSwipeSettings.topMargin = 5
          rightSwipeSettings.offset = 8
      }
    
}
