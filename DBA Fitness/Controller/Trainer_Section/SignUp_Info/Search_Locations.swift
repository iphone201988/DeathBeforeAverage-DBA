
import UIKit
import MGSwipeTableCell
import GooglePlaces

class Search_Locations: UIViewController, UITextFieldDelegate {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var goals_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    fileprivate var fetcher: GMSAutocompleteFetcher?
    var client_Goals = [String]()
    
    //MARK : Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchTF.placeholderColor(color: UIColor.white)
        mainView.customView(borderWidth:0.0, cornerRadius:7.0,red: 64.0/255, green: 59.0/255, blue: 83.0/255, alpha: 1.0)
        searchView.layer.cornerRadius = 20.0
        searchView.layer.borderWidth = 1.0
        searchView.layer.borderColor = UIColor(named: "lightPurpleColor")?.cgColor
        goals_Tableview.delegate = self
        goals_Tableview.dataSource = self
        goals_Tableview.register(UINib(nibName: "Location_Cell", bundle: nil), forCellReuseIdentifier: "Location_Cell")
        goals_Tableview.reloadData()
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken()
        fetcher = GMSAutocompleteFetcher()
        fetcher?.autocompleteFilter = filter
        fetcher?.delegate = self
        fetcher?.provide(token)
        searchTF.delegate = self
        searchTF.addDoneButtonOnKeyboard()
        
        if let selectedLoc = DataSaver.dataSaverManager.fetchData(key: "selectedLoc") as? String{
            if selectedLoc == ""{
                searchTF.text = ""
            }else{
                searchTF.text = selectedLoc
                fetcher?.sourceTextHasChanged(searchTF.text ?? "")
            }
        }else{
            searchTF.text = ""
        }
        
        searchTF.addTarget(self, action: #selector(self.textIsChanging(_:)), for: .editingChanged)
        
    }
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filter_Action(_ sender: UIButton) {
        UniversalMethod.universalManager.pushVC("Filter_Trainer", self.navigationController, storyBoard: AppStoryboard.Client_Search.rawValue)
    }
    
    @IBAction func clearTF(_ sender: UIButton) {
        searchTF.text = ""
    }

    //MARK: Helper's Method
    
    @objc func textIsChanging(_ textField:UITextField){
        fetcher?.sourceTextHasChanged(textField.text ?? "")
    }
    
}

extension Search_Locations: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = client_Goals.count as? Int else{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
        }else{
            empty_View.isHidden = true
            goals_Tableview.isHidden = false
        }
        return count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Location_Cell", for: indexPath) as? Location_Cell {
            cell.searchedLocation.text = client_Goals[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLoc = client_Goals[indexPath.row]
        DataSaver.dataSaverManager.saveData(key: "selectedLoc", data: "\(selectedLoc)")
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }
    
}

// MARK: - GMSAutocompleteFetcherDelegate

extension Search_Locations: GMSAutocompleteFetcherDelegate {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.prepareTableView(with: predictions)
    }
    
    func didFailAutocompleteWithError(_ error: Error) { }
    
    fileprivate func prepareTableView(with predictions: [GMSAutocompletePrediction]) {

        client_Goals.removeAll()
        for item in predictions {
            let placeLocations = item.attributedFullText
            client_Goals.append(placeLocations.string)
        }
        goals_Tableview.reloadData()
    }
}
