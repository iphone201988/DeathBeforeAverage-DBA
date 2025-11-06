
import UIKit
import MGSwipeTableCell

class Receiver_Chat_Cell: UITableViewCell {
    
    //MARK: Outlets & Variables
    
    @IBOutlet weak var message_View: UIView!
    @IBOutlet weak var message_Text: UILabel!
    @IBOutlet weak var message_Time: UILabel!
    @IBOutlet weak var attachmentImage: UIImageView!
    @IBOutlet weak var attachmentImageHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTop: NSLayoutConstraint!
    @IBOutlet weak var messageBottom: NSLayoutConstraint!
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var attachedButton: UIButton!
    
    //MARK: Controller's Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        message_Text.text = ""
        message_Time.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        self.message_View.layoutIfNeeded()
       self.message_View.roundCorners(topLeft: 30.0, topRight: 30.0, bottomLeft: 0.0, bottomRight: 30.0)
    }
    
}

