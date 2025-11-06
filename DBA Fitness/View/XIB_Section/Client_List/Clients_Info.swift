
import UIKit
import MGSwipeTableCell

class Clients_Info: MGSwipeTableCell {
    
    //MARK: Outlets & Variables
    
    @IBOutlet weak var pic_View: UIView!
    @IBOutlet weak var client_Pic: UIImageView!
    @IBOutlet weak var client_Name: UILabel!
    @IBOutlet weak var client_Age: UILabel!
    @IBOutlet weak var client_Loc: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var locationIconWidth: NSLayoutConstraint!
    @IBOutlet weak var didTapProfileButton: UIButton!
    @IBOutlet weak var deleteIconWidth: NSLayoutConstraint!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var deleteIconTrailing: NSLayoutConstraint!
    @IBOutlet weak var joinedDate: UILabel!
    @IBOutlet weak var viewSentProgramList: UIButton!
    @IBOutlet weak var viewSentProgramListMainView: UIView!
    @IBOutlet weak var viewSentProgramListMainViewHeight: NSLayoutConstraint!
    
    //MARK: Controller's Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        pic_View.setViewCircle()
         pic_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.53, radius: 6.5)
        client_Pic.setRoundImage()
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
        rightSwipeSettings.topMargin = 0
        rightSwipeSettings.offset = 8
    }
}

