//
//  ViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 19/09/2020.
//

import UIKit
import Network
import Firebase


class ViewController: UIViewController {

//MARK:- Varibles
    
    /// Opening Page
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    let monitor = NWPathMonitor()

//MARK:- ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartedButton.layer.cornerRadius = 5
        
        //Get user details
        Auth.auth().addStateDidChangeListener({ (Auth, user) in
            if let currentUser = user{
                // User is signed in
                let defaults = UserDefaults.standard
                 defaults.set(currentUser.uid, forKey: "UID")
                
                // Get user data from DB
                Constants.db.collection("users").document(currentUser.uid).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        defaults.set(data!["Name"] as? String,forKey: "Name")
                        defaults.set(data!["Email"] as? String,forKey: "Email")
                        defaults.set(data!["DOB"] as? String,forKey: "DOB")
                        defaults.set(data!["Course"] as? String,forKey: "Course")
                        defaults.set(data!["Course Year"] as? String,forKey: "Course Year")
                        defaults.set(data!["Bio"] as? String,forKey: "Bio")
                        defaults.set(data!["Convo Starter"] as? String,forKey: "Convo Starter")
                       } else {
                           print("Document does not exist")
                       }
                }
                // Send user to log in page
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarVC")
                    homeVC.modalPresentationStyle = .fullScreen

                self.present(homeVC, animated: true, completion: nil)
            }
        })
    }

}

