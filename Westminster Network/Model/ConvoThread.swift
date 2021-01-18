//
//  ConvoThread.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 26/12/2020.
//

import Foundation

class ConvoThread {
    let Sender:String
    let ProfilePic: String
    let Message: String
    let Time: String
    
    
    init(sender:String, profilePic:String, message:String, time:String) {
        self.Sender = sender;
        self.ProfilePic = profilePic;
        self.Message = message;
        self.Time = time;
    }
    
}
