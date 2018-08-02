import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var items = [Float]()
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var chargeBtn: UIButton!
    
    var user = PFUser.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // check if user is connected...
        if (self.user == nil){
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginView")
            self.present(loginVC!, animated: true, completion: nil)
        }
        
        SocketIOManager.sharedInstance.socket.on("roomCreated") { (data, ack) in
            let alert = UIAlertController(title: "Sucess!", message: data[0] as? String, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        setupNavigationView()
        tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func pericBtnEntered (){
        addItem()
    }
    
    @IBAction func clearBtnPressed (){
        
        // remove all items
        items.removeAll()
        
        // update table
        tableView.reloadData()
        
        // update button title
        chargeBtn.setTitle("Charge \(getTotal()) SAR", for: .normal)
    }
    
    func addItem(){
        // check the price input
        if (textField.text == ""){
            let alert = UIAlertController(title: "Warning!", message: "Please enter a price to add to the order list", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            // add item to array
            items.append(Float(textField.text!)!)
            let indexPath = IndexPath(row: items.count - 1, section: 0)
            
            // update table
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .bottom)
            tableView.endUpdates()
            
            // reset textField and reset keyboard
            textField.text = ""
            view.endEditing(true)
            
            // update button title
            chargeBtn.setTitle("Charge \(getTotal()) SAR", for: .normal)
            updateTotal()
        }
    }
    
    func updateTotal(){
        SocketIOManager.sharedInstance.socket.emit("updateTotal", PFUser.currentUser.id, getTotal())
    }
    
    func deleteItem(indexPath:IndexPath) {
        // remove item from array
        items.remove(at: indexPath.row)
        
        // update table
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        // update button title
        chargeBtn.setTitle("Charge \(getTotal()) SAR", for: .normal)
        updateTotal()
    }
    
    @IBAction func chargeBtnPressed(_ sender: Any) {
//        print("Present customer list view")
//        let userList = self.storyboard?.instantiateViewController(withIdentifier: "userList")
//        userList?.modalPresentationStyle = .overCurrentContext
//        present(userList!, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "charge"{
            if (items.count != 0){
                var controller: UserListViewController = segue.destination as! UserListViewController
                controller.totalAmount = getTotal()
                
                
            } else {
                let alert = UIAlertController(title: "Warning!", message: "Please add items to order list", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // calculater buttons
    @IBAction func calcBtn(_ sender: UIButton) {

        switch sender.currentTitle! {
        case "0":
            textField.text?.append("0")
            break
        case "1":
            textField.text?.append("1")
            break
        case "2":
            textField.text?.append("2")
            break
        case "3":
            textField.text?.append("3")
            break
        case "4":
            textField.text?.append("4")
            break
        case "5":
            textField.text?.append("5")
            break
        case "6":
            textField.text?.append("6")
            break
        case "7":
            textField.text?.append("7")
            break
        case "8":
            textField.text?.append("8")
            break
        case "9":
            textField.text?.append("9")
            break
        case ".":
            textField.text?.append(".")
            break
        case "Clear":
            textField.text = ""
            break
        default:
            print(sender.currentTitle!)
        }
    }
    
    
    func getTotal() -> String {
        var total: Float = 0.00
        for item in items {
            total += item
        }
        
        return String(format: "%.2f", total)
    }
    // MARK: - Navigation
    func setupNavigationView (){
        // make navigation bar larger
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.largeTitleDisplayMode = .automatic
        navigationItem.titleView = UIImageView(image: UIImage(named: "noqta"))
        navigationController?.navigationBar.topItem?.title = "Noqta"
    }
    
    // MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
        
        cell.addItem(newPrice: String(format: "%.2f", items[indexPath.row]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
