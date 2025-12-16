
import UIKit
import Alamofire
import NVActivityIndicatorView


class Methods: NSObject {
    
    static let sharedInstance = Methods()
    
    //MARK: BasicAuth
    
    func basicAuth() -> String{
        let user = "whistle"
        let password = "!@#$%_whistle_)(*&^"
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8) ?? Data()
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        return base64Credentials
    }
    
    //MARK: POST Method
    
    // MARK- GIVEN TYPE METHOD
    
    func commonMethod(url:String,parameters: [String : Any] ,method: String, raw_json_data: Data? = nil , completion: @escaping (_ Dic: [String:Any]?,_ success: Bool, _ error:NSError?, _ response:AnyObject?,  _ responseData:Data) -> Void) {
        
        if method == "POST"{
            
            let sessionkey = DataSaver.dataSaverManager.fetchData(key: "sessionkey") as? String
            let userid = DataSaver.dataSaverManager.fetchData(key: "userid") as? String
            
            let APIheaders: HTTPHeaders = [
                "Accept": "application/x-www-form-urlencoded",
                "Content-Type" : "application/x-www-form-urlencoded",
                "Authorization" : "Basic \(self.basicAuth())",
                "sessionkey" : sessionkey ?? "",
                "userid" : userid ?? "",
            ]

            debugLog("APIheaders: \(APIheaders) and requestURL: \(url) and parameters: \(parameters)")

            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers:APIheaders ) //URLEncoding.httpBody
                .responseJSON { response in
                    // result of response serialization
                    let responseObject = response.response as Any
                    guard let data = response.data else { return }
                    if response.result.isSuccess {
                        let JSON1 = response.result.value as? [String : Any]
                        debugLog("JSON1: \(JSON1?["data"] ?? "")")
                        completion(JSON1 ,true,nil,responseObject as AnyObject, data)
                    }else{
                        if let error = response.result.error {
                            if error._code == NSURLErrorTimedOut {
                            }
                        }
                        let JSON1 = response.result.value as? [String : Any]
                        
                        
                        if let response = response.response{
                            if response.statusCode==400 || response.statusCode==401{
                                DispatchQueue.main.async {
                                    DataSaver.dataSaverManager.deleteData(key: "accessToken")
                                    DataSaver.dataSaverManager.deleteData(key: "Role")
                                    DataSaver.dataSaverManager.deleteData(key: "name")
                                    DataSaver.dataSaverManager.deleteData(key: "email")
                                    DataSaver.dataSaverManager.deleteData(key: "id")
                                    DataSaver.dataSaverManager.deleteData(key: "isComplete")
                                    DataSaver.dataSaverManager.deleteData(key: "programID")
                                    DataSaver.dataSaverManager.deleteData(key: "firstname")
                                    DataSaver.dataSaverManager.deleteData(key: "lastname")
                                    DataSaver.dataSaverManager.deleteData(key: "sessionkey")
                                    DataSaver.dataSaverManager.deleteData(key: "userid")
                                    DataSaver.dataSaverManager.deleteData(key: "userType")
                                    DataSaver.dataSaverManager.deleteData(key: "profilePic")
                                    DataSaver.dataSaverManager.deleteData(key: "isPrivate")
                                    DataSaver.dataSaverManager.deleteData(key: "selectedLoc")
                                    DataSaver.dataSaverManager.deleteData(key: "notification_alert")
                                    DataSaver.dataSaverManager.deleteData(key: "is_purchased")
                                    DataSaver.dataSaverManager.deleteData(key: "is_connected_stripe")
                                    UniversalMethod.universalManager.navigateToAuth()
                                }
                            }
                        }
                        completion(JSON1 ,false,nil,responseObject as AnyObject, data)
                    }
            }
        } else if method == "RAW_JSON" {
                let sessionkey = DataSaver.dataSaverManager.fetchData(key: "sessionkey") as? String ?? ""
                let userid = DataSaver.dataSaverManager.fetchData(key: "userid") as? String ?? ""
                
                let APIheaders: HTTPHeaders = [
                    "Accept": "application/x-www-form-urlencoded",
                    "Content-Type" : "application/x-www-form-urlencoded",
                    "Authorization" : "Basic \(self.basicAuth())",
                    "sessionkey" : sessionkey,
                    "userid" : userid,
                ]
                
            debugLog("APIheaders: \(APIheaders) and requestURL: \(url)")
            
            guard let requestURL = URL(string: url) else { return }
            var customURLRequest = URLRequest(url: requestURL)
            customURLRequest.httpMethod = "POST"
            customURLRequest.httpBody = raw_json_data
            customURLRequest.allHTTPHeaderFields = APIheaders

            Alamofire.request(customURLRequest)
                    .responseJSON { response in
                        let responseObject = response.response as Any
                        guard let data = response.data else { return }
                        if response.result.isSuccess{
                            let JSON1 = response.result.value as? [String : Any]
                            debugLog("JSON1: \(JSON1?["data"] ?? "")")
                            completion(JSON1 ,true,nil,responseObject as AnyObject, data)
                        }else{
                            if let error = response.result.error {
                                if error._code == NSURLErrorTimedOut {
                                }
                            }
                            let JSON1 = response.result.value as? [String : Any]
                            completion(JSON1 ,false,nil,responseObject as AnyObject, data)
                        }
                }
            
        } else {
            
            let sessionkey = DataSaver.dataSaverManager.fetchData(key: "sessionkey") as? String ?? ""
            let userid = DataSaver.dataSaverManager.fetchData(key: "userid") as? String ?? ""
            
            let APIheaders: HTTPHeaders = [
                "Accept": "application/x-www-form-urlencoded",
                "Content-Type" : "application/x-www-form-urlencoded",
                "Authorization" : "Basic \(self.basicAuth())",
                "sessionkey" : sessionkey,
                "userid" : userid,
            ]
            
            debugLog("APIheaders: \(APIheaders) and requestURL: \(url)")
            
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.httpBody, headers:APIheaders )
                .responseJSON { response in
                    
                    let responseObject = response.response as Any
                    guard let data = response.data else { return }
                    if response.result.isSuccess{
                        let JSON1 = response.result.value as? [String : Any]
                        debugLog("JSON1: \(JSON1?["data"] ?? "")")
                        completion(JSON1 ,true,nil,responseObject as AnyObject, data)
                    }else{
                        if let error = response.result.error {
                            if error._code == NSURLErrorTimedOut {
                            }
                        }
                        let JSON1 = response.result.value as? [String : Any]
                        completion(JSON1 ,false,nil,responseObject as AnyObject, data)
                    }
            }
        }
    }
}
