import Foundation

// User Object
struct User: Decodable {
    let id: String
    let name: String
    let email: String
    let balance: Int
    let createdAt: String
}


class PFUser: NSObject {
    static var currentUser: User!
    
    // login functoin
    //    static func login(email: String, password: String, completion: ((Bool) -> Void)?){
    //        let jsonUrl = "\(APIService.API_URL)/auth/login"
    //        guard let url = URL(string: jsonUrl) else { return }
    //
    //        URLSession.shared.dataTask(with: url) { (data, response, err) in
    //
    //            // check if the data has values
    //            guard let data = data else {
    //                completion!(false)
    //                return }
    //
    //            do { self.currentUser = try JSONDecoder().decode(User.self, from: data);
    //                completion!(true)}
    //            catch let jsonErr {
    //                completion!(false)
    //                print("Error: ", jsonErr)
    //
    //            }
    //
    //            }.resume()
    //
    //    }
    
    static func login(email: String, password: String, completion: ((Bool) -> Void)?){
        let parameters = ["email": email, "password": password]
        
        guard let url = URL(string: "\(APIService.API_URL)/auth/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONDecoder().decode(User.self, from: data)
                    
                    currentUser = json
                    completion!(true)
                } catch let error{
                    print("error \(error)")
                    completion!(false)
                    return
                }
            }
            
            }.resume()
        
    }
    
    
    // register function
    
    
    // logout function
    static func logout() {
        currentUser = nil
    }
}


