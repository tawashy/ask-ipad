import UIKit

class UserListViewController: UIViewController {
    
    var totalAmount: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Action
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Total Amount: \(totalAmount!)")
        SocketIOManager.sharedInstance.socket.emit("unlockRoom", PFUser.currentUser.id);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SocketIOManager.sharedInstance.socket.emit("lockRoom", PFUser.currentUser.id);
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
