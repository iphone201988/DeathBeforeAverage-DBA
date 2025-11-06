
import Foundation
import UIKit

extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){
        
        self.init()
        
        let path = CGMutablePath()
        
        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        
        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x, y: topRight.y))
        }
        
        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        }
        
        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        }
        
        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y))
        }
        
        path.closeSubpath()
        cgPath = path
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIView{
    
    func gradientBackground(from color1: UIColor, to color2: UIColor, direction: GradientDirection) {
        let gradient = CAGradientLayer()
        self.removeGradient()
        gradient.frame = self.bounds
        gradient.locations = [0.0, 1.0]
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.cornerRadius = self.layer.cornerRadius
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        default:
            break
        }
        // self.layer.addSublayer(gradient)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    //    func removeGradient() {
    //        DispatchQueue.main.async {
    //            self.removeGradient()
    //        }
    //    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func navigationBarViewShadow(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.layer.shadowColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 2.0
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
    }
    
    func customViewShadow(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.layer.shadowColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
        self.layer.shadowOffset = CGSize(width: -2, height: 2)
        self.layer.shadowOpacity = 2.0
        self.layer.shadowRadius = 2.0
        self.layer.masksToBounds = false
    }
    
    func viewUpdatedShadow(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.layer.shadowColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)   // 1
        self.layer.shadowOpacity = 0.65   // 0.4
        self.layer.shadowRadius = 7.0   // 4.0
        self.layer.masksToBounds = false
    }
    
    func customViewsShadow(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat, width: Int, height: Int, opacity: Float, radius:CGFloat) {
        self.layer.shadowColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func messageViewShadow(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.layer.shadowColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
        self.layer.shadowOffset = CGSize(width: 6, height: 6)
        self.layer.shadowOpacity = 6.0
        self.layer.shadowRadius = 6.0
        self.layer.masksToBounds = false
    }
    
    func  setViewCircle(){
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.clipsToBounds = true
    }
    
    func setViewCorners(width: Float) {
        // Setting of Corner
        DispatchQueue.main.async {
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight , .bottomLeft], cornerRadii: CGSize(width: Int(width), height: 0)).cgPath
            self.layer.mask = rectShape
        }
    }
    
    func customView(borderWidth:CGFloat, cornerRadius:CGFloat,red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {//(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    
    func setViewBorder(border: CGFloat)
    {
        // Setting of Border Width
        self.layer.borderWidth = border
    }
    func setViewCornerRadius(cornerR: CGFloat)
    {
        // Setting of Border Radius
        self.layer.cornerRadius = cornerR
    }
    
    func setViewBorderColor(red: CGFloat, green:CGFloat, blue:CGFloat)
    {
        // Setting of Border Color
        self.layer.borderColor = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).cgColor
    }
    
    func image() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        } else {
            return UIImage()
        }

    }
    
}

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        //  dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func UTCToLocal(withFormat format: String = "yyyy-MM-dd HH:mm:ss", convertedFormat:String = "MMM d, yyyy, h:mm a")-> String? {
        var toFormat = convertedFormat
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        //  dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self) ?? Date()
        
        let UTC_Liked_Date = dateFormatter.string(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: UTC_Liked_Date) ?? Date()
        dateFormatter.timeZone = TimeZone.current
        toFormat = convertedFormat//"MMM d, yyyy, h:mm a"//"MMM d, HH:mm"
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: dt)
    }
    
}

extension UIButton {
    func  setButtonBezierCorners(width: Int ,height : Int)
    {
        // Setting of Corner
        let path =  UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft,.bottomRight], cornerRadii: CGSize(width: width, height:height))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    func  setCircle()
    {
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.clipsToBounds = true
    }
    func circleShadow(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.layer.shadowColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.28
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
    }
    func setButtonBorder(border: CGFloat)
    {
        // Setting of Border Width
        self.layer.borderWidth = border
    }
    func setButtonBorderColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.layer.borderColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
    }
    
}

// Mark: Defination of Alert Message
func  setAlertMessage(msg: String)
{
    let alert = UIAlertController(title: "Message", message: msg, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    //self.present(alert, animated: true, completion: nil)
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil) // this make globaly alert
}

extension UIImageView{
    func  setRoundImage()
    {
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.clipsToBounds = true
    }
    func setImageBorder(border: CGFloat)
    {
        // Setting of Border Width
        self.layer.borderWidth = border
    }
    func setImageBorderColor(red: CGFloat, green:CGFloat, blue:CGFloat)
    {
        // Setting of Border Color
        self.layer.borderColor = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).cgColor
    }
    
    func imageViewShadow(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.layer.shadowColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.5  //0.4
        self.layer.shadowRadius = 6.0//4.0
        self.layer.masksToBounds = false
    }
    
    func customImageViewShadow(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat, width: Int, height: Int, opacity: Float, radius:CGFloat) {
        self.layer.shadowColor = UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
}

extension UILabel{
    func  setRoundLabel()
    {
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.clipsToBounds = true
    }
}

extension UIViewController {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.topAnchor
        } else {
            return topLayoutGuide.bottomAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomLayoutGuide.topAnchor
        }
    }
    
    var compatibleSafeInsets: UIEdgeInsets {
        if #available(iOS 11, *) {
            return view.safeAreaInsets
        } else {
            return UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        }
    }
    
}

extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String {
#if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "\(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
#elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "\(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
#endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}

extension UITableView
{
    func hideScrollingIndicators()  {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    func registerCellFromNib(cellID:String)
    {
        self.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    func removeBottomLine( )
    {
        self.separatorStyle = .none
        
    }
    
}

extension UINavigationController {
    func backToViewController(viewController: Swift.AnyClass) {
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}

extension UITextView{
    func handleKeyboardActivity() {
        self.resignFirstResponder()
        self.inputView = nil
        self.keyboardType = .default
        self.reloadInputViews()
    }
    func keyBoardBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        // toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.doneButtonAction))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelButtonAction))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([doneButton,spaceButton,cancelButton ], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    @objc func doneButtonAction(){
        endEditing(true)
    }
    @objc func cancelButtonAction(){
        endEditing(true)
    }
    
}

extension UITextField {
    func handleKeyboardActivity()
    {
        self.resignFirstResponder()
        self.inputView = nil
        self.keyboardType = .default
        self.reloadInputViews()
    }
    func keyBoardBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        // toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.doneButtonAction))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelButtonAction))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([doneButton,spaceButton,cancelButton ], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    @objc func doneButtonAction(){
        endEditing(true)
    }
    @objc func cancelButtonAction(){
        endEditing(true)
    }
    
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.2),
            NSAttributedString.Key.font: self.font ?? .systemFont(ofSize: 15.0)
        ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributeString)
    }
}

extension String {
    
    func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var isEmail: Bool {
        return checkRegEx(for: self, regEx: "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$")
    }

    func validateEnteredSetsAndResps() -> Bool {
        return self.range(of: ".*[^0-9-].*", options: .regularExpression) == nil
    }
    
    // MARK: - Private Methods
    private func checkRegEx(for string: String, regEx: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: string)
    }
}

extension UIPageControl {
    
    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
}

//MARK: Set Google Maker's Icon and User Image

func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    //image.draw(in: CGRectMake(0, 0, newSize.width, newSize.height))
    image.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
    if let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
        UIGraphicsEndImageContext()
        return newImage
    } else {
        return UIImage()
    }
}


func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {
    let imgView = UIImageView(image: image)
    let picImgView = UIImageView(image: pp)
    imgView.frame = CGRect(x: 0, y: 0, width: 55.0, height: 55.0)
    picImgView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
    imgView.addSubview(picImgView)
    picImgView.center.x = imgView.center.x
    picImgView.center.y = imgView.center.y - 9
    picImgView.layer.cornerRadius = picImgView.frame.width/2
    picImgView.clipsToBounds = true
    imgView.setNeedsLayout()
    picImgView.setNeedsLayout()
    let newImage = imageWithView(view: imgView)
    return newImage
}

func imageWithView(view: UIView) -> UIImage {
    var image: UIImage?
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
    if let context = UIGraphicsGetCurrentContext() {
        view.layer.render(in: context)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    return image ?? UIImage()
}

extension Date {
    func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: self) ?? Date()
    }
    func addDay(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: n, to: self) ?? Date()
    }
    func addSec(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: n, to: self) ?? Date()
    }
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}

typealias UnixTime = Int

extension UnixTime {
    private func formatType(form: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = form
        return dateFormatter
    }
    var dateFull: Date {
        return Date(timeIntervalSince1970: Double(self))
    }
    // formatType(form: "d MMM yyyy, HH:mm a").string(from: dateFull)
    var toHour: String {
        return formatType(form: "HH:mm a").string(from: dateFull)
    }
    var toDay: String {
        return formatType(form: "d MMM yyyy, HH:mm a").string(from: dateFull)
        //return formatType(form: "MM/dd/yyyy").string(from: dateFull)
    }
    var toDayShort: String {
        return formatType(form: "d MMM yyyy").string(from: dateFull)
        //return formatType(form: "MM/dd/yyyy").string(from: dateFull)
    }
}


//TODO: String
extension String{
    
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
    
    func encodeUrl() -> String?
    {
        //let str = Data(str.utf8).base64EncodedString()
        
        let str = self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
        return Data(str.utf8).base64EncodedString()
        //self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
    //  func URLEncodedString() -> String?
    //  {
    //    var escapedString = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) return escapedString } static func queryStringFromParameters(parameters: Dictionary<String,String>) -> String? { if (parameters.count == 0) { return nil } var queryString : String? = nil for (key, value) in parameters { if let encodedKey = key.URLEncodedString() { if let encodedValue = value.URLEncodedString() { if queryString == nil { queryString = "?" } else { queryString! += "&" } queryString! += encodedKey + "=" + encodedValue } } } return queryString
    //
    //    }
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        
        //let str = self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        let unreserved = "*-._"
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: unreserved)
        allowed.insert(charactersIn: " ")
        
        
        var encoded = self.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
        encoded = encoded.replacingOccurrences(of: " ", with: "+")
        //    let percentencoding = str?.replacingOccurrences(of: "+", with: "%20")
        return Data(encoded.utf8).base64EncodedString()
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        
        guard let data = Data(base64Encoded: self) else {
            return "String not valid"
        }
        let str = String(data: data, encoding: .utf8)
        let decoded = str?.replacingOccurrences(of: "+", with: " ")
        let string = decoded?.removingPercentEncoding
        let trimmed = string?.trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed
        //return string!
    }
    
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))) ?? Date()
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()) ?? Date()
    }
    
    func monthAsString() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM, YYYY")
        return df.string(from: self)
    }
}

extension UITextField {
    
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}

extension UITextView {
    
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}


extension UIView {
    
    func applyGradientLayer(cornerRadius: CGFloat, colours: [UIColor] = [#colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)]) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.type = .axial
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = [0.0, 1.0]
        gradient.cornerRadius = cornerRadius
        layer.insertSublayer(gradient, at: 0)
        
    }
    
    func getGradientLayer(cornerRadius: CGFloat, colours: [UIColor] = [#colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)]) -> CAGradientLayer {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.type = .axial
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = [0.0, 1.0]
        gradient.cornerRadius = cornerRadius
        layer.insertSublayer(gradient, at: 0)
        
        return gradient
    }
    
    func removeGradient() {
        layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
}

extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        set { layer.borderColor = newValue?.cgColor }
        get { return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor ?? UIColor.gray.cgColor) : nil }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
        get { return layer.shadowRadius }
    }
    
    @IBInspectable var shadowOpacity: Float {
        
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
        get { return layer.shadowOpacity }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        
        set {
            layer.masksToBounds = false
            layer.shadowColor = newValue?.cgColor
        }
        get { return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor ?? UIColor.gray.cgColor) : nil }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
        get { return layer.shadowOffset }
    }
    
    func setShadow(shadowRadius: CGFloat = 5.0, shadowColor: UIColor = .black, shadowOpacity: Float = 0.2, shadowOffset: CGSize = .zero) {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
    }
}

extension NSMutableAttributedString {
    
    @discardableResult
    func append(_ text: String,
                font: UIFont = UIFont.systemFont(ofSize: 16.0),
                textColor color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), kern: CGFloat = 0) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .kern: kern]
        let string = NSMutableAttributedString(string: "\(text)", attributes: attrs)
        append(string)
        return self
    }
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func compressedImages() -> UIImage? {
        let myImage = self.resizeWithWidth(width: self.size.width) //300 self.size.width
        let compressData = myImage?.jpegData(compressionQuality: 0.5) //max value is 1.0 and minimum is 0.0
        guard let compressData else { return UIImage() }
        return UIImage(data: compressData)
    }
}


extension Dictionary {
    public  func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension UIViewController{
    func customModalPopUp(storyBoard: UIStoryboard, controllerIndentifier:String){
        let popup = storyBoard.instantiateViewController(withIdentifier: controllerIndentifier)
        let navigationController = UINavigationController(rootViewController: popup)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
        navigationController.setNavigationBarHidden(true, animated: true)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func customModalPopUpWithData(navigatedVC:UIViewController){
        let navigationController = UINavigationController(rootViewController: navigatedVC)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
        navigationController.setNavigationBarHidden(true, animated: true)
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension UITextField {
    
    func modifyClearButtonWithImage(image : UIImage? = #imageLiteral(resourceName: "cancel")) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        clearButton.contentMode = .scaleAspectFit
        // clearButton.addTarget(self, action: #selector(UITextField.clear(_:)), forControlEvents: .TouchUpInside)
        clearButton.addTarget(self, action: #selector(clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
        
    }
    
    @objc func clear(sender : AnyObject) {
        self.text = ""
    }
    
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
    
    func toString() -> String {
        return String(format: "%.1f",self)
    }
    
    func toInt() -> Int{
        var temp:Int64 = Int64(self)
        return Int(temp)
    }
}

extension URL{
    func isImageURL()->Bool{
        let imageExtensions = ["png", "jpg", "gif", "jpeg","JPG"]
        // Iterate & match the URL objects from your checking results
        // let url: URL? = NSURL(fileURLWithPath: self) as URL
        let pathExtention = self.pathExtension
        if imageExtensions.contains(pathExtention){
            return true
        }else{
            return false
        }
    }
}

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass,
                             animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }else{
            popViewController(animated: false)
        }
    }
}

extension UITextField {

    func addInputViewDatePicker(_ target: Any, _ selector: Selector, _ maximumLimit: Date? = nil) {
        let screenWidth = UIScreen.main.bounds.width
        // Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        if let maxLimit = maximumLimit { datePicker.maximumDate = maxLimit }
        self.inputView = datePicker
        // Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        self.inputAccessoryView = toolBar
    }

    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
    
    func calculateDetailedAge(from dateOfBirth: Date, to currentDate: Date = Date()) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: dateOfBirth, to: currentDate)
        let years = components.year ?? 0
        let months = components.month ?? 0
        let days = components.day ?? 0
        let stringFormatted = "\(years)"//"\(years) years \(months)m \(days)d"
        self.text = stringFormatted
    }
}
