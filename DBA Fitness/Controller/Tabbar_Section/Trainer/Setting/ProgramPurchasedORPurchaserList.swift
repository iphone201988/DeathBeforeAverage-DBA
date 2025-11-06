
import UIKit
import MGSwipeTableCell
import AVKit
import SDWebImage

class ProgramPurchasedORPurchaserList: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var programPurchasedORPurchaserListTableView: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interface_Title: UILabel!

    var trainerSpecs = ["Male","Expert","Strongman"]
    var currentRow = Int()
    var userRole = ""
    var newUrl = ""
    var pageNo = 1
    var isDisableAddNewWorkouts = false
    
    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userRole = DataSaver.dataSaverManager.fetchData(key: "userType") as? String ?? ""
        //self.tabBarController?.tabBar.isHidden = true
        if userRole != ""{
            if (userRole == Role.trainer.rawValue){
                isTrainer = "Trainer"
                interface_Title.text = "Purchased Programs List"
                let updatedEndPoint = ApiURLs.get_myclient + "page=\(pageNo)" + "&type=2"
                getPurchasedORPurchaserList(parameters:[:], endPoint:updatedEndPoint)
            }else if (userRole == Role.client.rawValue){
                isTrainer = "Client"
                interface_Title.text = "Purchased Programs List"
                getPurchasedORPurchaserList(parameters:[:], endPoint:ApiURLs.get_purchase_list)
            }
        }
    }

    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        //self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper's Method
}

extension ProgramPurchasedORPurchaserList: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = purchasedORPurchaserInfo?.data?.count else{
            empty_View.isHidden = false
            return 0
        }
        
        if count  > 0{
            empty_View.isHidden = true
        }else{
            empty_View.isHidden = false
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: "Client_Program_Cell", for: indexPath) as? Client_Program_Cell {
            particularPurchasedORPurchaserInfo = purchasedORPurchaserInfo?.data?[indexPath.row]
            cell.ratingIcon.isHidden = true
            cell.purchaseIcon.isHidden = true
            cell.purchaseButton.isUserInteractionEnabled = false
            cell.program_Name.text = particularPurchasedORPurchaserInfo?.programName
            if let photo = particularPurchasedORPurchaserInfo?.image{
                if photo != ""{
                    let completePicUrl = "\(ApiURLs.GET_MEDIA_BASE_URL)\(photo)"
                    cell.trainer_Pic.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    cell.trainer_Pic.sd_setImage(with: URL(string: completePicUrl), placeholderImage: #imageLiteral(resourceName: "user"), options: .highPriority)
                }else{
                    cell.trainer_Pic.image = #imageLiteral(resourceName: "user")
                }
            }
            currentRow = indexPath.row
            cell.trainer_Specs_Collection.delegate = self
            cell.trainer_Specs_Collection.dataSource = self
            cell.trainer_Specs_Collection.register(UINib(nibName: "Trainer_Specs_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Specs_Cell")
            cell.trainer_Specs_Collection.reloadData()
            cell.emptyTags.isHidden = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        particularPrograms = purchasedORPurchaserInfo?.data?[indexPath.row]
        
        if particularPrograms?.isPurchased == "0"{
            UniversalMethod.universalManager.alertMessage("Please purchase this program first by tapping the shopping cart icon.", self)
        }else{
            let storyBoard = AppStoryboard.Trainer_Program.instance
            let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Program_Details") as! Trainer_Program_Details
            vc.isDisableAddNewWorkouts = isDisableAddNewWorkouts
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ProgramPurchasedORPurchaserList: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        if indexPath.item == 0{
            label.text = particularPurchasedORPurchaserInfo?.sex
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        }else if (indexPath.item == 1){
            label.text = particularPurchasedORPurchaserInfo?.levelOfTraining
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        }else{
            label.text = particularPurchasedORPurchaserInfo?.category
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        }
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
                cell.specs_Title.text = particularPurchasedORPurchaserInfo?.sex
            }else if indexPath.item == 1{
                cell.specs_View.backgroundColor = UIColor(named: "Training_Type")
                cell.specs_Title.text = particularPurchasedORPurchaserInfo?.levelOfTraining
            }else{
                cell.specs_View.backgroundColor = UIColor(named: "Receiver_Message")
                cell.specs_Title.text = particularPurchasedORPurchaserInfo?.category
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
