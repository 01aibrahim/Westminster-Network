//
//  HomeTableViewCell.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 14/11/2020.
//

import UIKit
import InitialsImageView

public class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Message: UILabel!
    
 

    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func test(){
      
    }
    
    
    
    public func configue(ProfilePicture:String!,Name:String!, Message:String!){
        self.Message.text = Message
        self.Name.text = Name
                
//        if (ProfilePicture != nil){
//            var image = NSData(contentsOf: NSURL(string: ProfilePicture!)! as URL)
//
//            if image == nil{
//                image = NSData(contentsOf: NSURL(string: "https://icon-library.com/images/default-user-icon/default-user-icon-4.jpg")! as URL)
//            }
//            self.ProfilePicture.image =  UIImage(data: image! as Data)
//        }else{
//            self.ProfilePicture.image = UIImage(named: "network")
//        }
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }

}
