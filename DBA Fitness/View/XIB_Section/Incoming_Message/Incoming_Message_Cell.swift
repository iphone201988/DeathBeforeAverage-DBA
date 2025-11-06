
import UIKit
import MGSwipeTableCell

class Incoming_Message_Cell: UITableViewCell {
    
    //MARK: Outlets & Variables
    
    @IBOutlet weak var message_View: UIView!
    @IBOutlet weak var message_Text: UILabel!
    @IBOutlet weak var sender_Name: UILabel!
    @IBOutlet weak var message_badge: UILabel!
    @IBOutlet weak var sender_ImageView: UIView!
    @IBOutlet weak var sender_OnlineView: UIView!
    @IBOutlet weak var counter_View: UIView!
    @IBOutlet weak var sender_Pic: UIImageView!
    
    //MARK: Controller's Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        sender_ImageView.setViewCircle()
        sender_ImageView.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.53, radius: 6.5)
        sender_Pic.setRoundImage()
        sender_OnlineView.setViewCircle()
        counter_View.setViewCircle()
        counter_View.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 1, opacity: 0.34, radius: 1.5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        self.message_View.layoutIfNeeded()
        self.message_View.roundCorners(topLeft: 35.0, topRight: 35.0, bottomLeft: 0.0, bottomRight: 35.0)
    }
    
}

public extension UIView {
    func roundCorners1(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
