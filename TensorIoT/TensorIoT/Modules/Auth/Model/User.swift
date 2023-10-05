//
//  User.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import Foundation
struct User {
    let username: String
    let email: String
    let password: String
    let bio: String
    
    var safeEmail: String{
        var safeEmail = email.replacingOccurrences(of: ".", with: "")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "")
        return safeEmail
    }        
}
