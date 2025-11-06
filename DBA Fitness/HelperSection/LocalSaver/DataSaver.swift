
import Foundation
import UIKit
import CoreLocation

class DataSaver : NSObject{
    static let dataSaverManager = DataSaver()
    
    private override init() {  }
    private let defaultObj = UserDefaults()
    
    func saveData(key:String, data:Any){
        defaultObj.set(data, forKey: key)
        defaultObj.synchronize()
    }
    
    func fetchData(key:String) -> Any {
        if let keyValue = defaultObj.value(forKey: key) {
            return keyValue
        } else {
            return ""
        }
    }
    
    func deleteData(key:String){
        defaultObj.removeObject(forKey: key)
        defaultObj.synchronize()
    }
    
}

