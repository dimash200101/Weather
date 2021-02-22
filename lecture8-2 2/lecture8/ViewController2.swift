//
//  ViewController.swift
//  lecture8
//
//  Created by admin on 08.02.2021.
//

import UIKit
import Alamofire

class ViewController2: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let url = Constants.hours48 + "?q=\(Constants.city)&appid=\(Constants.apiKey)&units=metric"
    var myData: Model2?
    
    private var decoder: JSONDecoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        navigationItem.title = "48 hours"
        view.backgroundColor = .white
    }
    
    
    func updateUI(){
        guard let myData = myData else { return }
        tableView.reloadData()
    }
    
    func fetchData(){
        AF.request(url.replacingOccurrences(of: " ", with: "%20")).responseJSON { (response) in
            switch response.result{
            case .success(_):
                guard let data = response.data else { return }
                do {
                    print(response.value)
                    let answer = try? self.decoder.decode(Model2.self, from: data)
                    self.myData = answer
                    self.updateUI()
                }catch{
                    print("Parsing error")
                }
            case .failure(let err):
                print(err.errorDescription ?? "")
            }
        }
    }
    
}

extension ViewController2: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            }
            return cell
        }()
        cell.textLabel?.text = "\(myData?.list[indexPath.row].main?.temp ?? 0) C (feels like \(myData?.list[indexPath.row].main?.feels_like ?? 0) C)"
        cell.detailTextLabel?.text = "\(myData?.list[indexPath.row].dt_txt ?? "")"
        return cell
    }
}
