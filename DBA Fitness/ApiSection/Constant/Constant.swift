
import Foundation
import UserNotifications
import MediaPlayer
import CoreLocation


struct Constant {
    static let termsURLPath = "https://google.com"
    static let privacyURLPath = "https://google.com"
    static let maxProgramPrice: Double = 10000000
    static let maxUploadImageSize = CGSize(width: 1024, height: 1024)
    static let agreement_Text = "By signing up you agree to our Privacy Policy and Terms and Conditions"
    static let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    static var DeviceTokenId = "123"
    static var DeviceType = 1
    static var DeviceUUId: String?
    static var UserType = Int()
    static var UserAccountType = Int()
    static var notificationCenter = UNUserNotificationCenter.current()
    static var appDelegate = UIApplication.shared.delegate as? AppDelegate
}

let notificationCenter = UNUserNotificationCenter.current()
var apimethod = Methods()

struct ApiURLs {
    static let BASEURL = "http://18.116.178.160/dba/api/" //"http://techwinlabs.in/dba/api/"
    static let GET_MEDIA_BASE_URL = "http://18.116.178.160/dba/" //"http://techwinlabs.in/dba/"
    
    static let update_training = BASEURL + "update_training"
    static let update_excercise = BASEURL + "update_excercise"
    static let add_excercise = BASEURL + "add_excercise"
    static let add_myProgress = BASEURL + "add_myProgress" // "http://techwinlabs.in/dba/api/add_myProgress"
    static let update_myProgress = BASEURL + "update_myProgress"
    static let signup_first = BASEURL + "signup_first"
    static let signup_second = BASEURL + "signup_second"
    static let add_anthropometric = BASEURL + "add_anthropometric"
    static let add_goal = BASEURL + "add_goal"
    static let add_achievement = BASEURL + "add_achievement"
    static let add_about = BASEURL + "add_about"
    static let login = BASEURL + "login"
    static let add_post = BASEURL + "add_post"
    static let forgot_password = BASEURL + "forgot_password"
    static let get_all_post = BASEURL + "get_all_post?"
    static let get_user_detail = BASEURL + "get_user_detail"
    static let remove_post = BASEURL + "remove_post"
    static let edit_post = BASEURL + "edit_post"
    static let update_profile = BASEURL + "update_profile"
    static let add_card = BASEURL + "add_card"
    static let get_all_cards = BASEURL + "get_all_cards"
    static let update_card = BASEURL + "update_card"
    static let delete_card = BASEURL + "delete_card"
    static let add_program = BASEURL + "add_program"
    static let userFollow = BASEURL + "userFollow"
    static let get_all_program = BASEURL + "get_all_program?"
    static let get_all_excercise = BASEURL + "get_all_excercise?"
    static let delete_excercise = BASEURL + "delete_excercise"
    static let update_program = BASEURL + "update_program"
    static let copy_program = BASEURL + "copy_program"
    static let delete_program = BASEURL + "delete_program"
    static let get_all_messages = BASEURL + "get_all_messages"
    static let chatting = BASEURL + "chatting"
    static let get_all_trainer = BASEURL + "get_all_trainer?"
    static let trainer_search = BASEURL + "trainer_search?"
    static let update_rating_and_comment = BASEURL + "update_rating_and_comment"
    static let post_like = BASEURL + "post_like"
    static let get_comment = BASEURL + "get_comment?"
    static let add_comment = BASEURL + "add_comment"
    static let userunFollow = BASEURL + "userunFollow"
    static let add_training = BASEURL + "add_training"
    static let get_all_training = BASEURL + "get_all_training?"
    static let delete_training = BASEURL + "delete_training"
    static let add_suppliment = BASEURL + "add_suppliment"
    static let add_rating_and_comment = BASEURL + "add_rating_and_comment"
    static let get_all_progress = BASEURL + "get_all_progress"
    static let add_meal = BASEURL + "add_meal"
    static let delete_meal = BASEURL + "delete_meal"
    static let update_meal = BASEURL + "update_meal"
    static let get_client_progress = BASEURL + "get_all_progress?"
    static let remove_progress = BASEURL + "remove_progress"
    static let get_all_reviews = BASEURL + "get_all_reviews?"
    static let get_myclient = BASEURL + "get_myclient?"
    static let place_order = BASEURL + "place_order"
    static let delete_user_account = BASEURL + "delete_user_account"
    static let report_user = BASEURL + "report_user"
    static let my_gallery = BASEURL + "my_gallery"
    static let achievement_gallery = BASEURL + "achievement_gallery"
    static let private_account = BASEURL + "private_account"
    static let isread_messages = BASEURL + "isread_messages"
    static let notification_toggle = BASEURL + "notification_toggle"
    static let purchased_subscription = BASEURL + "purchased_subscription"
    static let delete_excercise_video = BASEURL + "delete_excercise_video"
    static let delete_training_video = BASEURL + "delete_training_video"
    static let copy_nutrition_days = BASEURL + "copy_nutrition_days"
    static let copy_nutrition_meal = BASEURL + "copy_nutrition_meal"
    static let send_program_or_excercise_to_client = BASEURL + "send_program_or_excercise_to_client"
    static let excercise_folder = BASEURL + "excercise_folder"
    static let get_all_excercise_folder = BASEURL + "get_all_excercise_folder?page=1"
    static let delete_excercise_folder = BASEURL + "delete_excercise_folder"
    static let get_excercise_by_folderId = BASEURL + "get_excercise_by_folderId?folder_id="
    static let share_excercise_folder = BASEURL + "share_excercise_folder"
    static let get_global_and_personal_feed = BASEURL + "get_global_and_personal_feed?type="
    static let get_purchase_list = BASEURL + "get_purchase_list"
    static let get_my_follower_and_following_list = BASEURL + "get_my_follower_and_following_list?type="
    static let add_excercise_training = BASEURL + "add_excercise_training"
    static let get_excercise_training = BASEURL + "get_excercise_training"
    static let become_trainer_or_client = BASEURL + "become_trainer_or_client"
    static let accept_request = BASEURL + "accept_request"
    static let logout = BASEURL + "logout"
    // type=1 for accept request and type=2 (recieve request)
    static let get_all_myfriend = BASEURL + "get_all_myfriend?type="
    static let get_all_notification = BASEURL + "get_all_notification"
    static let check_username = BASEURL + "check_username"
    static let get_account_status_by_email = BASEURL + "get_account_status_by_email"
    static let merge_training_excercise = BASEURL + "merge_training_excercise"
    static let set_session = "http://18.116.178.160/dba/home/set_session?"
    static let delete_clienttrainer = BASEURL + "delete_clienttrainer"
    // is_catalogue:1 (if is_catalogue=2 then send id if 1 then send e_id)
    static let deleteExercise = BASEURL + "deleteExercise"
    static let resetPassword = BASEURL + "resetPassword"
    static let get_notification_count = BASEURL + "get_notification_count"
    static let get_program_or_exercise_to_client = BASEURL + "get_program_or_exercise_to_client"
    static let get_all_reviews_by_id = BASEURL + "get_all_reviews_by_id"
    static let update_exercise_positions = BASEURL + "update_exercise_positions"
}

// Modal's Constant
var userInfo: M_UserInfo?
var allPosts:M_AllPosts?
var particularPostInfo: M_AllPostsData?
var cardsInfos:M_CardInfo?
var particularCardDict: M_CardData?
var programInfos:M_ProgramDetails?
var particularPrograms: M_ProgramData?
var exerciseInfos:M_ExerciseDetails?
var particularExercise: M_ExerciseData?
var getMessageInfo:M_GetMessages?
var particularMessage: M_GetMessagesData?
var chatMessages:M_SendMessages?
var allTrainerInfo:M_GetAllTrainer?
var userDetailsInfo:M_UserDetails?
var searchedTrainerInfo: M_GetAllTrainerData?
var postCommentsInfo:M_GetPostComments?
var programTrainingInfo:M_ProgramTranining?
var particularProgramTraining: M_ProgramTraniningData?
var trainerCommentsInfo:M_GetTrainerComments?
var programMealInfo:M_ProgramMealInfo?
var particularProgramMeal: M_ProgramMealData?
var clientProgressInfo:M_ClientProgress?
var particularClientProgress: M_ClientProgressData?
var particularGoalInfo: M_UserGoal?
var clientReviewsInfo:M_ClientAllReviews?
var particularCardInfo: M_CardData?
var trainerClientList:M_TrainerClientList?
var friendsOrRequestsList:M_TrainerClientList?
var particularGalleryDict: M_UserMyGallery?
var particularAcheivementInfo: M_UserAchievements?
var particularCertificateInfo: String?
var particularCertificateInfoAchievement:M_UserMyGallery?
var exerciseCatalogueInfos: M_CatalogueInfo?
var purchasedORPurchaserInfo:M_ProgramDetails?
var particularPurchasedORPurchaserInfo: M_ProgramData?
var followerANDFollowingUserInfo: FollowerANDFollowingUserInfo?
var notificationListDetails:MNotificationLists?


// Api Param's Constant
var p_signUp = [String:String]()
var selectedCatalgoueID = String()
