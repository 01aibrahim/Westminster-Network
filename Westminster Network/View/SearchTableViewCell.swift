//
//  SearchTableViewCell.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 06/12/2020.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var CourseInfo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configue(ProfilePicture:String!,Name:String!, Course:String!, CourseYr:String!){
        self.CourseInfo.text = "\(Course!), \(CourseYr!)"
        self.Name.text = Name
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
