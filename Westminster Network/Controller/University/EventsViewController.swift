//
//  EventsViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 10/01/2021.
//

import UIKit
import SafariServices
import Firebase

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var NavBar: UINavigationBar!
    @IBOutlet weak var rightBarbutton: UIBarButtonItem!
    
    var tableViewData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        if tableViewData == "Society"{
            loadEvent()
        }else{
            loadSocialMedia()
        }
    }
    
    func loadSocialMedia(){
        NavBar.topItem?.title = "Social Media"
        NavBar.topItem?.rightBarButtonItem?.isEnabled = false
        Constants.ServicesArray.removeAll()
        
        Constants.db.collection("SocialMediaLinks")
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

    
    func loadEvent(){
        print("Event")
        Constants.EventArray.removeAll()

        Constants.db.collection(Constants.EL)
            .addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    Constants.EventArray = querySnapshot!.documents.compactMap({Event(dictionary: $0.data())})
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        Constants.ServicesArray.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addEventPressed(_ sender: Any) {
        let alert = UIAlertController(title: Constants.AddEventAlertTitle , message: Constants.AddEventAlertMessage , preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Event Name"
        }
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Organisation Name"
        }
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Event Date"
        }
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Event Link"
        }

        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))

        alert.addAction(UIAlertAction(title: "Send", style: .default)
        { action -> Void in
            let Name = alert.textFields![0].text!
            let OrName = alert.textFields![1].text!
            let Date = alert.textFields![2].text!
            let Link = alert.textFields![3].text!

            Constants.db.collection(Constants.E).document().setData([
                "UID": Auth.auth().currentUser!.uid,
                "Event Name": Name,
                "Organisation Name": OrName,
                "Date": Date,
                "Link": Link,
                "Added": false
            ])
        })
        self.present(alert, animated: true)
    }
    
    func showSafariVC(for url: String){
           guard let url = URL(string: url)else{
               return
           }
           let safariVC = SFSafariViewController(url:url)
           present(safariVC, animated: true)
       }
    
//MARK:- TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData == "Society"{
            return Constants.EventArray.count
        }else{
            return Constants.ServicesArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableViewData == "Society"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
            let Service = Constants.EventArray[indexPath.row]
            cell.titleLabel.text = Service.Name
            cell.subtitleLabel.text = "\(Service.OrganisationName!), \(Service.Date!)"
            
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
            
            let Social = Constants.ServicesArray[indexPath.row]
            cell.titleLabel.text = Social.Name
            cell.subtitleLabel.text = Social.Name
            cell.subtitleLabel.isHidden = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData == "Society"{
            let link = Constants.EventArray[indexPath.row].Link!
            showSafariVC(for: link)
        }else{
            let link = Constants.ServicesArray[indexPath.row].Link!
            showSafariVC(for: link)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
