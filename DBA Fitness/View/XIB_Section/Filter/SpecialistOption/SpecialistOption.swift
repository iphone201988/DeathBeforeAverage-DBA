
import UIKit

final class SpecialistOption: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var gradient: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.setShadow(shadowRadius: 5.0)
            let gradient = self.getGradientLayer(cornerRadius: 20)
            self.layer.insertSublayer(gradient, at: 0)
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
        titleLabel.attributedText = text
    }
    
}
