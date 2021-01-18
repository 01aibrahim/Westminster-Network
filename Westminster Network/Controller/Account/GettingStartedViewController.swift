//
//  GettingStartedViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/11/2020.
//

import UIKit
import Firebase

class GettingStartedViewController: UIViewController, UITextFieldDelegate {

    //Create Account
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var EmailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var FirstContinueButton: UIButton!
    var EmailValid = false
    var PasswordValid = false
    
    //UserData
    var userID = ""
    var email = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
           nextField.becomeFirstResponder()
        } else {
           // Not found, so remove keyboard.
           textField.resignFirstResponder()
        }
        return true
    }
    
        
    //MARK: Validation
        
        func validateEmail(_ email: String){
            
            func isValidEmail(_ email: String) -> Bool {
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

                let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailPred.evaluate(with: email)
            }
            
            if (((email.contains(Constants.emailDomain))) == true) && isValidEmail(email) == true{
                   EmailValid = true
            }else{
                // is not a westminster email address
                let alert = UIAlertController(title: Constants.inCorrectEmailDomainTitle, message: Constants.inCorrectEmailDomainMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                EmailValid = false

            }
        }
        
        func validatePassword(_ password:String, confirmPassword: String) {
            
            func isValidPassword(_ password: String) -> Bool{
                //Ensures that the password is atleast 6 Chara, There is atleast one Uppercase, Lowercase and Number.
                
                let passwordPred = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}")
                return passwordPred.evaluate(with: password)
            }
            
            if (isValidPassword(password) == true) && (password == confirmPassword){
                PasswordValid = true
            }else{
                //Password is not valid
                if isValidPassword(password) == false{
                    
                    let alert = UIAlertController(title:Constants.incorrectPasswordTitle , message: Constants.incorrectPasswordMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    PasswordValid = false
                }else if password != confirmPassword{
                    
                    let alert = UIAlertController(title: Constants.passwordNotMatchingTitle, message: Constants.passwordNotMatchingMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    PasswordValid = false
                }
            }
        }
    
    //MARK: Continue Button Pressed
    
    @IBAction func FirstContinueTapped(_ sender: Any) {
        email = EmailAddressField.text!
        let firstPassword = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        
        
        // Validate the fields
        
        validateEmail(email)
        validatePassword(firstPassword, confirmPassword: confirmPassword)
        
        if fullNameField == nil{
            let alert = UIAlertController(title:Constants.nameIsEmptyTitle, message: Constants.nameIsEmptyMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            name = fullNameField.text!
        }
        
        if (EmailValid == true) && (PasswordValid == true){
            //Database creatation
            Auth.auth().createUser(withEmail: email, password: confirmPassword) { authResult, error in
                if let e = error{
                    // Create UI alert to let user know that there is an error
                    let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                }else{
                    Constants.db.collection("users").document(Auth.auth().currentUser!.uid).setData([
                        "Uid":Auth.auth().currentUser!.uid,
                        "Name": self.name,
                        "Email": self.email
                    ]) { err in
                        if let err = err {
                            let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        } else {
                        }
                    }
                    self.performSegue(withIdentifier: "AboutYouFirst", sender: self)
                    
                }
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Please double check and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "StartPage") as! ViewController
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated:true, completion:nil)
    }
}




