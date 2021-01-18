//
//  ServicesTableViewCell.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/01/2021.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configue(Name:String, Link:String){
        NameLabel.text = Name
    }

}
