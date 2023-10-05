//
//  LoginViewController.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = str.Login
    }

    @IBAction func btnLoginClicked(_ sender : UIButton){
        if validateFields(){
            txtEmail.resignFirstResponder()
            txtPassword.resignFirstResponder()
            self.showIndicator(withTitle: str.Logging, and: "")

            Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { [weak self] (result, error) in
                guard let self = self else{
                    return
                }
                
                DispatchQueue.main.async {
                    self.hideIndicator()
                }
                
                guard result != nil, error == nil else {
                    Toast.show(message: "\(errorText.failedtologin): \(self.txtEmail.text!)", controller: self)
                    return
                }
                
                UserDefaults.standard.setValue(self.txtEmail.text!, forKey: NSUDKey.Email)
                sharedDelegate.moveToProfileScreen()
            }
        }
    }
    
    @IBAction func btnSignUpClicked(_ sender : UIButton){
        let signUpVC = UIStoryboard.login.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
}

extension LoginViewController {
    func validateFields() -> Bool{
        if txtEmail.text == ""{
            Toast.show(message: errorText.enterEmail, controller: self)
            return false
        }else if !validateEmail(txtEmail.text ?? ""){
            Toast.show(message: errorText.enterValidEmail, controller: self)
            return false
        }else if txtPassword.text == ""{
            Toast.show(message: errorText.enterpassword, controller: self)
            return false
        }
        return true
    }
}
