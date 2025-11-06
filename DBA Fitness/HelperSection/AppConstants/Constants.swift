
import  UIKit
import Foundation
import FacebookLogin
import FBSDKLoginKit

struct Constants {
    static let termsURLPath = "https://google.com"
    static let privacyURLPath = "https://google.com"
    static let maxProgramPrice: Double = 10000000
    static let maxUploadImageSize = CGSize(width: 1024, height: 1024)
    static let agreement_Text = "By signing up you agree to our Privacy Policy and Terms and Conditions"
    static let isTrainer_Client = ""
    static let addGoals = "ADD GOALS"
    static let updateEditProgress = "updateEditProgress"
    static let updateDeleteAchievement = "updateDeleteAchievement"
    static let updateEditGoals = "updateEditGoals"
    static let searchTrainer = "Search Selected Trainer"
    static let updateGallery = "Update Gallery"
    static let removeView = "Remove View"
    static var selectedRoleType = ""
    static var isUpdatedPosts = "isUpdatedPosts"
    static var isUpdatedProfile = "isUpdatedProfile"
    static var cardsDetails = "cardsDetails"
    static var isEditCard = ""
    static var isEditAbout = ""
    static var isEditAnthropometric = ""
    static var currentTab = "1"
    static var selectedCurrentFeedTab = "1"
    static var getProgramsDetails = "getProgramsDetails"
    static var performActionAccordingToPushNotificationTypeWhenAppIsKill = "performActionAccordingToPushNotificationType"
    static var isEditProgram = ""
    static var navigateToSetting = ""
    static var profileData = "profileData"
    static var searchGender = ""
    static var searchIsCertifiate = ""
    static var searchSpecialist = ""
    static var searchLocation = "" 
    static var selectedMealDay = ""
    static var isAddMeal = ""
    static var isEditGoal = ""
    static var isMessageTab = ""
    static var isSelectedPhotos = ""
    static var isCertificatePic = ""
    static var selectedAchievementIndex = Int()
    static var isRatingTrainers = ""
    static var isBackground = "Notify app in background"
    static var stopUploadingDuetoBackground = ""
    static var isSearchedTrainerAchievement = "0"
    static var getCataglogueDetails = "getCataglogueDetails"
    static var backFromLoggedUserGallerySelection = "backFromLoggedUserGallerySelection"
    static var selectedGalleryPhotoAssociatedPostID = ""
    static var loginknowAboutAccountVerifyStatus = "loginknowAboutAccountVerifyStatus"
    static var signUpknowAboutAccountVerifyStatus = "signUpknowAboutAccountVerifyStatus"
    static var populateProfileDataForEdit = "populateProfileDataForEdit"
    static var strRepSenderID = ""
    static var strRepSenderName = ""
    static var strRepUserID = ""
    static var strRepPostID = ""
    static var stripeAccountRedirectURL = "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_LfR9IK0EiIkoZUEupwyMzCHsdymekSn1&scope=read_write&stripe_user[email]="
}

let loginManager = LoginManager()
var actionSheetController:UIAlertController?
var mediaUrl:URL?
var imageData = Data()
var isTrainer = String()
var uploadingFlag = true
var data: Data?
var reducedUploadingImage:UIImage?
var categoryArrayIndex:Int?

var trainerNavigateViaSentProgramsList: Bool?
