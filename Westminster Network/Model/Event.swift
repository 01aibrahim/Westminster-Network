//
//  Event.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 10/01/2021.
//

import Foundation

struct Event {
    var Name: String!
    var OrganisationName: String!
    var Date: String!
    var Link: String!
    
    var dictionary:[String:Any] {
        return [
            "Event Name": Name!,
            "Organisation Name": OrganisationName!,
            "Date": Date!,
            "Link": Link!
        ]
    }
}


extension Event : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        let name = dictionary["Event Name"] as? String
        let organName = dictionary["Organisation Name"] as? String
        let date = dictionary["Date"] as? String
        let link = dictionary["Link"] as? String
        
        self.init(Name: name!,OrganisationName: organName!, Date: date!, Link: link!)
    }
}
