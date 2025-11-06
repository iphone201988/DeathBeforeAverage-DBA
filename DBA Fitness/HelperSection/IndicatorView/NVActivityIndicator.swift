
import Foundation
import UIKit
import NVActivityIndicatorView

class NVActivityIndicator:NSObject{
    
    static let managerHandler = NVActivityIndicator()
    
    // MARK:- Show indicator
    public func showIndicator() {
        DispatchQueue.main.async {
            let v = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60), type: .ballScaleMultiple, color: UIColor(named: "37b625"), padding: nil)
            let vi = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            vi.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            vi.tag = 998
            if let viewCenter = UIApplication.shared.keyWindow?.rootViewController?.view.center {
                vi.center = viewCenter
            }
            v.tag = 999
            v.center = vi.center
            v.startAnimating()
            vi.addSubview(v)
            UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(vi)
        }
    }
    
    // MARK:- Hide indicator
    public func stopIndicator() {
        DispatchQueue.main.async {
            if let subViews = UIApplication.shared.keyWindow?.rootViewController?.view.subviews {
                for v in subViews {
                    if v.tag == 998 {
                        v.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    // MARK:- Check animator loading
    public func isIndicatorVisible() -> Bool {
        guard
            let subViews = UIApplication.shared.keyWindow?.rootViewController?.view.subviews else { return false }
        for v in subViews {
            if v.tag == 999 {
                return true
            }
        }
        return false
    }
}
