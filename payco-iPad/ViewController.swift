import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    var beaconRegion: CLBeaconRegion!
    var peripheralManager: CBPeripheralManager!
    
    var isBrodcasting = false
    var dataDicionary = NSDictionary()
    
    @IBOutlet weak var uuidField:UITextField!
    @IBOutlet weak var majorField:UITextField!
    @IBOutlet weak var minorField:UITextField!
    @IBOutlet weak var bluetoothStatusLabel:UILabel!
    @IBOutlet weak var beaconStatusLabel:UILabel!
    @IBOutlet weak var beaconButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        // dismiss a keyboard after adding a value into textField
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (ViewController.dismissKeyboard)))
        
        uuidField.text = "50DEF72D-B647-4341-9107-5154C15D5C82"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Main
    func checkBroadcastStatus(){
        if !isBrodcasting {
            switch peripheralManager.state {
            case .poweredOn:
                self.startAdvertising()
                self.updateBeaconStatus()
                self.updateButtonTitle()
                break
            case .poweredOff:
                break
            case .resetting:
                break
            case .unauthorized:
                break
            case .unknown:
                break
            case .unsupported:
                break
            }
        } else {
            peripheralManager.stopAdvertising()
            isBrodcasting = false
            self.updateButtonTitle()
            self.updateBeaconStatus()
        }
    }
    
    func createBeaconRegion() -> CLBeaconRegion? {
        if let uuidString = uuidField.text {
            let uuid = UUID(uuidString: uuidString)!
            let major = Int(majorField.text!)!
            let minor = Int(minorField.text!)!
            
            return CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: "com.agi.beacon")
        }
        return nil
    }
    
    func startAdvertising () {
        beaconRegion = self.createBeaconRegion()
        dataDicionary = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager.startAdvertising((dataDicionary as! [String: Any]))
        
        isBrodcasting = true
    }
    
    func updateButtonTitle() {
        if isBrodcasting {
            self.beaconButton.setTitle("Stop Broadcasting", for: .normal)
        } else {
            self.beaconButton.setTitle("Start Broadcasting", for: .normal)
        }
    }
    
    func updateBeaconStatus(){
        if isBrodcasting {
            beaconStatusLabel.text = "Beacon Status: Broadcasting"
        } else {
            beaconStatusLabel.text = "Beacon Status: Not Broadcasting"
        }
    }
    
    // MARK: CBPeripheralManagerDelegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            bluetoothStatusLabel.text = "Bluetooth powered on"
            break
        case .poweredOff:
            bluetoothStatusLabel.text = "Bluetooth powered off"
            break
        case .resetting:
            bluetoothStatusLabel.text = "Bluetooth powered resetting"
            break
        case .unauthorized:
            bluetoothStatusLabel.text = "Use of Bluetooth is unauthorized"
            break
        case .unsupported:
            bluetoothStatusLabel.text = "Bluetooth is unsupported"
            break
        case .unknown:
            bluetoothStatusLabel.text = "Bluetooth status unknown"
            break
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Acitons
    @IBAction func startButtonPressed(sender: Any){
        
        // check if the fields are filled then checkBroadcastStatus
        // otherwise, throw an error to the user to fill the information needed to the fields
        if uuidField.text == "" || majorField.text == "" || minorField.text == "" {
            self.showAlert(title: "Error", message: "Please complete all fields")
        } else {
            self.checkBroadcastStatus()
        }
        
        
    }
    
    @IBAction func closeWindow(){
        if let presenter = self.presentingViewController{
            presenter.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    
    
    
    
    


    
    
    
    
}

