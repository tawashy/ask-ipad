import Foundation
import CoreBluetooth
import CoreLocation
import UIKit

class BeaconTransmitter: NSObject, CBPeripheralManagerDelegate {
    
    static let sharedInstance = BeaconTransmitter()
    
    
    var region: CLBeaconRegion?
    var on = false
    var _peripheralManager: CBPeripheralManager?
    
    var peripheralManager: CBPeripheralManager {
        if _peripheralManager == nil {
            _peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        }
        return _peripheralManager!
    }
    
    override init() {
        super.init()
    }
    
    func stop() {
        on = false
        peripheralManager.stopAdvertising()
    }
    
    func start() {
        on = true
        self.region = createBeaconRegion()
        startTransmitting()
    }
    
    func createBeaconRegion() -> CLBeaconRegion? {
        let uuidString = "50DEF72D-B647-4341-9107-5154C15D5C82"
        let uuid = UUID(uuidString: uuidString)!
        let major = 100
        let minor = 100
        
        return CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: "com.agi.beacon")
    }
    
    func startTransmitting() {
        if let region = region {
            let peripheralData = region.peripheralData(withMeasuredPower: -59) as Dictionary
            peripheralManager.stopAdvertising()
            peripheralManager.startAdvertising(peripheralData as? [String : AnyObject])
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if(peripheral.state == .poweredOn) {
            if on {
                startTransmitting()
            }
        }
        else if(peripheral.state == .poweredOff) {
            NSLog("Bluetooth is off")
        }
        else if(peripheral.state == .unsupported) {
            NSLog("Bluetooth not supported")
        }
    }
    
}

