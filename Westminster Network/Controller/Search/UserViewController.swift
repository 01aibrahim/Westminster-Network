//
//  UserViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 21/12/2020.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class UserViewController: UIViewController {
    
    @IBOutlet weak var ProfileView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var CourseDetails: UILabel!
    @IBOutlet weak var BioLabel: UILabel!
    @IBOutlet weak var ConvoStarterLabel: UILabel!
    @IBOutlet weak var MessageButton: UIButton!
    
    var uid: String!
    var Name = ""
    var Course = ""
    var CourseYr = ""
    var Bio = ""
    var ConvoStarter = ""
    var ProfilePic = ""
    var convoID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileView.isHidden = true
        NameLabel.isHidden = true
        CourseDetails.isHidden = true
        BioLabel.isHidden = true
        ConvoStarterLabel.isHidden = true
        MessageButton.isHidden = true
        
        loadUser()
    }
    
    func loadUser() {
        Constants.db.collection(Constants.Users).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.Name = (data!["Name"] as? String)!
                self.Course = (data!["Course"] as? String)!
                self.CourseYr = (data!["Course Year"] as? String)!
                self.Bio = (data!["Bio"] as? String)!
                self.ConvoStarter = (data!["Convo Starter"] as? String)!
                
                self.NameLabel.text = self.Name
                self.CourseDetails.text = "\(self.Course), \(self.CourseYr)"
                self.BioLabel.text = self.Bio
                self.ConvoStarterLabel.text = self.ConvoStarter
                self.ProfileView.setImageForName(self.Name, circular: false, textAttributes: nil, gradient: true)
                
                self.ProfileView.isHidden = false
                self.NameLabel.isHidden = false
                self.CourseDetails.isHidden = false
                self.BioLabel.isHidden = false
                self.ConvoStarterLabel.isHidden = false
                self.MessageButton.isHidden = false
                
            } else {
                let alert = UIAlertController(title: Constants.ErrorAlertTitle, message: error?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default)
                { action -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func StartConversationClicked(_ sender: Any) {
        // Start a converstation with that user
        convoID = Constants.randomString(length: 25)
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yy HH:mm"
        let dateString = df.string(from: date)
        
        let ConvoFrom = ["ConversationID":convoID,
                         "ConversationName":Name,
                         "ConversationPicture":ProfilePic,
                         "ConversationLastMessage": "null",
                         "ConversationTime": dateString,
                         "ConvoWith": uid!,
                         "ConvoStarted": true]
            as [String : Any]
        
        let ConvoTo = ["ConversationID":convoID,
                       "ConversationName": Constants.defaults.string(forKey: "Name")!,
                       "ConversationPicture": Constants.defaults.string(forKey: "Profile Picture")!,
                       "ConversationLastMessage": "null",
                       "ConversationTime": dateString,
                       "ConvoWith": Auth.auth().currentUser!.uid,
                       "ConvoStarted": true]
            as [String : Any]
        
        Constants.ref.child(Constants.Users)
            .child(Auth.auth().currentUser!.uid)
            .child("ConversationList")
            .child(uid)
            .setValue(ConvoFrom)
        
        Constants.ref.child(Constants.Users)
            .child(uid)
            .child("ConversationList")
            .child(Auth.auth().currentUser!.uid)
            .setValue(ConvoTo)
        
        self.performSegue(withIdentifier: "StartChat", sender: self)
    }
    
    @IBAction func MoreClicked(_ sender: Any) {
        let alert = UIAlertController(title: Constants.ReportAlertTitle , message: Constants.ReportAlertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Spam", style: .default)
        { action -> Void in
            Constants.db.collection(Constants.Report).document("SPAM: \(self.uid!)").setData([
                "From user": Auth.auth().currentUser!.uid,
                "Report Type": "Spam",
                "Resolved": false
            ]) { err in
                if let err = err {
                    let alert = UIAlertController(title: Constants.ErrorAlertTitle, message: err.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default)
                    { action -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {}
            }
        })
        
        alert.addAction(UIAlertAction(title: "Inappropriate", style: .default)
        { action -> Void in
            Constants.db.collection("Report").document("INAPP: \(self.uid!)").setData([
                "From user": Auth.auth().currentUser!.uid,
                "Report Type": "Inappropriate",
                "Resolved": false
            ]) { err in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        })
        
        alert.addAction(UIAlertAction(title: "Not from westminster", style: .default)
        { action -> Void in
            Constants.db.collection("Report").document("Invalid: \(self.uid!)").setData([
                "From user": Auth.auth().currentUser!.uid,
                "Report Type": "Invalid",
                "Resolved": false
            ]) { err in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        })
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartChat" {
            let VC = segue.destination as! FChatViewController
            VC.ConversationID = convoID
            VC.ConvoName = Name
            VC.uid = uid
        }
    }
}
