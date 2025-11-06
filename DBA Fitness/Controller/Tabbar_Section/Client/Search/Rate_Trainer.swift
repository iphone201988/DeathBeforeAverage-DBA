
import UIKit
import STRatingControl
import SDWebImage

class Rate_Trainer: UIViewController, STRatingControlDelegate {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var upload_View: UIView!
    @IBOutlet weak var uploaded_Image: UIImageView!
    @IBOutlet weak var ratingButton: GradientButton!
    @IBOutlet weak var trainerRating: STRatingControl!
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    @IBOutlet var interfaceHeaderLbl: UILabel!
    @IBOutlet weak var trainerName: UILabel!
    @IBOutlet weak var reviewTV: UITextView!
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    var ratingValue: CGFloat = 0.0
    var particularUserInfoForRatingView: ParticularUserInfoForRatingView?
    
    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        upload_View.setViewCircle()
        upload_View.viewUpdatedShadow(red: 45/255, green: 38/255, blue: 63/255, alpha: 1.0)
        uploaded_Image.setRoundImage()
        ratingButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        
        trainerRating.delegate = self
        
        // Rating View setup
        starRatingView.tintColor = UIColor(named: "yellowColor")
        starRatingView.spacing = 10.0
        
        reviewTV.delegate = self
        reviewTV.textColor = UIColor.gray
        reviewTV.text = "We value your feedback, please share your review!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let photo = particularUserInfoForRatingView?.image{
            if photo != ""{
                let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                uploaded_Image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                uploaded_Image.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
            }else{
                uploaded_Image.image = #imageLiteral(resourceName: "user")
            }
        }
        trainerName.text = particularUserInfoForRatingView?.firstname ?? "N/A"
        starRatingView.value = 0.0
        ratingValue = 0.0
        
        let userRole =  DataSaver.dataSaverManager.fetchData(key: "userType") as? String
        if userRole == "1" {
            interfaceHeaderLbl.text = "Rate a Client"
        } else if userRole == "2" {
            interfaceHeaderLbl.text = "Rate a Trainer"
        }
        
        // trainerRating.rating = Int(particularUserInfoForRatingView?.rating ?? "0") ?? 0
        //        if let ratingValue = particularUserInfoForRatingView?.rating, var convertedValue = Double(ratingValue) {
        //            if convertedValue.isWholeNumber {
        //                starRatingView.value = CGFloat(convertedValue)
        //            } else {
        //                let actualValue = convertedValue - 1.0
        //                starRatingView.value = CGFloat(actualValue)
        //            }
        //        } else {
        //            starRatingView.value = 0.0
        //        }
        
        //self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rate_Trainer(_ sender: UIButton) {
        if ratingValue > 0.0 {
            Constants.isRatingTrainers = "1"
            let reviewContent = reviewTV.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !reviewContent.isEmpty && reviewContent != "We value your feedback, please share your review!" {
                trainerCommentsRating(parameters:["trainer_id": particularUserInfoForRatingView?.userid ?? "0",
                                                  "rating": ratingValue,
                                                  "comment": reviewContent] )
            } else {
//                trainerCommentsRating(parameters:["trainer_id": particularUserInfoForRatingView?.userid ?? "0",
//                                                  "rating": ratingValue] )
                
                Toast.show(message: "Please share your review", controller: self)
            }
        } else {
            Toast.show(message: "Please give us your rating first.", controller: self)
        }
        
        //        let convertedValue = Double(ratingValue)
        //            if convertedValue.isWholeNumber {
        //                trainerCommentsRating(parameters:["trainer_id":particularUserInfoForRatingView?.userid ?? "0",
        //                                                  "rating":convertedValue] )
        //            } else {
        //                let actualValue = convertedValue - 1.0
        //                trainerCommentsRating(parameters:["trainer_id":particularUserInfoForRatingView?.userid ?? "0",
        //                                                  "rating":actualValue] )
        //            }
    }
    
    @IBAction func comment_Trainer(_ sender: UIButton) {
        guard let userID = particularUserInfoForRatingView?.userid else { return }
        let storyBoard = AppStoryboard.Client_Search.instance
        let destVC = storyBoard.instantiateViewController(withIdentifier: "Client_Comment") as! Client_Comment
        destVC.userID = userID
        // self.navigationController?.pushViewController(destVC, animated: true)
        
        //        UniversalMethod.universalManager.pushVC("Client_Comment", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
    }
    
    @IBAction func tappedViewReviews(_ sender: GradientButton) {
        guard let userID = particularUserInfoForRatingView?.userid else { return }
        let storyBoard = AppStoryboard.Client_Search.instance
        let destVC = storyBoard.instantiateViewController(withIdentifier: "Client_Comment") as! Client_Comment
        destVC.userID = userID
        // self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func starRatingValueChanged(_ sender: SwiftyStarRatingView) {
        let _value = starRatingView.value
        ratingValue = _value
        //        if _value.isWholeNumber {
        //            ratingValue = _value
        //        } else {
        //            let modifyValue = _value + 1.0
        //            ratingValue = modifyValue
        //        }
    }
    
    //MARK: Helper's Method
    
    func didSelectRating(_ control: STRatingControl, rating: Int) {
        // ratingValue = rating
    }
}

extension CGFloat {
    init?(string: String) {
        guard let number = NumberFormatter().number(from: string) else { return nil }
        self.init(number.floatValue)
    }
}

extension FloatingPoint {
    var isWholeNumber: Bool { isNormal ? self == rounded() : isZero }
}

struct ParticularUserInfoForRatingView: Codable {
    let userid, firstname, lastname: String?
    let image: String?
    let rating: String?
}

extension Rate_Trainer: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = "We value your feedback, please share your review!"
            textView.textColor = UIColor.gray
        }
    }
    
}
