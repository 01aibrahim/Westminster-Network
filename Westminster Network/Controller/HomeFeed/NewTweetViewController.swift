//
//  NewTweetViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 14/11/2020.
//

import UIKit
import Firebase


class NewTweetViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{

    var ActiveUser = Auth.auth().currentUser?.uid
    var postID = ""

    @IBOutlet weak var TweetTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UItextfield()
        postID = Constants.randomString(length: 15)
    }
    
    func UItextfield(){
        TweetTextView.textContainerInset = UIEdgeInsets(top: 30,left: 20,bottom: 20,right: 20)
        TweetTextView.text = Constants.tweetPlaceholder
        TweetTextView.textColor = UIColor.lightGray
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(TweetTextView.textColor == UIColor.lightGray){
            TweetTextView.text = ""
            TweetTextView.textColor = UIColor.black
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    @IBAction func sendTweet(_ sender: Any) {
        if(TweetTextView.text.count > 0){
            Constants.db.collection("Posts").document(postID).setData([
                "PostID": postID,
                "Post": TweetTextView.text!,
                "UID": Constants.defaults.string(forKey: "UID")!,
                "Name": Constants.defaults.string(forKey:"Name")!,
                "Profile Picture" : "image",
                "TimeStamp": NSDate().timeIntervalSince1970,

            ]) { err in
                if let err = err {
                    let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                } else {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
}
