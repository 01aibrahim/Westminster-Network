//
//  Database.swift
//  Westminster Network
//
//  Created by Abdulrahman ibrahim on 14/11/2020.
//

import Foundation
import Firebase

struct   {
    static var db = Firestore.firestore()
    static let storage = Storage.storage().reference()
    static let ActiveUser = Auth.auth().currentUser!.uid
    
}
