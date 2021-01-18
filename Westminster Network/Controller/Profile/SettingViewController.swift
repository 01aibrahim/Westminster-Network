//
//  SettingViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 03/12/2020.
//

import UIKit
import Firebase
import MessageUI


class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
       
    @IBOutlet weak var tableView: UITableView!
    
    var ActiveUser = Auth.auth().currentUser!.uid
    var array = ["App Information","Change Password", "Invite a Friend", "Request Your Data", "Request to be an Official account", "Contact us", "Terms of Service","Delete Account","Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        
        cell.textLabel?.text = array[indexPath.row]
        
        if array[indexPath.row] == "Log Out"{
            cell.textLabel?.textColor = UIColor.red
        }
        
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedName = array[indexPath.row]
        
        switch selectedName {
        case "App Information":
            appInfo()
        case "Change Password":
            changePassword()
        case "Invite a Friend":
            share()
        case "Request Your Data":
            userData()
        case "Request to be an Official account":
            officialAccount()
        case "Contact us":
            contactUS()
        case "Terms of Service":
            termsService()
        case "Delete Account":
            delete()
        case "Log Out":
            logOut()
        default:
            print("others")
        }
    }
    
    //MARK:- App Information
    func appInfo(){
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let message = "Made by Abdulrahman Ibrahim @01aibrahim for Final Year project."
        
        let alert = UIAlertController(title: "Westminster Network, Version:\(version ?? "")", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    //MARK:- User Requested data
    func userData(){
        let alert = UIAlertController(title: "Confirm your email address", message: "A PDF file of all data of you, will be sent to you via email within 5 working days.", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Westminster Email"
        }
        
        alert.addAction(UIAlertAction(title: "Request Data", style: .default)
        { action -> Void in
            let email = alert.textFields![0].text!
            
            Constants.db.collection("Request Data").document(self.ActiveUser).setData([
                "Email": email,
                "UID": self.ActiveUser,
                "Completed": false
                
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
    
    //MARK:- Change Password
    func changePassword(){
        let alert = UIAlertController(title: "What is your email address", message: "You should get an email where you will be able to change your password.", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) in
               textField.placeholder = "Westminster Email"
           }

        alert.addAction(UIAlertAction(title: "Send Email", style: .default)
        { action -> Void in
            let email = alert.textFields![0].text!
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    //MARK:- Share to friends
    func share(){
        let items: [Any] = ["Hey!, I'm using this Westminster Uni app to keep up to date with everything, download it here", URL(string: "http://www.westminster.ac.uk")!]

        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    //MARK:- Official Account
    func officialAccount(){
        let alert = UIAlertController(title: "Why should you be an official account?", message: "Official accounts can only be given to Westminster or UWSU services (Societies, services such as Career", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Reason"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default)
        { action -> Void in
            let reason = alert.textFields![0].text!
            
            Constants.db.collection("Official Account").document(self.ActiveUser).setData([
                "Reason": reason,
                "UID": self.ActiveUser,
                "Completed": false
                
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
    
    //MARK:- Contact Us
    func contactUS(){
        //Either tell user to message us via the app or to email us
    }
    
    
    //MARK:- Terms of Service
    func termsService(){
        //Create notion page of app services and policies
    }
    
    
    //MARK:- Delete Account
    func delete(){
        let alert = UIAlertController(title: "You will need to sign in", message: "To confirm  , you are required to log in again. ", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Westminster Email"
        }
        
        alert.addAction(UIAlertAction(title: "Delete account", style: .default)
        { action -> Void in
            let email = alert.textFields![0].text!
            
            Constants.db.collection("Delete Users").document(self.ActiveUser).setData([
                "Email": email,
                "UID": self.ActiveUser,
                "Completed": false
                
            ]) { err in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "StartPage") as! ViewController
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated:true, completion:nil)
                
            } catch let err as NSError {
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
    
            }

        })
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    //MARK:- Log out
    func logOut(){

        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive)
        { action -> Void in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "StartPage") as! ViewController
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated:true, completion:nil)

            } catch let err as NSError {
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        })
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
