//
//  ChatTableViewCell.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 29/12/2020.
//

import UIKit
import Firebase

class ChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var MessageLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func configue(sender:String, profilePic:String, message:String, time:String){
  
        MessageLabel.text = message
        NameLabel.text = "\(sender), \(time)"
        
       
    }
}
