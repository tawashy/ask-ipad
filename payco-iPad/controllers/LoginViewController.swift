import UIKit

class LoginViewController: UIViewController {
    

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginBtnDidPress(_ sender: Any) {
        self.loginBtn.isEnabled = false
        self.loginBtn.setTitle("Loging in ...", for: .normal)
        
        //        PFUser.login(email: "yaser.tawash@gmail.com", password: "123123")
        
        PFUser.login(email: "store@gmail.com", password: "123123") { (success) in
            if success {
                print("Logged in.")
                self.dismiss(animated: true, completion: nil)
                SocketIOManager.sharedInstance.socket.emit("createRoom", PFUser.currentUser.id)
            } else {
                print("Not Logged in.")
                self.loginBtn.isEnabled = true
                self.loginBtn.setTitle("Login", for: .normal)
            }
        }
    
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

