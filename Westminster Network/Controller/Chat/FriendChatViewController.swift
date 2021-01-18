//
//  FriendChatViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 16/12/2020.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase


class FriendChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableview: UITableView!

    var db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var ref = Database.database().reference()

    let defaults = UserDefaults.standard
    var ConversationID = ""


    var ConvoArray = [FeedConvo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        

        loadChats()
    }

    func loadChats(){
        ref.child("users")
            .child(Auth.auth().currentUser!.uid)
            .child("ConversationList")
            .observe(.value, with: { (snapshot) in
            
                if snapshot.childrenCount>0{
                    self.ConvoArray.removeAll()
                    
                    for Conversations  in snapshot.children.allObjects as! [DataSnapshot]{
                        let ConvoObject = Conversations.value as? [String: AnyObject]
                        let ConvoID = ConvoObject?["ConversationID"] as! String
                        let ConvoName = ConvoObject?["ConversationName"] as! String
                        let ConvoPic = ConvoObject?["ConversationPicture"] as! String
                        let ConvoLastMessage = ConvoObject?["ConversationLastMessage"] as! String
                        let ConvoTime = ConvoObject?["ConversationTime"] as! String

                        let Convo = FeedConvo(convoID: ConvoID, name: ConvoName, profilePic: ConvoPic, lastMessage: ConvoLastMessage, time: ConvoTime)
                        
                        self.ConvoArray.append(Convo)
                        print("This is the array")
                        print(self.ConvoArray)
                    }
                    self.tableview.reloadData()
                }
        })
    }
//MARK:- TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConvoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvoListTableViewCell", for: indexPath) as! FriendChatTableViewCell
       
        let Convo = ConvoArray[indexPath.row]
        cell.configue(convoID: Convo.ConvoID, name: Convo.Name, profilePic: Convo.ProfilePic, lastMessage: Convo.LastMessage, time: Convo.Time)
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ConversationID = ConvoArray[indexPath.row].ConvoID
        performSegue(withIdentifier: "OpenChat", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "OpenChat" {
            let ChatVC = segue.destination as! FChatViewController
            ChatVC.ConversationID = ConversationID
          }
      }
}
