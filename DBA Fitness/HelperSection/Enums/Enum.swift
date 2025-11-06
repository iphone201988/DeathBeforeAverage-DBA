
import Foundation
import UIKit

//MARK: - UIAlert action sheet title
enum ActionSheetLabel: String {
    case camera = "Camera"
    case photoLibrary = "Album"
    case cancel = "Cancel"
}

enum ValidationError: Error {
    
    case empty(_: ValidatableAttribute)
    case invalid(_: ValidatableAttribute)
    case invalidWithReason(_: ValidatableAttribute, reason: String)
    case isMatch(_: ValidatableAttribute, ValidatableAttribute)
    case isNotMatch(_: ValidatableAttribute, ValidatableAttribute)
    case Mandtory(_: ValidatableAttribute)
    case Mandtory1(reason: String)
    var message: String {
        
        switch self {
        case .empty(let attribute):
            return "\(attribute.name) cannot be empty"
        case .invalid(let attribute):
            return "Invalid \(attribute.name) or format is incorrect"
        case .invalidWithReason(let attribute, let reason):
            return "Invalid \(attribute.name). \(reason)"
        case .isMatch(let firstAttribute, let secondAttribute):
            return "\(firstAttribute.name), \(secondAttribute.name)"
        case .isNotMatch(let firstAttribute, let secondAttribute):
            return ("Password mismatch")//"\(firstAttribute.name) and \(secondAttribute.name) is not matched"
        case .Mandtory(let attribute):
            return "Mandatory field has not populated - \(attribute.name)"
        case .Mandtory1(let reason):
            return "\(reason)"
        }
    }
}

protocol ValidatableAttribute {
    var name: String { get }
}


enum UserValidatableAttribute: String, ValidatableAttribute {
    
    case FirstName
    case LastName
    case Email
    case confirmEmail
    case Password
    case ConfirmPassword
    case specialisations
    case Location
    case Options
    
    var name: String {
        return self.rawValue
    }
}

enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}


enum AppStoryboard : String {
    case Onboarding = "Onboarding"
    case Gallery_Section = "Gallery_Section"
    case Auth = "Auth"
    case Trainer_Post_Section = "Trainer_Post_Section"
    case Trainer_Program = "Trainer_Program"
    case Trainer_Training = "Trainer_Training"
    case Trainer_Nutrition = "Trainer_Nutrition"
    case Trainer_Setting = "Trainer_Setting"
    case Trainer_Tabbar = "Trainer_Tabbar"
    case Client_Tabbar = "Client_Tabbar"
    case Client_Search = "Client_Search"
    case Client_Progress = "Client_Progress"
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

enum Onboarding: String{
    case Choose_Role = "Choose_Role"
    case Trainer_SignUp = "Trainer_SignUp"
    case Client_SignUp = "Client_SignUp"
    case Trainer_About = "Trainer_About"
    case Trainer_Anthropometric = "Trainer_Anthropometric"
    case Client_Goals = "Client_Goals"
    case Add_Goals = "Add_Goals"
}

enum Gallery_Section: String{
    case Choose_Role = "Choose_Role"
}

enum Auth: String{
    case Login = "Login"
    case Sign_Up = "Sign_Up"
    case Forgot = "Forgot"
}

enum Trainer_Post_Section: String{
    case Trainer_Add_Posts = "Trainer_Add_Posts"
    case Trainer_Post_Details = "Trainer_Post_Details"
    case Trainer_Edit_Post = "Trainer_Edit_Post"
}

enum Trainer_Program: String{
    case Trainer_Add_Program = "Trainer_Add_Program"
    case Trainer_Program_Details = "Trainer_Program_Details"
    case Trainer_Edit_Program = "Trainer_Edit_Program"
    case Send_Program_Client = "Send_Program_Client"
}

enum Trainer_Training: String{
    case Trainer_Training_Section = "Trainer_Training_Section"
    case Trainer_Add_Training = "Trainer_Add_Training"
    case Trainer_Training_View = "Trainer_Training_View"
}

enum Trainer_Nutrition: String{
    case Trainer_Nutrition_Schedule = "Trainer_Nutrition_Schedule"
    case Trainer_Meal_View = "Trainer_Meal_View"
    case Trainer_Meal_Details = "Trainer_Meal_Details"
    case Trainer_Add_Meal = "Trainer_Add_Meal"
    case Trainer_Meal_Paster = "Trainer_Meal_Paster"
}

enum Trainer_Setting: String{
    case Settings = "Settings"
    case Edit_Trainer_Profile = "Edit_Trainer_Profile"
    case Edit_Trainer_About = "Edit_Trainer_About"
    case Edit_Trainer_Anthropometric = "Edit_Trainer_Anthropometric"
    case Trainer_PaymentCards = "Trainer_PaymentCards"
    case Add_Trainer_PaymentCards = "Add_Trainer_PaymentCards"
    case Upgrade_Subscription = "Upgrade_Subscription"
}

enum Trainer_Tabbar: String{
    case Trainer_Bar = "Trainer_Bar"
    case Trainer_Post_View = "Trainer_Post_View"
    case Trainer_Exercise_Programs = "Trainer_Exercise_Programs"
    case Incoming_Messages = "Incoming_Messages"
    case Trainer_Profile_View = "Trainer_Profile_View"
    case Trainer_Add_Exercise = "Trainer_Add_Exercise"
    case Trainer_Add_Supplement = "Trainer_Add_Supplement"
    case Chat_VC = "Chat_VC"
    case Trainer_Achievement = "Trainer_Achievement"
    case Trainer_Add_Achievement = "Trainer_Add_Achievement"
    case Trainer_Edit_Achievement = "Trainer_Edit_Achievement"
    case Trainer_s_Clients = "Trainer_s_Clients"
    case NotificationLists = "NotificationLists"
}

enum Client_Tabbar: String{
    case Client_Bar = "Client_Bar"
}

enum Role: String{
    case incomplete = "0"
    case client = "2"
    case trainer = "1"
}

public enum Sex: String, CaseIterable {
    
    case none = "Not Set"
    case male = "Male"
    case female = "Female"
    case other = "Other"
    
    var value: String {
        
        switch self {
        case .none:
            return ""
        case .male, .female, .other:
            return self.rawValue
        }
    }
    
    var formattedString: String {
        
        switch self {
        case .none:
            return ""
        case .male:
            return "♂\(self.rawValue)"
        case .female:
            return "♀\(self.rawValue)"
        case .other:
            return "⚥\(self.rawValue)"
        }
    }
}

enum SignUpType: String{
    case normalSignUp
    case appleSignUp
    case facebookSignUp
}

enum RatingAndCommentsFetchingType: Int {
    /* by backend:
     type:1 - joh humey rating mili hai
     type:2 - joh humney rating ki hai
     */
    case ratingCommentGivenToLoggedUser = 1
    case ratingCommentGivenByLoggedUser = 2
    case ratingCommentGivenByMeIncludedAnotherToParticularUser = 3
}
