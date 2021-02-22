//
//  ViewController.swift
//  lecture8
//
//  Created by admin on 08.02.2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let searchController = UISearchController()
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feelsLikeTemp: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var url = Constants.host + "?q=\(Constants.city)&appid=\(Constants.apiKey)&units=metric"
    var myData: Model?
    
    private var decoder: JSONDecoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        navigationItem.title = "Current data"
        navigationController?.navigationBar.tintColor = .white
        self.navigationItem.searchController = searchController
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = Constants.city
    }
    
    
    func updateUI(){
        cityName.text = myData?.name
        temp.text = "\(String(myData?.main?.temp ?? 0.0)) °C"
        feelsLikeTemp.text = "\(String(myData?.main?.feels_like ?? 0.0)) °C"
        desc.text = myData?.weather?.first?.description
    }
    
    func fetchData(){
        AF.request(url.replacingOccurrences(of: " ", with: "%20")).responseJSON { (response) in
            switch response.result{
            case .success(_):
                guard let data = response.data else { return }
                do {
                    let answer = try self.decoder.decode(Model.self, from: data)
                    if let val = response.value as? [String: Any],
                       let message = val["message"] as? String {
                        self.presentAlert(message)
                    }
                    self.myData = answer
                    self.updateUI()
                } catch {
                    print("Parsing error")
                    self.presentAlert("Parsing error")
                }
            case .failure(let err):
                print(err.errorDescription ?? "")
                self.presentAlert(err.errorDescription ?? "")
            }
        }
    }
    
    func presentAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func open48hours(_ sender: Any) {
        performSegue(withIdentifier: "hourly", sender: nil)
    }
    
    @IBAction func open1week(_ sender: Any) {
        performSegue(withIdentifier: "daily", sender: nil)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Constants.city = searchBar.text ?? Constants.city
        searchBar.placeholder = Constants.city
        url = Constants.host + "?q=\(Constants.city)&appid=\(Constants.apiKey)&units=metric"
        fetchData()
        searchController.dismiss(animated: true, completion: nil)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.placeholder = Constants.city
    }
}

