

import UIKit
import MGSwipeTableCell

class Client_Progress: MGSwipeTableCell {
    
    //MARK: Outlets & Variables
    @IBOutlet weak var days_View: UIView!
    @IBOutlet weak var days_Text: UILabel!
    @IBOutlet weak var time_View: UIView!
    @IBOutlet weak var time_Text: UILabel!
    @IBOutlet weak var dateTimeStampViewHeight: NSLayoutConstraint!
    
    
    //MARK: Controller's Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        days_View.layer.cornerRadius = 4.0
        time_View.customView(borderWidth:1.0, cornerRadius:3.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
        time_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure() {
        
        selectionStyle = .none
        // goals_Text.text = text
        rightSwipeSettings.buttonsDistance = 5
        rightSwipeSettings.bottomMargin = 5
        rightSwipeSettings.topMargin = 5
        rightSwipeSettings.offset = 8
    }
    
}
