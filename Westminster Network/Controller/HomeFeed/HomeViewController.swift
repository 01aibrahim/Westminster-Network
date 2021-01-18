//
//  HomeViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 14/11/2020.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseMessaging
import InitialsImageView

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedName = ""
    var selectedPost = ""
    var selectedPostID = ""
    
    @IBOutlet weak var HomeTV: UITableView!
    @IBOutlet weak var actLoading: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()
    var pasteBoard = UIPasteboard.general


    override func viewDidLoad() {
        super.viewDidLoad()
        HomeTV.delegate = self
        HomeTV.dataSource = self
    
        loadtweets()
        refreshTableView()
        getCurrentToken()
        
    }
    
    func getCurrentToken(){
        Messaging.messaging().token { token, error in
            let FCMToken = token!
            
            Constants.db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "FCMToken": FCMToken
            ])
          }
    }
    
    func loadtweets(){
        self.actLoading.startAnimating()
        Constants.feedArray = []
        
        Constants.db.collection("Posts")
            .order(by: "TimeStamp")
            .addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                } else {
                    Constants.feedArray = querySnapshot!.documents.compactMap({FeedMessage(dictionary: $0.data())})
                    DispatchQueue.main.async {
                        self.HomeTV.reloadData()
                        self.actLoading.stopAnimating()
                    }
                }
            }
    }

    func refreshTableView(){
        refreshControl.tintColor = UIColor.systemBlue
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        HomeTV.addSubview(refreshControl)
    }
    
    @objc func refreshList(){
        loadtweets()
        refreshControl.endRefreshing()
        HomeTV.reloadData()
    }
    
    
    //MARK:- Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
           
        let post = Constants.feedArray.reversed()[indexPath.row]
        
        cell.ProfilePicture.setImageForName(post.Name, circular: true, textAttributes: nil, gradient: true)
        cell.configue(ProfilePicture: post.ProfilePic, Name: post.Name, Message: post.post)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = Constants.feedArray.reversed()[indexPath.row].Name
        selectedPost = Constants.feedArray.reversed()[indexPath.row].post
        selectedPostID = Constants.feedArray.reversed()[indexPath.row].postID
        let postUID = Constants.feedArray.reversed()[indexPath.row].UID
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = mainStoryboard.instantiateViewController(withIdentifier: "SelectedPostViewController") as! SelectedPostViewController
        
        destination.Name = selectedName
        destination.Text = selectedPost
        destination.PostID = selectedPostID
        destination.UID = postUID
        
        destination.modalPresentationStyle = .fullScreen
        
        self.present(destination, animated: true, completion: nil)
        HomeTV.cellForRow(at: indexPath)?.isSelected = false

    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if (action == #selector(UIResponderStandardEditActions.copy(_:))) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        let post = Constants.feedArray.reversed()[indexPath.row].post
        pasteBoard.string = post
    }
        
}


