
import UIKit
import MGSwipeTableCell

class Trainer_Trainings_Cell: MGSwipeTableCell  {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var training_Thumbnail: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var exerciseView: GradientView!
    @IBOutlet weak var training_Name: UILabel!
    @IBOutlet weak var training_Collection: UICollectionView!
    @IBOutlet weak var emptyTag: UILabel!
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var playVideo: UIButton!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.cornerRadius = 7.0
        exerciseView.layer.cornerRadius = 4.0
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

