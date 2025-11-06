
import UIKit
import MGSwipeTableCell

class My_Achievement_Cell: MGSwipeTableCell  {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var achievements_View: UIView!
    @IBOutlet weak var trophy_View: UIView!
    @IBOutlet weak var numberOf_Certificate: UILabel!
    @IBOutlet weak var achievement_Year: UILabel!
    @IBOutlet weak var competition_Name: UILabel!
    @IBOutlet weak var juniors_Position: UITextField!
    @IBOutlet weak var weight_Position: UITextField!
    @IBOutlet weak var trophyIcon: UIImageView!
    @IBOutlet weak var aboutAchievement: UILabel!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        achievements_View.layer.cornerRadius = 7.0
        trophy_View.layer.cornerRadius = 4.0
        trophy_View.layer.borderWidth = 1.0
        trophy_View.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
     
        trophy_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        trophyIcon.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.3, radius: 5.5)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
    func configure() {
        selectionStyle = .none
        //  goals_Text.text = text
        rightSwipeSettings.buttonsDistance = 5
        rightSwipeSettings.bottomMargin = 5
        rightSwipeSettings.topMargin = 5
        rightSwipeSettings.offset = 8
    }
    
}

