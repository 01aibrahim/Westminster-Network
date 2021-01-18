//
//  FeedMessage.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 15/11/2020.
//

import Foundation


protocol DocumentSerializable  {
    init?(dictionary:[String:Any])
}

struct FeedMessage {
    let postID: String
    let post: String
    let Name: String
    let ProfilePic: String
    let UID: String
    
    var dictionary:[String:Any] {
        return [
            "postID": postID,
            "name":Name,
            "content" : post,
            "Profile Picture" : ProfilePic,
            "UID": UID
        ]
    }
}


extension FeedMessage : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        let postID = dictionary["PostID"] as? String
        let post = dictionary["Post"] as? String
        let Name = dictionary["Name"] as? String
        let ProfilePic = dictionary["Profile Picture"] as? String
        let uid = dictionary["UID"] as? String

        self.init(postID: postID!, post: post!, Name: Name!, ProfilePic: ProfilePic!, UID: uid!)
    }
}
