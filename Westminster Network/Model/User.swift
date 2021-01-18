//
//  User.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/11/2020.
//

import UIKit

struct User{
    var uid:String!
    var name:String!
    var email:String!
    var DOB:String!
    var Course:String!
    var CourseYR:String!
    var Bio:String!
    var convoStarter:String!
    var photoURL:String!
    
    var dictionary:[String:Any] {
        return [
            "Uid":uid!,
            "Name": name!,
            "Profile Picture": photoURL!,
            "Email": email!,
            "Convo Starter": convoStarter!,
            "Course": Course!,
            "Course Year" : CourseYR!,
            "DOB": DOB!,
            "Bio": Bio!
        ]
    }
}

extension User : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        let Uid = dictionary["Uid"] as? String
        let Name = dictionary["Name"] as? String
        let Email = dictionary["Email"] as? String
        let ProfilePic = dictionary["Profile Picture"] as? String
        let Course = dictionary["Course"] as? String
        let CourseYR = dictionary["Course Year"] as? String
        let DOB = dictionary["DOB"] as? String
        let Bio = dictionary["Bio"] as? String

        self.init(uid:Uid!,name:Name!,email:Email!,DOB:DOB!,Course:Course!,CourseYR:CourseYR!,Bio:Bio!,photoURL:ProfilePic)
    }
}
