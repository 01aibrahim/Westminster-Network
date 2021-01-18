//
//  ProfileViewController.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 03/12/2020.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController {

    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var CourseDetailsLabel: UILabel!
    @IBOutlet weak var BioLabel: UILabel!
    @IBOutlet weak var ConvoStaterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadProfile()
    }
    
    func loadProfile(){
        let Name = Constants.defaults.string(forKey: "Name")
        let CourseDet = "\(Constants.defaults.string(forKey: "Course")!), \(Constants.defaults.string(forKey: "Course Year")!)"
        let Bio = Constants.defaults.string(forKey: "Bio")
        let ConvoStarter = Constants.defaults.string(forKey: "Convo Starter")

        self.UserNameLabel.text = Name
        self.ProfilePicture.setImageForName(Name!, circular: false, textAttributes: nil, gradient: true)
        self.CourseDetailsLabel.text = CourseDet
        self.BioLabel.text = Bio
        self.ConvoStaterLabel.text = ConvoStarter
    }
}
