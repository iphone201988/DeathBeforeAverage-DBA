
import UIKit

class Filter_Trainer: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var search_Button: GradientButton!
    @IBOutlet weak var filter_View: UIView!
    @IBOutlet weak var male: UIView!
    @IBOutlet weak var female: UIView!
    @IBOutlet weak var any: UIView!
    @IBOutlet weak var filter_Collectionview: UICollectionView!
    @IBOutlet weak var isSelected: UIImageView!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var selection_Action: UIButton!
    
    @IBOutlet weak var certificateTFHeight: NSLayoutConstraint!
    @IBOutlet weak var checkIconWidth: NSLayoutConstraint!
    @IBOutlet weak var underlineViewHeight: NSLayoutConstraint!
    @IBOutlet weak var certificateViewTop: NSLayoutConstraint!
    
    
    @IBOutlet weak var certifiedTF: UITextField!
    
    //MARK : Controller Lifecycle
    
    var category_options = ["Bodybuilding", "Strongman", "Powerlifting", "Olympic Lifting", "CrossFit", "Pilates","Yoga", "Calisthenics", "Athletics", "WeightLoss", "Rehab & Recovery", "Other"]
    var category_options1 = ["bodybuilding", "strongman", "powerlifting", "olympicLifting", "crossFit", "pilates","yoga", "%D1%81alisthenics", "athletics", "weightLoss", "rehabandRecovery", "other"]
    var selectedGender = ""
    var selectedOption = [String]()
    var userRole = String()

    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.6117647059, blue: 0.3254901961, alpha: 1)
    @IBInspectable var endColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.3450980392, blue: 0.2, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        location.placeholderColor(color: UIColor.white)
        filter_View.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        
        male.customView(borderWidth:1, cornerRadius:4.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
        female.customView(borderWidth:1, cornerRadius:4.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
        any.customView(borderWidth:1, cornerRadius:4.0,red: 255/255, green: 255/255, blue: 255/255, alpha: 0.06)
        
        male.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        female.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        any.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)

        search_Button.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        
        filter_Collectionview.register(UINib(nibName: "SpecialistOption", bundle: nil), forCellWithReuseIdentifier: "SpecialistOption")
        filter_Collectionview.allowsMultipleSelection = true
        filter_Collectionview.delegate = self
        filter_Collectionview.dataSource = self
        
        initialSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let existingLayer = (male.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            existingLayer.removeFromSuperlayer()
        }
        if let existingLayer = (female.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            existingLayer.removeFromSuperlayer()
        }
        any.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        
        male.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        female.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        any.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
    }
    
    
    func initialSetup(){
        selectedOption.removeAll()
        selectedGender = ""
        location.text = ""
        selection_Action.tag = 0
        isSelected.image = #imageLiteral(resourceName: "squareCheckBoxUnselected")
        
        /*if let existingLayer = (male.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
         existingLayer.removeFromSuperlayer()
         }
         if let existingLayer = (female.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
         existingLayer.removeFromSuperlayer()
         }
         any.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)

         male.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
         female.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
         any.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)*/
        
        DataSaver.dataSaverManager.deleteData(key: "selectedLoc")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Constants.searchLocation = ""
        if let selectedLoc = DataSaver.dataSaverManager.fetchData(key: "selectedLoc") as? String{
            if selectedLoc == ""{
                location.text = ""
            }else{
                location.text = selectedLoc
            }
        }else{
            location.text = ""
        }
        
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                certificateTFHeight.constant = 0.0
                checkIconWidth.constant = 0.0
                underlineViewHeight.constant = 0.0
                certificateViewTop.constant = 0.0
                certifiedTF.isHidden =  true
                
            }else if (userRole == Role.client.rawValue){
                certificateTFHeight.constant = 30.0
                checkIconWidth.constant = 25.0
                underlineViewHeight.constant = 1.0
                certificateViewTop.constant = 35.0
                certifiedTF.isHidden =  false
            }
        }
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search(_ sender: UIButton) {
        if let searchedLocation = location.text, !searchedLocation.isEmpty {
//            let string = searchedLocation.replacingOccurrences(of: " ", with: "")
//            let location = string.components(separatedBy: ",")

            // w.e.f 02.04.2024
            let location = searchedLocation.components(separatedBy: ",")

            Constants.searchLocation = "&location=\(location.first ?? "")"
        }
        if selection_Action.tag == 1{
            Constants.searchIsCertifiate = "&certificate=1"
        }else{
            Constants.searchIsCertifiate = "&certificate=0"
        }
        
        let count = selectedOption.count
        
        if count > 0{
            let stringSpecialist = selectedOption.joined(separator: ",")
            Constants.searchSpecialist = "&specialist=\(stringSpecialist)"
        }else{
            Constants.searchSpecialist = ""
        }
        Constants.searchGender = selectedGender
        NotificationCenter.default.post(name:NSNotification.Name(Constants.searchTrainer), object:true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func isSelected_Certificates(_ sender: UIButton) {
        if sender.tag == 0{
            selection_Action.tag = 1
            isSelected.image = #imageLiteral(resourceName: "squarecheckBoxSelected")
        }else{
            selection_Action.tag = 0
            isSelected.image = #imageLiteral(resourceName: "squareCheckBoxUnselected")
        }
    }
    
    @IBAction func maleTap(_ sender: UIButton) {
        

        
        // http://techwinlabs.in/dba/api/trainer_search?page=1&specialist=Bodybuilding,Strongman&sex=female&location=Chandigarh&certificate=1(for checked) 0(for unchecked)
        
        selectedGender = "&sex=male"

        if let existingLayer = (female.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            existingLayer.removeFromSuperlayer()
        }
        if let existingLayer = (any.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            existingLayer.removeFromSuperlayer()
        }
        male.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        
        male.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
        female.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        any.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
    }
    
    @IBAction func femaleTap(_ sender: UIButton) {

        
        selectedGender = "&sex=female"
        
        if let existingLayer = (male.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            existingLayer.removeFromSuperlayer()
        }
        if let existingLayer = (any.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            existingLayer.removeFromSuperlayer()
        }
        female.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        
        male.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        female.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
        any.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
    }
    
    @IBAction func anyTap(_ sender: UIButton) {

        
        selectedGender = ""
        
        if let existingLayer = (male.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            existingLayer.removeFromSuperlayer()
        }
        if let existingLayer = (female.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            existingLayer.removeFromSuperlayer()
        }
        any.gradientBackground(from: startColor, to: endColor, direction: .leftToRight)
        
        male.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        female.customViewsShadow(red: 42/255, green: 36/255, blue: 59/255, alpha: 1.0, width: 0, height: 6, opacity: 0.43, radius: 6.5)
        any.customViewsShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0, width: 0, height: 2, opacity: 0.28, radius: 4)
    }
    
    @IBAction func search_Location(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Search_Locations", self.navigationController, storyBoard: AppStoryboard.Onboarding.rawValue)
    }
    
    //MARK: Helper's Method
    
}

extension Filter_Trainer: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category_options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = category_options[indexPath.item]
        label.sizeToFit()
        //return CGSize(width: label.frame.width + 50, height: 50.0)
        return CGSize(width: label.intrinsicContentSize.width + 30, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecialistOption", for: indexPath) as? SpecialistOption {
            cell.configure(with: category_options[indexPath.item])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedOption.count > 0{
            if let indexs = selectedOption.firstIndex(of: category_options[indexPath.row]){
                selectedOption.remove(at: indexs)
            }else{
                let selectedCategory = category_options[indexPath.row]
                let withoutSpaceCategoryName = selectedCategory.replacingOccurrences(of: " ", with: "")
                selectedOption.append(withoutSpaceCategoryName)
            }
        }else{
            let selectedCategory = category_options[indexPath.row]
            let withoutSpaceCategoryName = selectedCategory.replacingOccurrences(of: " ", with: "")
            selectedOption.append(withoutSpaceCategoryName)
        }
    }
}
