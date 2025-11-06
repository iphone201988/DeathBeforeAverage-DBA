
import UIKit
import MGSwipeTableCell

class Send_Program_Client: UIViewController {
    
    //MARK : Outlets and Variables
    
    @IBOutlet weak var goals_Tableview: UITableView!
    @IBOutlet weak var empty_View: UIView!
    @IBOutlet weak var nextButton: GradientButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    var client_Goals = ["String", "Lorem ipsum dolor sit amet, enim nec mattis quia donec. Euismod nulla id sapien ut, egestas praesent vitae hendrerit purus, nulla dui voluptas justo orci sit interdum. Pharetra wisi ac, vel massa proin erat velit, vitae inceptos fringilla malesuada. Vehicula sed vel, lacinia est, aliquip eget.","Quis ut felis aliquet vivamus laoreet, ut ac, sed phasellus suscipit non, enim ac id. Lectus"]
    
    //  var client_Goals = [String]()
    
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
        goals_Tableview.register(UINib(nibName: "Client_List_Cell", bundle: nil), forCellReuseIdentifier: "Client_List_Cell")
        goals_Tableview.reloadData()
        nextButton.circleShadow(red: 252/255, green: 111/255, blue: 62/255, alpha: 1.0)
        
    }
    
    
    //MARK : IB's Action
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: Helper's Method
}

extension Send_Program_Client: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = client_Goals.count as? Int else{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            nextButton.isEnabled = false
            return 0
        }
        
        if count == 0{
            empty_View.isHidden = false
            goals_Tableview.isHidden = true
            nextButton.isEnabled = false
        }else{
            empty_View.isHidden = true
            goals_Tableview.isHidden = false
            nextButton.isEnabled = true
        }
        return count
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Client_List_Cell", for: indexPath) as? Client_List_Cell {
            cell.selection_Icon.image = #imageLiteral(resourceName: "checkBoxSelected")
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //self.viewWillLayoutSubviews()
    }

}

