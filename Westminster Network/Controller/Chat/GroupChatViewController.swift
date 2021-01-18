//
//  GroupChatViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 02/01/2021.
//

import UIKit
import Firebase

class GroupChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ConversationID: String!
    var ConvoName: String!
        
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        NameLabel.text = ConvoName
        
        tableView.delegate = self
        TextField.delegate = self
        tableView.dataSource = self

        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
     
        loadConvo()
    }
    
 
    
//MARK:- Load Conversations
    
    func loadConvo(){
        Constants.ref.child("GroupConversations")
            .child(ConversationID!)
            .queryOrdered(byChild: "Time")
            .observe(DataEventType.value, with: { (snapshot) in
            
                if snapshot.childrenCount>0{
                    Constants.ChatArray.removeAll()
                    
                    for Conversations  in snapshot.children.allObjects as! [DataSnapshot]{
                        let ConvoObject = Conversations.value as? [String: AnyObject]
                        let Sender = ConvoObject?["SenderID"] as! String
                        let Pic = ConvoObject?["Picture"] as! String
                        let Message = ConvoObject?["Message"] as! String
                        let Time = ConvoObject?["Time"] as! String

                        let Chat = ConvoThread(sender: Sender,profilePic: Pic, message: Message, time: Time)
                        
                        Constants.ChatArray.append(Chat)
                    }
                    
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
        })
    }
    
    
    //MARK:- Send Message

    @IBAction func SendMessagePressed(_ sender: Any) {
        if TextField.text != ""{
            let Sender = Constants.defaults.string(forKey: "Name")!
            let Picture = Constants.defaults.string(forKey: "Profile Picture")!
            let messageText = TextField.text
            
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "dd-MM-yy HH:mm"
            let dateString = df.string(from: date)
            
            let message = ["SenderID": Sender, "Picture": Picture, "Message": messageText, "Time": dateString]
            
            Constants.ref.child("GroupConversations")
                .child(ConversationID)
                .childByAutoId()
                .setValue(message)
            
            TextField.text = ""
            TextField.resignFirstResponder()
            loadConvo()
        }else{}
    }
        
    
//MARK:- More
    @IBAction func MorePressed(_ sender: Any) {
        let alert = UIAlertController(title: ConvoName, message: "Group Setting.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add Member", style: .default)
        { action -> Void in
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = mainStoryboard.instantiateViewController(withIdentifier: "AddUserToGroupViewController") as! AddUserToGroupViewController
            destination.ConvoID = self.ConversationID
            destination.ConvoName = self.ConvoName
            destination.groupIcon = ""
            
            self.present(destination, animated: true, completion: nil)

        })
        
        alert.addAction(UIAlertAction(title: "Report Group", style: .default)
        { action -> Void in

            Constants.db.collection("ReportConvo").document(self.ConversationID).setData([
                "From user": Auth.auth().currentUser!.uid,
                "Convo ID": self.ConversationID!,
                "Convo Name": self.ConvoName!,
                "Resolved": false
            ]) { err in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {}
            }
        })
        
        alert.addAction(UIAlertAction(title: "Leave Group", style: .destructive)
        { action -> Void in
            Constants.ref.child("users")
                .child(Auth.auth().currentUser!.uid)
                .child("ConversationList")
                .child(self.ConversationID)
                .removeValue()
            
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func BackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    

//MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ChatArray.count

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! ChatTableViewCell

        let Chat = Constants.ChatArray[indexPath.row]
        cell.configue(sender: Chat.Sender, profilePic: Chat.ProfilePic, message: Chat.Message, time: Chat.Time)

        cell.selectionStyle = .none
        return cell
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: Constants.ChatArray.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

//MARK:- TextField Delegates

extension GroupChatViewController: UITextFieldDelegate {
    

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if TextField.text == ""{
            textField.placeholder = "Atleast one characters required"
            textField.resignFirstResponder()
            return true
            
        }else{
            SendMessagePressed(UIButton())
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




