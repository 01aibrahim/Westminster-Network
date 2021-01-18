//
//  SelectedPostViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/01/2021.
//

import UIKit
import Firebase

class SelectedPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var PostName: UILabel!
    @IBOutlet weak var PostText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TextField: UITextField!
        
    var Name = ""
    var Text = ""
    var PostID = ""
    var UID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        TextField.delegate = self
        
        loadPostThread()

        self.PostName.text = Name
        self.PostText.text = Text
        
    
        
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
                
        self.PostText.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector((longPressFunctin(_:))))
        self.PostText.addGestureRecognizer(longPress)
    }
    

    @objc func longPressFunctin(_ gestureRecognizer: UILongPressGestureRecognizer) {
        PostText.becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: view, rect: CGRect(x: self.PostText.center.x, y: self.PostText.center.y, width: 0.0, height: 0.0))
        }
    }

    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = PostText.text
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copy(_:))
    }
    
    
    
    func loadPostThread(){
        Constants.ref.child("PostThreads")
            .child(PostID)
            .queryOrdered(byChild: "Time")
            .observe(DataEventType.value, with: { (snapshot) in
            
                if snapshot.childrenCount>0{
                    Constants.FeedCommentArray.removeAll()
                    
                    for Conversations  in snapshot.children.allObjects as! [DataSnapshot]{
                        let ConvoObject = Conversations.value as? [String: AnyObject]
                        let Sender = ConvoObject?["SenderID"] as! String
                        let Pic = ConvoObject?["Picture"] as! String
                        let Message = ConvoObject?["Message"] as! String
                        let Time = ConvoObject?["Time"] as! String

                        let Chat = ConvoThread(sender: Sender,profilePic: Pic, message: Message, time: Time)
                        
                        Constants.FeedCommentArray.append(Chat)
                    }
                    
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
        })
    }
    
    
    @IBAction func AddComment(_ sender: Any) {
        let Sender = Constants.defaults.string(forKey: "Name")!
        let Picture = Constants.defaults.string(forKey: "Profile Picture")!
        let messageText = TextField.text
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yy HH:mm"
        let dateString = df.string(from: date)
        
        let comment = ["SenderID": Sender, "Picture": Picture, "Message": messageText, "Time": dateString]
        
        Constants.ref.child("PostThreads")
            .child(PostID)
            .childByAutoId()
            .setValue(comment)
        
        TextField.text = ""
        TextField.resignFirstResponder()
    }
    
    
    @IBAction func MorePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Post Thread", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share Post", style: .default)
        { action -> Void in
            let items: [Any] = ["Hey, \(self.Name) said: \(self.Text) on Westminster Network.", URL(string: Constants.AppStoreLink)!]
            
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
        })
        
        if Auth.auth().currentUser?.uid == self.UID{
            alert.addAction(UIAlertAction(title: "Delete Post", style: .default)
            { action -> Void in
                
                Constants.db.collection("Posts")
                    .document(self.PostID)
                    .delete()
                    { err in
                        if let err = err {
                            print("This has not been deleted")
                            
                            let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                            print("This has been deleted")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
            })
        }else{
            alert.addAction(UIAlertAction(title: "Report Post", style: .default)
            { action -> Void in
                
                Constants.db.collection("ReportPost").document().setData([
                    "From user": Auth.auth().currentUser!.uid,
                    "PostID": self.PostID,
                    "Post From": self.Name,
                    "Post": self.Text,
                    "Resolved": false
                ]) { err in
                    if let err = err {
                        let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                    }
                }
            })
        }
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func BackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    //MARK:- TableView
        

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Constants.FeedCommentArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! ChatTableViewCell

            let Chat = Constants.FeedCommentArray[indexPath.row]
            cell.configue(sender: Chat.Sender, profilePic: Chat.ProfilePic, message: Chat.Message, time: Chat.Time)

            cell.selectionStyle = .none
            return cell
        }
        
        func scrollToBottom(){
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: Constants.FeedCommentArray.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    //MARK:- TextField
    extension SelectedPostViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            if TextField.text == ""{
                textField.placeholder = "Atleast one characters required"
                textField.resignFirstResponder()
                return true
                
            }else{
                AddComment(UIButton())
                textField.resignFirstResponder()
                return true
            }
        }
        
        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }

        @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }


