
import UIKit
import MGSwipeTableCell

class TrainerEditSelectedPhoto: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!
    @IBOutlet weak var actionSheet_View: UIView!
    @IBOutlet weak var cancel_View: UIView!
    @IBOutlet weak var delete_View: UIView!
    @IBOutlet weak var selectedPhots: UIImageView!
    
    var clientInfo = [String:Any]()
    var files = [Int]()
    var goalsArray = [String]()
    var selectedMediaID = Int()
    var trainerID = Int()
    var photosID = [Int]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionSheet_View.isHidden = true
        delete_View.layoutIfNeeded()
        cancel_View.layer.cornerRadius = 12.0
        delete_View.roundCorners(topLeft: 0.0, topRight: 0.0, bottomLeft: 12.0, bottomRight: 12.0)
        // mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        selectedPhots.layer.cornerRadius = 4.0
        //trainerID = DataSaver.dataSaverManager.fetchData(key: "trainerID") as! Int
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add_Goals(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = true
        actionSheet_View.isHidden = false
    }
    
    @IBAction func delete_Post(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        actionSheet_View.isHidden = true
       /* p_AddNewExercise["trainer"] = self.trainerID
        p_AddNewExercise["name"] = entityDict?.name
        p_AddNewExercise["description"] = entityDict?.entityDescription
        
        if (entityDict?.files?.count) != nil{
            for dict in (entityDict?.files) {
                self.photosID.append(dict.id ?? 0)
            }
            let indexs = photosID.firstIndex(of: selectedMediaID)
            photosID.remove(at: indexs)
        }
        p_AddNewExercise["files"] = self.photosID

        self.deleteGalleryMedia(parameters:p_AddNewExercise)*/
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        actionSheet_View.isHidden = true
    }
    
    
    //MARK: Helper's Method
    
}


