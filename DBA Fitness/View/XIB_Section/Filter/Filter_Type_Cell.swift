
/*import UIKit

class Filter_Type_Cell: UICollectionViewCell  {

    //MARK : Outlets and Variables

    @IBOutlet weak var filter_TypeView: UIView!
    @IBOutlet weak var type_Name: UILabel!
    
    //MARK : Controller Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
  override func layoutSubviews() {
        filter_TypeView.layoutIfNeeded()
        filter_TypeView.customView(borderWidth:1, cornerRadius:20.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
    }
    
    //MARK : IB's Action
    
    
    //MARK: Helper's Method
    
}*/


import UIKit

final class Filter_Type_Cell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filter_TypeView: UIView!
    @IBOutlet weak var type_Name: UILabel!
    
    var gradient: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow(shadowRadius: 5.0)
        let gradient = getGradientLayer(cornerRadius: 20)
        layer.insertSublayer(gradient, at: 0)
        gradient.isHidden = true
        self.gradient = gradient
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradient?.frame = layer.bounds
    }
    
    override var isSelected: Bool {
        didSet {
            gradient?.isHidden = !isSelected
            layer.borderWidth = isSelected ? 0.0 : 1.0
        }
    }
    override var isHighlighted: Bool {
        didSet {
            gradient?.isHidden = !isHighlighted
            layer.borderWidth = isHighlighted ? 0.0 : 1.0
        }
    }
    
    func configure(with category: String) {
        var text = NSMutableAttributedString()
        text = text.append(category, 
                           font: UIFont(name: "Nunito-SemiBold", size: 15) ?? .systemFont(ofSize: 15),
                           textColor: UIColor.white)
        type_Name.attributedText = text
    }
    
}


