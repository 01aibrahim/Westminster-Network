//
//  AddUserToGroupViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 02/01/2021.
//

import UIKit
import Firebase

class AddUserToGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var UsersArray: [User] = [] {
        didSet {
            UsersArray.sort { $0.name < $1.name }
        }
    }
        
    var ConvoID: String! 
    var ConvoName: String!
    var groupIcon:String!
    
    var UID = ""
    var SelectedName = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadUsers()
    }
    
    
    func loadUsers(){
        self.UsersArray = []
        Constants.db.collection("users")
            .addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.UsersArray = querySnapshot!.documents.compactMap({User(dictionary: $0.data())})

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
    }
    //MARK:- IBActions

    @IBAction func AddUserPressed(_ sender: Any) {
        
        let Convo = ["ConversationID":ConvoID!,
                     "ConversationName":ConvoName!,
                     "ConversationPicture":groupIcon!,
                     "ConversationLastMessage":"null",
                     "ConversationTime":"null",
                     "ConvoWith":"GroupChat"]
            as [String : Any]

        Constants.ref.child(Constants.Users)
            .child(UID)
            .child("ConversationList")
            .child(ConvoID)
            .setValue(Convo)
        
        
        let alert = UIAlertController(title: "User Added", message: SelectedName, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
        
    @IBAction func SavePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToChat", sender: self)
    }
    
    //MARK:- Other
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToGroupChat" {
            let VC = segue.destination as! GroupChatViewController
            VC.ConversationID = ConvoID
            VC.ConvoName = ConvoName
        }
    }
    
    
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return UsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! SearchTableViewCell
       
        let user = UsersArray[indexPath.row]
        cell.ProfilePicture.setImageForName(user.name, circular: false, textAttributes: nil, gradient: true)
        cell.configue(ProfilePicture: user.photoURL , Name: user.name, Course: user.Course, CourseYr: user.CourseYR)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UID = UsersArray[indexPath.row].uid
        SelectedName = UsersArray[indexPath.row].name
        
        AddUserPressed(UIButton.self)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}
