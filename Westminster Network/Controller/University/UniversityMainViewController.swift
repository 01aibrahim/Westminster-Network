//
//  UniversityMainViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/01/2021.
//

import UIKit
import SafariServices
import Firebase

class UniversityMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadServices()
    }
    override func viewDidAppear(_ animated: Bool) {
        Constants.ServicesArray.removeAll()
        loadServices()

    }

    func loadServices(){
        Constants.db.collection(Constants.US)
            .addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    Constants.ServicesArray = querySnapshot!.documents.compactMap({UniversityServices(dictionary: $0.data())})
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
    }
    
    @IBAction func AskWestClicked(_ sender: Any) {
        showSafariVC(for: Constants.ChatBot)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ServicesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServicesTableViewCell
       
        let Service = Constants.ServicesArray[indexPath.row]
        cell.configue(Name: Service.Name, Link: Service.Link)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = Constants.ServicesArray[indexPath.row].Link!
        
        if link == "Society" || link == "Social Media"{
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = mainStoryboard.instantiateViewController(withIdentifier: "EventsViewController") as! EventsViewController
            destination.tableViewData = link
            destination.modalPresentationStyle = .fullScreen
            self.present(destination, animated: true, completion: nil)
            
        }else{
            self.showSafariVC(for: link)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showSafariVC(for url: String){
           guard let url = URL(string: url)else{return}
           let safariVC = SFSafariViewController(url:url)
           present(safariVC, animated: true)
       }
}
