

import UIKit

class Trainer_View_Supplement: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var supplements: UILabel!
    @IBOutlet weak var supplementName: UILabel!
    
    var clientSupplements:String?
    var clientSupplementName:String?
    var userRole = ""
    var programsID = Int()
    var selectedIndex:Int?
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "Role") as? String ?? ""
        
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                editLabel.isHidden = false
                editButton.isUserInteractionEnabled = true
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                editLabel.isHidden = true
                editButton.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // supplements.text = trainerProgram?.supplements?.first.supplementDescription
       // supplementName.text = trainerProgram?.supplements?.first.name
        
        if particularPrograms?.suppliment != ""{
            supplements.text = particularPrograms?.suppliment ?? "N/A"
        }else{
           supplements.text = "N/A"
        }
        supplementName.text = "Program : \(particularPrograms?.programName ?? "N/A")"
    }
    

    //MARK : IB's Action
    
    @IBAction func edit(_ sender: UIButton) {
        let ShareVC = UIStoryboard(name: AppStoryboard.Trainer_Tabbar.rawValue, bundle: nil).instantiateViewController(withIdentifier: "Trainer_Edit_Supplement") as! Trainer_Edit_Supplement
        ShareVC.programID = programsID
        ShareVC.name = clientSupplementName ?? "N/A"
        ShareVC.desc = clientSupplements ?? "N/A"
        ShareVC.selectedIndex = selectedIndex
        self.addChild(ShareVC)
        ShareVC.view.frame = self.view.frame
        self.view.addSubview(ShareVC.view)
        ShareVC.didMove(toParent: self)
        
        //UniversalMethod.universalManager.pushVC("Trainer_Edit_Supplement", self.navigationController, storyBoard: AppStoryboard.Trainer_Tabbar.rawValue)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper's Method
}



