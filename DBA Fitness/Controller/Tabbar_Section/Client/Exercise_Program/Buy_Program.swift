
import UIKit

class Buy_Program: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var training_Goal: UITextField!
    @IBOutlet weak var dayOfWeek: UITextField!
    @IBOutlet weak var specs_Collectionview: UICollectionView!
    @IBOutlet weak var buyButton: GradientButton!
    @IBOutlet weak var programDesc: UILabel!
    @IBOutlet weak var programName: UILabel!
    
    var trainerSpecs = ["Male","Expert","Strongman"]
    var particularPrograms: M_ProgramData?
    var stripe_secret_key = String()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specs_Collectionview.delegate = self
        specs_Collectionview.dataSource = self
        specs_Collectionview.register(UINib(nibName: "Trainer_Specs_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Specs_Cell")
        
        // Do any additional setup after loading the view.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        buyButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        training_Goal.text = "Goal: \(particularPrograms?.goals ?? "N/A")"
        dayOfWeek.text = particularPrograms?.daysPerWeek
        programName.text = particularPrograms?.programName
        programDesc.text = particularPrograms?.programDescription
        buyButton.setTitle("Buy Program $\(particularPrograms?.price ?? "100")", for: .normal)
    }
    
    
    //MARK : IB's Action
    
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func purchase_Action(_ sender: UIButton) {
        let storyBoard = AppStoryboard.Trainer_Setting.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_PaymentCards") as! Trainer_PaymentCards
        vc.isPurchaseSection = true
        vc.program_id = particularPrograms?.id ?? "0"
        vc.stripe_secret_key = self.stripe_secret_key
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Helper's Method
}


extension Buy_Program: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = trainerSpecs[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 10, height: 40.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trainer_Specs_Cell", for: indexPath) as? Trainer_Specs_Cell {
            if indexPath.item == 0{
                cell.specs_View.backgroundColor = UIColor(named: "Gender_View")
                cell.specs_Title.text = "Male"
            }else if indexPath.item == 1{
                cell.specs_View.backgroundColor = UIColor(named: "Training_Type")
                cell.specs_Title.text = "Expert"
            }else{
                cell.specs_View.backgroundColor = UIColor(named: "Receiver_Message")
                cell.specs_Title.text = "Strongman"
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}


