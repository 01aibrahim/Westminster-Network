 //
//  ChatViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 28/11/2020.
//

import UIKit
import Firebase
import InitialsImageView

 class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!

    var refreshControl = UIRefreshControl()

    var ConversationID = ""
    var convoName = ""
    var UserID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
        refreshTableView()
        loadChats()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableview.delegate = self
        tableview.dataSource = self
        
        refreshTableView()
        loadChats()
    }
    
    func refreshTableView(){
        
        refreshControl.tintColor = UIColor.systemBlue
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableview.addSubview(refreshControl)
    }
    
    @objc func refreshList(){
        loadChats()
        refreshControl.endRefreshing()
        tableview.reloadData()
    }


    func loadChats(){
        Constants.ref.child("users")
            .child(Auth.auth().currentUser!.uid)
            .child("ConversationList")
            .observe(.value, with: { (snapshot) in
            
                if snapshot.childrenCount>0{
                    Constants.ConvoArray.removeAll()
                    
                    for Conversations  in snapshot.children.allObjects as! [DataSnapshot]{
                        let ConvoObject = Conversations.value as? [String: AnyObject]
                        let ConvoID = ConvoObject?["ConversationID"] as! String
                        let ConvoName = ConvoObject?["ConversationName"] as! String
                        let ConvoPic = ConvoObject?["ConversationPicture"] as! String
                        let ConvoLastMessage = ConvoObject?["ConversationLastMessage"] as! String
                        let ConvoTime = ConvoObject?["ConversationTime"] as! String
                        let ConvoUID = ConvoObject?["ConvoWith"] as! String

                        let Convo = FeedConvo(convoID: ConvoID, name: ConvoName, profilePic: ConvoPic, lastMessage: ConvoLastMessage, time: ConvoTime, convoUid: ConvoUID)
                        
                        Constants.ConvoArray.append(Convo)
                    }
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                }
        })
    }
    
    @IBAction func NewGroupPressed(_ sender: Any) {
        performSegue(withIdentifier: "CreateGroup", sender: self)
    }
    
//MARK:- TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ConvoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConvoListTableViewCell", for: indexPath) as! FriendChatTableViewCell
       
        let Convo = Constants.ConvoArray[indexPath.row]
        
        cell.ProfilePic.setImageForName(Convo.Name, circular: false, textAttributes: nil, gradient: true)
        
        cell.configue(convoID: Convo.ConvoID, name: Convo.Name, profilePic: Convo.ProfilePic, lastMessage: Convo.LastMessage, time: Convo.Time, convoWith: Convo.ConvoUID)
        
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ConversationID = Constants.ConvoArray[indexPath.row].ConvoID
        convoName = Constants.ConvoArray[indexPath.row].Name
        UserID = Constants.ConvoArray[indexPath.row].ConvoUID
        
        let IfGroup = Constants.ConvoArray[indexPath.row].ConvoUID
        
        if IfGroup == "GroupChat"{
            
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = mainStoryboard.instantiateViewController(withIdentifier: "GroupChatViewController") as! GroupChatViewController
            destination.ConversationID = ConversationID
            destination.ConvoName = convoName
            destination.modalPresentationStyle = .fullScreen
            
            self.present(destination, animated: true, completion: nil)
            
        }else{
            performSegue(withIdentifier: "OpenChat", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenChat" {
            let ChatVC = segue.destination as! FChatViewController
            ChatVC.ConversationID = ConversationID
            ChatVC.ConvoName = convoName
            ChatVC.uid = UserID
        }        
    }
}

