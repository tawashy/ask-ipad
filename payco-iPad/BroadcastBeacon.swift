import UIKit
import CoreBluetooth
import CoreLocation

class BroadcastBeacon: NSObject, CBPeripheralDelegate {
    
    static let sharedInstance = BroadcastBeacon()
    
    private var beaconRegion: CLBeaconRegion!
    private var peripheralManager: CBPeripheralManager!
    
    private var isBrodcasting = false
    private var beaconStatus = "Beacon Status: Not Broadcasting"
    private var bluetoothStatus:String = "Bluetooth status unknown"
    
    private var dataDicionary = NSDictionary()
    
    
    
    override init() {
        super.init()
        beaconRegion = createBeaconRegion()
        peripheralManager = CBPeripheralManager(delegate: (self as! CBPeripheralManagerDelegate), queue: nil, options: nil)
    }
    
    // MARK: main
    func checkBroadcastStatus(){
        if !isBrodcasting {
            switch peripheralManager.state {
            case .poweredOn:
                self.startAdvertising()
                self.updateBeaconStatus()
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
        }
    }
    
    // create Beacon Region
    func createBeaconRegion() -> CLBeaconRegion? {
        let uuidString = "50DEF72D-B647-4341-9107-5154C15D5C82"
        let uuid = UUID(uuidString: uuidString)!
        let major = 100
        let minor = 100
            
        return CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: "com.agi.beacon")
    }
    
    func startAdvertising () {
        beaconRegion = self.createBeaconRegion()
        dataDicionary = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager.startAdvertising((dataDicionary as! [String: Any]))
        
        isBrodcasting = true
    }
    
    func updateBeaconStatus(){
        if isBrodcasting {
            beaconStatus = "Beacon Status: Broadcasting"
        } else {
            beaconStatus = "Beacon Status: Not Broadcasting"
        }
    }
    
    // get beacon status
    func getBeaconStatus() -> String {
        return beaconStatus
    }
    
    // get bluetooth Status
    func getBluetoothStatus() -> String {
        return bluetoothStatus
    }
    
    // MARK: CBPeripheralManagerDelegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            bluetoothStatus = "Bluetooth powered on"
            break
        case .poweredOff:
            bluetoothStatus = "Bluetooth powered off"
            break
        case .resetting:
            bluetoothStatus = "Bluetooth powered resetting"
            break
        case .unauthorized:
            bluetoothStatus = "Use of Bluetooth is unauthorized"
            break
        case .unsupported:
            bluetoothStatus = "Bluetooth is unsupported"
            break
        case .unknown:
            bluetoothStatus = "Bluetooth status unknown"
            break
        }
    }
    
    

}
