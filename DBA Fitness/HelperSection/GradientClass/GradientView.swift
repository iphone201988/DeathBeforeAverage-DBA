
import Foundation
import UIKit

final class GradientView: UIView {
    
    // MARK: - Property
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 0.75)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 0.75)
    
    
    var startPoint = CGPoint(x: 0.0, y: 1.0)
    var endPoint = CGPoint(x: 1.0, y: 1.0)
    
    
    // MARK: - Private property
    
    private lazy var gradientLayer: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = layer.bounds
        
        return gradientLayer
    }()
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = layer.bounds
        
    }
    
    private func initialSetup() {
        clipsToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
    }
}


final class GradientView_Send: UIView {
    
    // MARK: - Property
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 0.75)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 0.75)
    
    var startPoint = CGPoint(x: 0.0, y: 0.0)
    var endPoint = CGPoint(x: 1.0, y: 1.0)
    
    
    // MARK: - Private property
    
    private lazy var gradientLayer: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = layer.bounds
        
        return gradientLayer
    }()
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = layer.bounds
        
    }
    
    private func initialSetup() {
        clipsToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

final class GradientView2: UIView {
    
    // MARK: - Property
    
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1.0)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1.0)
    
    var startPoint = CGPoint(x: 0.0, y: 0.0)
    var endPoint = CGPoint(x: 1.0, y: 1.0)
    
    
    // MARK: - Private property
    
    private lazy var gradientLayer: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = layer.bounds
        
        return gradientLayer
    }()
    
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = layer.bounds
        
    }
    
    private func initialSetup() {
        clipsToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
