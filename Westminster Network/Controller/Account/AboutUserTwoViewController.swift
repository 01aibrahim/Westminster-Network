//
//  AboutUserTwoViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/11/2020.
//

//MARK: Things to do here

/// Change the variables and call them from the Constants file

import UIKit
import Firebase
import FirebaseStorage
import FirebaseMessaging

class AboutUserTwoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var convoTextField: UITextField!
    @IBOutlet weak var HomeBttn: UIButton!
    
    // User details
    var bio = ""
    var convoStarter = ""
    var profilePictureURL = ""
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeBttn.layer.cornerRadius = 5
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @IBAction func TakeToHomePagePressed(_ sender: Any) {
        //Add to database
        
        if ( bioTextField.text == nil) || (convoTextField.text == nil){
            // UI Alert code
        }else{
            bio = bioTextField.text!
            convoStarter = convoTextField.text!
            
            Constants.db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "Bio": bio,
                "Convo Starter": convoStarter,
                "Profile Picture": profilePictureURL,
                
            ]) { err in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)                } else {
                    print("Document successfully written!")
                    
                    self.performSegue(withIdentifier: "CompletedSignUp", sender: self)
                }
            }
        }
    }
    
    func UserDetails(){
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
                        defaults.set(data!["Profile Picture"] as? String,forKey: "Profile Picture")
                    } else {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        })
    }
        
}

//MARK:- TextField
extension AboutUserTwoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        TakeToHomePagePressed(UIButton())
        textField.resignFirstResponder()
        return true
        
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
