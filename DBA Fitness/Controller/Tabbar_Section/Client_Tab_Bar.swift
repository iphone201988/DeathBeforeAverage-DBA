

import UIKit

class Client_Tab_Bar: UITabBarController, UITabBarControllerDelegate{
    
    //MARK: Outlets & Variables
    var count = 0
    var notificationTabItemImage: UIImageView!
    var secondItemImageView: UIImageView!
    
    // Mark:- Delegate Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        let modelName = UIDevice.modelName
        
        /*  if (modelName == "iPhone X" || modelName == "iPhone XS" || modelName == "iPhone XS Max" || modelName == "iPhone XR") {
         tabbarControllerItem_Setting_X(topOffset: 10.0,bottomOffset: -10.0, horizontal: 0.0,vertical: 10.0)
         }
         else {
         tabbarControllerItem_Setting_X(topOffset: 0.0,bottomOffset: 0.0, horizontal: 0.0,vertical: -3.0)
         }*/
    }
    
    func tabbarControllerItem_Setting_X(topOffset: CGFloat,bottomOffset: CGFloat,horizontal:CGFloat,vertical:CGFloat){
        if let items = self.tabBar.items {
            for item in items.enumerated() {
                if item.offset == 0{
                    item.element.titlePositionAdjustment = UIOffset(horizontal: horizontal, vertical: vertical)
                    item.element.imageInsets = UIEdgeInsets(top: topOffset, left: 0, bottom: bottomOffset, right: 0);
                    item.element.image = UIImage(named: "programTabIcon")
                    item.element.title = ""
                }
                else if item.offset == 1{
                    item.element.titlePositionAdjustment = UIOffset(horizontal: horizontal, vertical: vertical)
                    item.element.imageInsets = UIEdgeInsets(top: topOffset, left: 0, bottom: bottomOffset, right: 0);
                    item.element.image = UIImage(named: "programTabIcon")
                    item.element.title = ""
                }
                else if item.offset == 2{
                    item.element.titlePositionAdjustment = UIOffset(horizontal: horizontal, vertical: vertical)
                    item.element.imageInsets = UIEdgeInsets(top: topOffset, left: 0, bottom: bottomOffset, right: 0);
                    item.element.image = UIImage(named: "programTabIcon")
                    item.element.title = ""
                    
                }
                else if item.offset == 3{
                    item.element.titlePositionAdjustment = UIOffset(horizontal: horizontal, vertical: vertical)
                    item.element.imageInsets = UIEdgeInsets(top: topOffset, left: 0, bottom: bottomOffset, right: 0);
                    item.element.image = UIImage(named: "profileTabIcon")
                    item.element.title = ""
                }
                
            }
            let secondItemView = self.tabBar.subviews[2]
            if let imgView = secondItemView.subviews.first as? UIImageView {
                self.secondItemImageView = imgView
            }
            
            self.secondItemImageView.contentMode = .center
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.tabBarController?.tabBar.shadowImage = #imageLiteral(resourceName: "rateIcon")
        if let items = self.tabBar.items {
            for item in items.enumerated() {
                if item.offset == 0 {
                    self.selectedIndex = 0
                } else if item.offset == 1 {
                    self.selectedIndex = 0
                } else if item.offset == 2 {
                    self.selectedIndex = 0
                } else if item.offset == 3 {
                    self.selectedIndex = 0
                }
            }
        }
    }
}

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        //let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 1.0, height: 1.0))
        UIGraphicsBeginImageContext(rect.size)
        guard
            let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        } else {
            return UIImage()
        }
    }
}
