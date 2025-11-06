
import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var currentPwdTF: UITextField!
    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var confirmPwdTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        let currentPwd = currentPwdTF.text?.trimmed()
        let newPwd = newPwdTF.text?.trimmed()
        let confirmPwd = confirmPwdTF.text?.trimmed()
        if let currentPwd, !currentPwd.isEmpty {
            if let newPwd, !newPwd.isEmpty {
                if let confirmPwd, !confirmPwd.isEmpty {
                    if newPwd == confirmPwd {
                        resetPassword(parameters:["oldPassword": currentPwd, "newPassword":newPwd] )
                    } else {
                        Toast.show(message: "Password doesn't match", controller: self)
                    }
                } else {
                    Toast.show(message: "Confirm password cannot be empty", controller: self)
                }
            } else {
                Toast.show(message: "New password cannot be empty", controller: self)
            }
        } else {
            Toast.show(message: "Current password cannot be empty", controller: self)
        }
    }
    
    fileprivate func resetPassword(parameters:[String :Any] ){
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            apimethod.commonMethod(url: ApiURLs.resetPassword,
                                   parameters: parameters, method: "POST") { (_ dict, _ success: Bool , _ error: Error?,_ response: Any, _ responseData) in
                NVActivityIndicator.managerHandler.stopIndicator()
                if success, let result = response as? HTTPURLResponse{
                    
                    if(result.statusCode == 404 || result.statusCode == 400 || result.statusCode == 401) {
                        if result.statusCode == 401 { logoutFromAPP() }
                        if result.statusCode == 400 {
                            Toast.show(message: "Please enter valid old password", controller: self)
                        }
                    }else if(result.statusCode == 204 || result.statusCode == 200 || result.statusCode == 201) {
                        DispatchQueue.main.async {
                            Toast.show(message: "Password reset successfully", controller: self)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else if(result.statusCode == 500) {
                        UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                    }
                }
            }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}
