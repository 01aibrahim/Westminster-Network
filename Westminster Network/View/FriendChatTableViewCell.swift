//
//  FriendChatTableViewCell.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 22/12/2020.
//

import UIKit

class FriendChatTableViewCell: UITableViewCell {

    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var UserLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configue(convoID:String, name:String, profilePic:String, lastMessage:String, time:String, convoWith:String){
        self.UserLabel.text = name
        
    }

}
