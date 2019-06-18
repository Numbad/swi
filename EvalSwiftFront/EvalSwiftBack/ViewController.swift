import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var dataFromApi: [[String: Any]] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFromApi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! //1.
        
        let text = dataFromApi[indexPath.row]["nom"] as! String
        print(indexPath.row)
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //)
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "screen2") as! ViewController2
        secondViewController.pizzaId = dataFromApi[indexPath.row]["id"] as! Int
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = self
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: "http://localhost:8080/get_pizzas")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            //print(String(data: data, encoding: .utf8)!)
            //print(data)
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: []) as? [[String: Any]]
                for i in jsonResponse! {
                    self.dataFromApi.append(i)
                }
                //print(self.dataFromApi)
                DispatchQueue.main.async{
                    self.tableView.dataSource = context
                    self.tableView.delegate = context
                    
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        task.resume()
        
    }
    
    
}

