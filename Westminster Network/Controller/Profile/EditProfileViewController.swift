//
//  EditProfileViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 03/12/2020.
//

import UIKit
import Firebase
import FirebaseStorage


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var BioField: UITextField!
    @IBOutlet weak var ConvoField: UITextField!
    @IBOutlet weak var UploadImgBtn: UIButton!
    

    var ActiveUser = Auth.auth().currentUser!.uid

    let Name = UserDefaults.standard.string(forKey: "Name")
    let ProPic = UserDefaults.standard.string(forKey: "Profile Picture")
    let Bio = UserDefaults.standard.string(forKey: "Bio")
    let ConvoStarter = UserDefaults.standard.string(forKey: "Convo Starter")
    
    var updatedProPic = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadCurrentData()
        UploadImgBtn.isHidden = true

    }
    func LoadCurrentData(){
        //Profile Picture
        self.ProfilePicture.setImageForName(Name!, circular: false, textAttributes: nil, gradient: true)
        
        //Bio
        self.BioField.text = Bio
        
        //Conversation Starter
        self.ConvoField.text = ConvoStarter
        
        //Name
        self.NameField.text = Name
    }
    
    @IBAction func SaveBtn(_ sender: AnyObject) {
        let Bio = BioField.text
        let Convo = ConvoField.text
        let Name = NameField.text
        
        Constants.db.collection("users").document(Auth.auth().currentUser!.uid).updateData([
                "Name": Name!,
                "Bio": Bio!,
                "Convo Starter":Convo!,
                "Profile Picture": updatedProPic
                
            ]) { err in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    print("Document successfully written!")
                    UserDefaults.standard.setValue(Name, forKey: "Name")
                    UserDefaults.standard.setValue(Bio, forKey: "Bio")
                    UserDefaults.standard.setValue(Convo, forKey: "Convo Starter")
                    
                    self.dismiss(animated: false, completion: nil)

                }
            }
//        }
    }
    
    
    @IBAction func DismissPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
