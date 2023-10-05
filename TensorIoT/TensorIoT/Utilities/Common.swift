//
//  Common.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import Foundation
import UIKit


var sharedDelegate: AppDelegate = {
    return UIApplication.shared.delegate as! AppDelegate
}()

func validateEmail(_ email:String) -> Bool{
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

