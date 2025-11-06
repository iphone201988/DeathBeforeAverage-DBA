
import UIKit
import MGSwipeTableCell

class Client_Program_Cell: MGSwipeTableCell {
    
    //MARK: Outlets & Variables
    
    @IBOutlet weak var programs_View: UIView!
    @IBOutlet weak var program_Name: UILabel!
    @IBOutlet weak var trainer_Specs_Collection: UICollectionView!
    @IBOutlet weak var image_View: UIView!
    @IBOutlet weak var purchaseIcon: UIImageView!
    @IBOutlet weak var markAction: UIButton!
    @IBOutlet weak var trainer_Pic: UIImageView!
    @IBOutlet weak var ratingIcon: UIImageView!
    @IBOutlet weak var emptyTags: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    //MARK: Controller's Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        programs_View.layer.cornerRadius = 7.0
        
        image_View.setViewCircle()
        image_View.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.53, radius: 6.5)
        trainer_Pic.setRoundImage()
        
        ratingIcon.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.3, radius: 5.5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configure() {
        selectionStyle = .none
        //  goals_Text.text = text
        rightSwipeSettings.buttonsDistance = 5
        rightSwipeSettings.bottomMargin = 5
        rightSwipeSettings.topMargin = 5
        rightSwipeSettings.offset = 8
    }
}


