//
//  LogInViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/11/2020.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var SignInBttn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SignInBttn.layer.cornerRadius = 5
    }
    
    
    @IBAction func SignInPressed(_ sender: Any) {
        let email = EmailField.text!
        let password = passwordField.text!
        
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                
                case .userDisabled:
                    let alert = UIAlertController(title: "Account disabled", message: Constants.accountDisabledErrorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                case .invalidEmail:
                    let alert = UIAlertController(title: "Email error", message: Constants.emailErrorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                case .wrongPassword:
                    let alert = UIAlertController(title:"Password error", message: Constants.passwordErrorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                default:
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            } else {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarVC")
                    homeVC.modalPresentationStyle = .fullScreen

                self.present(homeVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func ForgotPasswordPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Forgotten your password", message: "Enter your account email, if account is found, you should get an email, allowing you to reset your password.", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Westminster Email"
        }
        
        alert.addAction(UIAlertAction(title: "Send Email", style: .default)
        { action -> Void in
            let email = alert.textFields![0].text!
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    let Erroralert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    Erroralert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    self.present(Erroralert, animated: true, completion: nil)
                    return
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "StartPage") as! ViewController
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated:true, completion:nil)

    }
    
    
}
