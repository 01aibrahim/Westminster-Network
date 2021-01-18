//
//  SearchViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 06/12/2020.
//

import UIKit
import Firebase
import FirebaseStorage
import InitialsImageView

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var Activity: UIActivityIndicatorView!
    @IBOutlet weak var UsersTV: UITableView!
    

    var refreshControl = UIRefreshControl()


    var UID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UsersTV.delegate = self
        UsersTV.dataSource = self
        loadUsers()
        refreshTableView()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "UserVC" {
              let UserVC = segue.destination as! UserViewController
            UserVC.uid = UID
          }
      }
    
    func loadUsers(){
        self.Activity.startAnimating()

        Constants.UsersArray = []
        Constants.db.collection(Constants.Users)
            .addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    Constants.UsersArray = querySnapshot!.documents.compactMap({User(dictionary: $0.data())})
                    DispatchQueue.main.async {
                        self.UsersTV.reloadData()
                        self.Activity.stopAnimating()
                    }
                }
            }
    }
    
    func refreshTableView(){
        
        refreshControl.tintColor = UIColor.systemBlue
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        UsersTV.addSubview(refreshControl)
    }
    
    @objc func refreshList(){
        loadUsers()
        refreshControl.endRefreshing()
        UsersTV.reloadData()
    }
    

    
    //MARK:- Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.UsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! SearchTableViewCell
        let user = Constants.UsersArray[indexPath.row]
        
        cell.ProfilePicture.setImageForName(user.name, circular: false, textAttributes: nil, gradient: true)
        cell.configue(ProfilePicture: user.photoURL , Name: user.name, Course: user.Course, CourseYr: user.CourseYR)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UID = Constants.UsersArray[indexPath.row].uid
        performSegue(withIdentifier: "UserVC", sender: self)
    }
}
