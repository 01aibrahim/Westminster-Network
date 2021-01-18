//
//  FeedConvo.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 20/12/2020.
//

import Foundation


class FeedConvo {
    let ConvoID: String
    let Name: String
    let ProfilePic: String
    let LastMessage: String
    let Time: String
    let ConvoUID: String
    
    
    init(convoID:String, name:String, profilePic:String, lastMessage:String, time:String, convoUid:String ) {
        self.ConvoID = convoID;
        self.Name = name;
        self.ProfilePic = profilePic;
        self.LastMessage = lastMessage;
        self.Time = time;
        self.ConvoUID = convoUid
    }
    
}

 
