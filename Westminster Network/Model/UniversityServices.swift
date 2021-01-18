//
//  UniversityServices.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 04/01/2021.
//

import Foundation


struct UniversityServices {
    var Name: String!
    var Link: String!
    
    var dictionary:[String:Any] {
        return [
            "Name":Name!,
            "Link" : Link!,
        ]
    }
}


extension UniversityServices : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        let name = dictionary["Name"] as? String
        let link = dictionary["Link"] as? String
        
        self.init(Name: name!, Link: link!)
    }
}
