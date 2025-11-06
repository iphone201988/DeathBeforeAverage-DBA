
import UIKit
import MGSwipeTableCell

class Payment_Cards_Cell: MGSwipeTableCell  {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var card_View: GradientView!
    @IBOutlet weak var pair1: UILabel!
    @IBOutlet weak var pair2: UILabel!
    @IBOutlet weak var pair3: UILabel!
    @IBOutlet weak var pair4: UILabel!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var holderName: UILabel!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        card_View.layer.cornerRadius = 15.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
    func configure() {
        
        selectionStyle = .none
        // goals_Text.text = text
        rightSwipeSettings.buttonsDistance = 5
        rightSwipeSettings.bottomMargin = 5
        rightSwipeSettings.topMargin = 5
        rightSwipeSettings.offset = 8
    }
}

