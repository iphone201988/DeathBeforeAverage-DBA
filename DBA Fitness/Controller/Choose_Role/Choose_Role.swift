
import UIKit

class Choose_Role: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var trainerRadioImageView: UIImageView!
    @IBOutlet weak var clientRadioImageView: UIImageView!
    @IBOutlet weak var nextButton: GradientButton!
    
    @IBOutlet weak var trainerView: UIView!
    @IBOutlet weak var clientView: UIView!
    
    
    fileprivate var isTrainer: Bool? {
        didSet {
            setupRadioButtons()
        }
    }
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        isTrainer = nil
        
        trainerView.layer.borderWidth = 1.0
        clientView.layer.borderWidth = 1.0
        trainerView.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        clientView.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataSaver.dataSaverManager.deleteData(key: "selectedLoc")
    }
    
    
    //MARK : IB's Action
    
    @IBAction func trainerAction(_ sender: UITapGestureRecognizer) {
        isTrainer = true
    }
    
    @IBAction func clientAction(_ sender: UITapGestureRecognizer) {
        isTrainer = false
    }
    
    @IBAction func backRole(_ sender: UIButton) {
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
            UniversalMethod.universalManager.navigateToAuth()
        }
    }
    
    
    //MARK: Helper's Method
    
    fileprivate func setupRadioButtons() {
        
        guard let isTrainer = self.isTrainer else {
            nextButton.isEnabled = false
            trainerRadioImageView.tintColor = #colorLiteral(red: 0.7019607843, green: 0.6862745098, blue: 0.7647058824, alpha: 0.3497661953)
            clientRadioImageView.tintColor =  #colorLiteral(red: 0.7019607843, green: 0.6862745098, blue: 0.7647058824, alpha: 0.3497661953)
            return
        }
        
        nextButton.isEnabled = true
        
        if isTrainer {
            trainerRadioImageView.tintColor = #colorLiteral(red: 0.9960784314, green: 0.7215686275, blue: 0.2509803922, alpha: 1)
            trainerRadioImageView.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.86, radius: 10.5)
            clientRadioImageView.tintColor = #colorLiteral(red: 0.7019607843, green: 0.6862745098, blue: 0.7647058824, alpha: 0.3497661953)
        } else {
            trainerRadioImageView.tintColor = #colorLiteral(red: 0.7019607843, green: 0.6862745098, blue: 0.7647058824, alpha: 0.3497661953)
            clientRadioImageView.tintColor = #colorLiteral(red: 0.9960784314, green: 0.7215686275, blue: 0.2509803922, alpha: 1)
            clientRadioImageView.customImageViewShadow(red: 245/255, green: 131/255, blue: 56/255, alpha: 1.0, width: 0, height: 5, opacity: 0.86, radius: 10.5)
        }
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        setRole()
    }
    
    func setRole() {
        guard let isTrainer = self.isTrainer else {
            return
        }
        if isTrainer == true{
            Constants.selectedRoleType = "1"
            UniversalMethod.universalManager.navigateToTrainerSignUp()
        }else{
            Constants.selectedRoleType = "2"
            //UniversalMethod.universalManager.navigateToClientSignUp()
             UniversalMethod.universalManager.navigateToTrainerSignUp()
        }
    }
}

