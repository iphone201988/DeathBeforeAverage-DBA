
import Foundation
import Stripe

struct SignUpData {
    
    var email: String
    var password: String
    //var confirmPassword: String
    
    // init(with email: String, password: String, confirmPassword: String) throws {
    
    init(with email: String, password: String? = nil) throws {
        
        guard !email.isEmpty else {
            
            //throw ValidationError.empty(UserValidatableAttribute.Email)
            throw ValidationError.Mandtory1(reason: "Email cannot be empty")
        }
        guard email.isEmail else {
            throw ValidationError.Mandtory1(reason: "Enter a valid email")
            //throw ValidationError.invalid(UserValidatableAttribute.Email)
        }
        
        guard !(password?.isEmpty ?? false) else {
            throw ValidationError.Mandtory1(reason: "Password cannot be empty")
            //throw ValidationError.empty(UserValidatableAttribute.Password)
        }
        
        /* guard password.count >= 8 && password.count <= 24 else {
         
         throw ValidationError.invalid(UserValidatableAttribute.Password)
         }*/
        
        /*  guard !(confirmPassword?.isEmpty ?? true) else {
         throw ValidationError.Mandtory1(reason: "Confirm password cannot be empty")
         //throw ValidationError.empty(UserValidatableAttribute.ConfirmPassword)
         }
         
         guard password == confirmPassword else {
         throw ValidationError.isNotMatch(UserValidatableAttribute.Password, UserValidatableAttribute.ConfirmPassword)
         }*/
        
        self.email = email
        self.password = password ?? ""
        //self.confirmPassword = confirmPassword
    }
}

struct Trainer_SignUpData {
    
    var email: String
    var password: String
    //var confirmPassword: String
    var firstName: String
    var lastName: String
    var options:String
    
    //init(with firstName: String, lastName: String, email: String, options: String, password: String, confirmPassword: String) throws {
    
    init(with firstName: String? = "", lastName: String? = "", email: String? = nil, options: String, password: String? = nil ) throws {
        
        
        guard firstName != "" else{
            throw ValidationError.Mandtory1(reason: "First name cannot be empty")
        }
        
        guard lastName != "" else{
            throw ValidationError.Mandtory1(reason: "Last name cannot be empty")
        }
        
            guard email != "" else{
                throw ValidationError.Mandtory1(reason: "Email cannot be empty")
                //throw ValidationError.Mandtory(UserValidatableAttribute.Email)
            }
      
        if let emailField = email{
            guard emailField.isEmail else {
                throw ValidationError.Mandtory1(reason: "Enter a valid email")
                //throw ValidationError.invalid(UserValidatableAttribute.Email)
            }
        }
        
        
        guard !options.isEmpty else {
            throw ValidationError.Mandtory1(reason: "Choose atleast one interest")
        }
        
        guard password != "" else{
            throw ValidationError.Mandtory1(reason: "Password cannot be empty")
        }
        
        /* guard password.count >= 8 && password.count <= 24 else {
         
         throw ValidationError.invalid(UserValidatableAttribute.Password)
         }*/
        
        /*  guard !confirmPassword.isEmpty else {
         throw ValidationError.Mandtory1(reason: "Confirm password cannot be empty")
         //throw ValidationError.empty(UserValidatableAttribute.ConfirmPassword)
         }
         
         guard password == confirmPassword else {
         
         throw ValidationError.isNotMatch(UserValidatableAttribute.Password, UserValidatableAttribute.ConfirmPassword)
         }*/
        
        self.email = email ?? ""
        self.password = password ?? ""
        //self.confirmPassword = confirmPassword
        self.firstName = firstName ?? ""
        self.lastName = lastName ?? ""
        self.options = options
    }
}
