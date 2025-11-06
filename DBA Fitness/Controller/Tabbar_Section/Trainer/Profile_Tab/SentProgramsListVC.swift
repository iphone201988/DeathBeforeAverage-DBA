import UIKit

class SentProgramsListVC: UIViewController {
    
    //MARK : Outlets and Variables
    @IBOutlet weak var goals_Tableview: UITableView! {
        didSet{
            goals_Tableview.register(UINib(nibName: "Trainer_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Trainer_Programs_Cell")
            goals_Tableview.register(UINib(nibName: "Exercise_Programs_Cell", bundle: nil), forCellReuseIdentifier: "Exercise_Programs_Cell")
            goals_Tableview.register(UINib(nibName: "Client_Program_Cell", bundle: nil), forCellReuseIdentifier: "Client_Program_Cell")
            goals_Tableview.register(UINib(nibName: "Client_Progress", bundle: nil), forCellReuseIdentifier: "Client_Progress")
        }
    }
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var sentProgramsDetail = [M_ProgramData]()
    var currentRow = Int()
    var clientID: String = ""
    
    //MARK : Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.  Looks like you haven't added any client yet.
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trainerNavigateViaSentProgramsList = true
        getSentProgramList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        trainerNavigateViaSentProgramsList = nil
    }
    
    //MARK : IB's Action
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helper's Method
    private func getSentProgramList() {
        // http://18.116.178.160/dba/api/get_program_or_exercise_to_client?clientid=38
        if Connectivity.isConnectedToInternet {
            NVActivityIndicator.managerHandler.showIndicator()
            
            let newURL = ApiURLs.get_program_or_exercise_to_client + "?clientid=\(clientID)&page=1"
            
            apimethod.commonMethod(
                url: newURL,
                parameters: [:],
                method: "GET") { (_ dict,
                                  _ success: Bool ,
                                  _ error: Error?,
                                  _ response: Any,
                                  _ responseData) in
                    NVActivityIndicator.managerHandler.stopIndicator()
                    if success, let result = response as? HTTPURLResponse{
                        if(result.statusCode==404||result.statusCode==400 || result.statusCode==401){
                            if result.statusCode == 401{
                                logoutFromAPP()
                            }else{
                                UniversalMethod.universalManager.alertMessage("\(dict?["message"] ?? "The user name or e-mail already exists.")", self.navigationController)
                            }
                            
                        }else if(result.statusCode==204||result.statusCode==200||result.statusCode==201){
                            DispatchQueue.main.async {
                                let details = try? JSONDecoder().decode(M_ProgramDetails.self, from: responseData)
                                if details?.data?.count ?? 0 > 0 {
                                    self.sentProgramsDetail = details?.data ?? []
                                } else {
                                    self.sentProgramsDetail = []
                                    UniversalMethod.universalManager.alertMessage("No Programs found", self.navigationController)
                                }
                                
                                self.goals_Tableview.reloadData()
                            }
                        }else if(result.statusCode==500){
                            UniversalMethod.universalManager.alertMessage("Internal Server Error", self.navigationController)
                        }
                    }
                }
        }else{
            UniversalMethod.universalManager.alertMessage("Internet connection appears to be offline, Please try again", self.navigationController)
        }
    }
}

extension SentProgramsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sentProgramsDetail.count == 0 {
            empty_View.isHidden = false
        }else{
            empty_View.isHidden = true
        }
        
        return sentProgramsDetail.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Trainer_Programs_Cell", for: indexPath) as? Trainer_Programs_Cell {
            particularPrograms = sentProgramsDetail[indexPath.row]
            cell.program_Name.text = particularPrograms?.programName
            currentRow = indexPath.row
            cell.trainer_Specs_Collection.delegate = self
            cell.trainer_Specs_Collection.dataSource = self
            cell.trainer_Specs_Collection.register(UINib(nibName: "Trainer_Specs_Cell", bundle: nil), forCellWithReuseIdentifier: "Trainer_Specs_Cell")
            cell.trainer_Specs_Collection.reloadData()
            cell.configure()
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        particularPrograms = sentProgramsDetail[indexPath.row]
        let storyBoard = AppStoryboard.Trainer_Program.instance
        let vc = storyBoard.instantiateViewController(withIdentifier: "Trainer_Program_Details") as! Trainer_Program_Details
        vc.hidesBottomBarWhenPushed = true
        vc.isNavigateViaSentProgramDetails = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SentProgramsListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //MARK: CollectionView's Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        if indexPath.item == 0{
            label.text = particularPrograms?.sex
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        }else if (indexPath.item == 1){
            label.text = particularPrograms?.levelOfTraining
            label.sizeToFit()
            return CGSize(width: label.frame.width + 10, height: 40.0)
        }else{
            label.text = particularPrograms?.category
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
                cell.specs_Title.text = particularPrograms?.sex
            }else if indexPath.item == 1{
                cell.specs_View.backgroundColor = UIColor(named: "Training_Type")
                cell.specs_Title.text = particularPrograms?.levelOfTraining
            }else{
                cell.specs_View.backgroundColor = UIColor(named: "Receiver_Message")
                cell.specs_Title.text = particularPrograms?.category
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

