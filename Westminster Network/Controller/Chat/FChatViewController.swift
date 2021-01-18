//
//  FChatViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 24/12/2020.
//

import UIKit
import Firebase
import FirebaseStorage

class FChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var ConversationID: String!
    var ConvoName: String!
    var uid:String!
    var timer: Timer?

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var NameLabel: UILabel!
    
    var Token: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameLabel.text = ConvoName
        
        tableview.delegate = self
        TextField.delegate = self
        tableview.dataSource = self

        loadConvo()
        
        tableview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//MARK:- Load Conversation
    
    func loadConvo(){
        Constants.ref.child("users")
            .child(Auth.auth().currentUser!.uid)
            .child("Conversations")
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
                    
                    self.tableview.reloadData()
                    self.scrollToBottom()
                }
        })
        
        // Code to get Token Num
        Constants.db.collection("users").document(uid)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                return
              }
                self.Token = document.get("FCMToken") as! String
            }
        
        
    }
    
    


//MARK:- Send Message
    
    @IBAction func MessageSendPressed(_ sender: Any) {
       
        if TextField.text != "" {
            let Sender = Constants.defaults.string(forKey: "Name")!
            let Picture = Constants.defaults.string(forKey: "Profile Picture")!
            let messageText = TextField.text
            
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "dd-MM-yy HH:mm"
            let dateString = df.string(from: date)
            
            let message = ["SenderID": Sender, "Picture": Picture, "Message": messageText, "Time": dateString]
            
            Constants.ref.child("users")
                .child(Auth.auth().currentUser!.uid)
                .child("Conversations")
                .child(ConversationID!)
                .childByAutoId()
                .setValue(message)
            
            Constants.ref.child("users")
                .child(uid)
                .child("Conversations")
                .child(ConversationID!)
                .childByAutoId()
                .setValue(message)
            
            TextField.text = ""
            TextField.resignFirstResponder()
            loadConvo()
            sendPushNotification(to: Token, title: Sender, body: messageText!)
        }else{
            TextField.resignFirstResponder()
        }
    }
    
//MARK:- More Details
    
    @IBAction func MorePressed(_ sender: Any) {
        let alert = UIAlertController(title: ConvoName, message: "Chat Setting.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report", style: .default)
        { action -> Void in
            
            Constants.db.collection("ReportConvo").document(self.ConversationID).setData([
                "From user": Auth.auth().currentUser!.uid,
                "Convo ID": self.ConversationID!,
                "Convo Name": self.ConvoName!,
                "Resolved": false
            ]) { err in
                if let err = err {
                    //MARK: Add User side error code
                    print("Error writing document: \(err)")
                } else {}
            }
        })
        
        alert.addAction(UIAlertAction(title: "Clear Chat", style: .default)
        { action -> Void in
            Constants.ref.child("users")
                .child(Auth.auth().currentUser!.uid)
                .child("Conversations")
                .child(self.ConversationID)
                .removeValue()
            
            Constants.ChatArray.removeAll()
            self.dismiss(animated: false, completion: nil)
        })
        

        alert.addAction(UIAlertAction(title: "Delete Chat", style: .destructive)
        { action -> Void in
            Constants.ref.child("users")
                .child(Auth.auth().currentUser!.uid)
                .child("ConversationList")
                .child(self.uid)
                .removeValue()
            
            self.dismiss(animated: true, completion: nil)
        })

        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    
    @IBAction func BackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Push Notification
    
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : "New Message from \(title)", "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(Constants.serverKey)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }

//MARK:- TableView
    

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
            self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

//MARK:- TextField
extension FChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if TextField.text == ""{
            textField.placeholder = "Atleast one characters required"
            textField.resignFirstResponder()
            return true
            
        }else{
            MessageSendPressed(UIButton())
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
