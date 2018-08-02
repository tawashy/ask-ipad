import UIKit
import SocketIO

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    
        let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "https://nsk-pay.herokuapp.com")!, config: [.log(true), .compress])
    
//    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://192.168.0.11:3000/")!, config: [.log(true), .compress])
    
    var status: Bool = false
    
    override init() {
        super.init()
    }
    
    func connnect() {
        socket.connect()
        print("Connected")
    }
    
    func disconnect() {
        socket.disconnect()
        print("Disconnected")
    }
    
    func reconnect(){
        socket.reconnect()
    }
    
    
    
    func connectWithId(id: String){
        if (socket.status == SocketIOClientStatus.connected){
            socket.emit("check user", id)
        }
    }
    
    func on(event name: String) {
        
    }
    
    func makePayment(major: NSNumber, minor: NSNumber){
        socket.emit("joinRoom", [PFUser.currentUser.id, major, minor])
        //        socket.on("currentAmount") {data, ack in
        //            print("GETTING CURRENT AMOUNT \(data[0])")
        //            if let cur = data[0] as? Double {
        //                self.self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
        //                    print("CAN UPDATE WITH \(data[0])")
        //                    self.self.socket.emit("update", ["amount": cur + 2.50])
        //                }
        //
        //                ack.with("Got your currentAmount", "dude")
        //            }
        //        }
        
        //        socket.emitWithAck("canPay").timingOut(after: 3) { success in
        //            print("MESSAGE BACK FROM SERVER: CAN I PAY? \(success)")
        //
        //        }
        
        //        socket.emitWithAck("needsAck", "test").onAck {data in
        //            println("got ack with data: (data)")
        //        }
        //        socket.emit("payment", userId, [major, minor])
    }
    
    
}

