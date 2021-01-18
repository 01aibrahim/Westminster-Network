//
//  NewGroupDetailsViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 01/01/2021.
//

import UIKit
import Firebase

class NewGroupDetailsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var UploadPictureButton: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var ppLabel: UILabel!
    
    var groupIcon = ""
    var uid = ""
    var ConvoID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConvoID = Constants.randomString(length: 25)
        UploadPictureButton.isHidden = true
        ImageView.isHidden = true
        ppLabel.isHidden = true
    }
    
    //MARK:- Add Image
    @IBAction func AddImagePressed(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true){}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //replace old image with new selected image
            ImageView.image = image
            
            Constants.storage.child("GroupIcon/\(Constants.randomString(length: 10)).png").downloadURL(completion:{ url, error in
                guard let url = url, error == nil else{return}
            
                self.groupIcon = url.absoluteString
            })
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK:- Next

    @IBAction func NextButtonClicked(_ sender: Any) {
        //Save information into DB and take user to next page with an ConvoID
        
        let Convo = ["ConversationID":ConvoID, "ConversationName":TextField.text!, "ConversationPicture":groupIcon,"ConversationLastMessage":"null","ConversationTime":"null","ConvoWith":"GroupChat"]
        
        Constants.ref.child("users")
            .child(Auth.auth().currentUser!.uid)
            .child("ConversationList")
            .child(ConvoID)
            .setValue(Convo)
        
        self.performSegue(withIdentifier: "NewGroupTwo", sender: self)
    }
    

    //MARK:- Cancel Group

    @IBAction func CancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

//MARK:- Others
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewGroupTwo" {
            let VC = segue.destination as! AddUserToGroupViewController
            VC.ConvoID = ConvoID
            VC.ConvoName = TextField.text!
            VC.groupIcon = groupIcon
        }
    }
}
