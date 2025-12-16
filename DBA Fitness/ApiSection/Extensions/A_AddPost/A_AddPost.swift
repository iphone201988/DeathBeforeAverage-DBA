
import Foundation
import NVActivityIndicatorView
import UIKit
import Alamofire
import SDWebImage
import MobileCoreServices

extension UIViewController{
    
    func postUpdation(description:String,image:URL? = nil,video:URL? = nil, postID:String, Url:String,type:String){
        
        func basicAuth() -> String{
            let user = "whistle"
            let password = "!@#$%_whistle_)(*&^"
            let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8) ?? Data()
            let base64Credentials = credentialData.base64EncodedString(options: [])
            
            return base64Credentials
        }
        
        let sessionkey = DataSaver.dataSaverManager.fetchData(key: "sessionkey") as? String ?? ""
        let userid = DataSaver.dataSaverManager.fetchData(key: "userid") as? String ?? ""
        
        let APIheaders: HTTPHeaders = [
            "Accept": "application/x-www-form-urlencoded",
            "Content-Type" : "application/x-www-form-urlencoded",
            "Authorization" : "Basic \(basicAuth())",
            "sessionkey" : sessionkey,
            "userid" : userid,
        ]
        
        debugLog("Url \(Url) \(APIheaders)")
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            NVActivityIndicator.managerHandler.showIndicator()
            
            if image != nil{
                multipartFormData.append(image!, withName: "image")
            }
            
            if let video = video {
                let fileName = video.lastPathComponent // Keep original filename
                let mimeType = self.getMimeType(for: video)

                do {
                    let videoData = try Data(contentsOf: video)
                    multipartFormData.append(videoData, withName: "video", fileName: fileName, mimeType: mimeType)
                } catch {
                    debugLog("Error converting video to Data: \(error.localizedDescription)")
                }
            }
            
            if postID != ""{
                multipartFormData.append(postID.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"post_id")
            }
            
            multipartFormData.append(description.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"description")
            
            multipartFormData.append(type.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data(), withName :"upload_type")
            

        }, to:Url, method:.post, headers:APIheaders)
        { (result) in
            
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    
                    
                    
                    
                })
                upload.responseJSON { response in
                    
                    NVActivityIndicator.managerHandler.stopIndicator()
                    
                 
                    
                    if response.result.isSuccess{
                        guard let data = response.data else { return }
                        if postID != ""{
                            allPosts = try? JSONDecoder().decode(M_AllPosts.self, from: data)
                            particularPostInfo = allPosts?.data?.first
                        }
                        
                        NotificationCenter.default.post(name:NSNotification.Name(Constants.isUpdatedPosts), object:true)
                        self.navigationController?.popViewController(animated: true)
                        
                    }else{
                        
                        UniversalMethod.universalManager.alertMessage("Upload failed, try again.", self.navigationController)
                    }
                }
            case .failure(let error):
                UniversalMethod.universalManager.alertMessage("Error in upload: \(error.localizedDescription)", self.navigationController)
                
                
            }
        }
    }

    func getMimeType(for videoURL: URL) -> String {
        let ext = videoURL.pathExtension.lowercased() // Get file extension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext as CFString, nil)?.takeRetainedValue(),
           let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() as String? {
            return mimeType // Return detected MIME type
        }

        return "application/octet-stream" // Default fallback MIME type
    }

    
}

