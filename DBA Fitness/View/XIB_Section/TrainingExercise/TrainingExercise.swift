
import UIKit
import MGSwipeTableCell

class TrainingExercise: MGSwipeTableCell {

    //MARK: Outlets & Variables
    
    @IBOutlet weak var days_View: UIView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseDesc: UILabel!
    
    //MARK: Controller's Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        days_View.layer.cornerRadius = 7.0
        exerciseName.text = ""
        exerciseDesc.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with text: String) {
          
          selectionStyle = .none
         // goals_Text.text = text
          rightSwipeSettings.buttonsDistance = 5
          rightSwipeSettings.bottomMargin = 5
          rightSwipeSettings.topMargin = 5
          rightSwipeSettings.offset = 8
      }
    
}
