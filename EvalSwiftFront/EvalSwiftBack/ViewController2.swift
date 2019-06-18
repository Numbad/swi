import UIKit

class ViewController2: UIViewController {
    var pizzaId = 0
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let param: [String: Any] = ["pizzaId": pizzaId]
        let url = URL(string: ("http://localhost:8080/get_ingredient"))
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async{
                self.label.text = (String(data: data, encoding: .utf8)!)
                
            }
        }
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
