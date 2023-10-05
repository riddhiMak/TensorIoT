//
//  SignUpViewController.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import FirebaseAuth
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtConfirmPassword : UITextField!
    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtBio : UITextField!
    
    private var picker = UIImagePickerController()
    var rootRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureComponent()
        configureFirebaseDatabase()
    }
    
    func configureFirebaseDatabase(){
        rootRef = Database.database().reference().child(FirebaseCollections.FUsers)
    }
    
    func configureNavigationBar() {
        navigationItem.title = str.Register
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // change title color
        let textChangeColor = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        navigationController?.navigationBar.titleTextAttributes = textChangeColor
        navigationController?.navigationBar.largeTitleTextAttributes = textChangeColor
        
        // configure right bar button
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(btnProfileTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
    }
   
    func configureComponent(){
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.layer.masksToBounds = true
        
    }
   
    
    @objc func btnProfileTapped(){
        var alert = UIAlertController(title: str.ChooseImage, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: str.camera, style: .default){
            UIAlertAction in
            self.checkCameraAccess()
        }
        let galleryAction = UIAlertAction(title: str.gallary, style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: str.Cancel, style: .cancel){
            UIAlertAction in
        }
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
   
    
}

extension SignUpViewController {
    @IBAction func btnSignUpClicked(_ sender : UIButton){
        if validateFields(){
            
            self.showIndicator(withTitle: str.Logging, and: "")
            
            DatabaseManager.shared.userExists(with: txtEmail.text!, completion: { [weak self] exist in
                guard let self = self else{
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
                guard !exist else{
                    // Email Exist
                    Toast.show(message: errorText.emailExits, controller: self)
                    return
                }
                
                // Email not Exist
                Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { (result, error) in
                    guard result != nil, error == nil else{
                        return
                    }
                    
                    let newUser = User(username: self.txtUserName.text!, email: self.txtEmail.text!, password: self.txtPassword.text!, bio: self.txtBio.text!)
                    
                    DatabaseManager.shared.insertUser(with: newUser, completion: { success in
                        if success{
                            self.hideIndicator()
                            UserDefaults.standard.set(self.txtEmail.text!, forKey: NSUDKey.Email)
                            if let image = self.imgProfile.image{
                                guard let data = image.jpegData(compressionQuality: 0.5) else { return }
                                let encoded = try! PropertyListEncoder().encode(data)
                                UserDefaults.standard.set(encoded, forKey: NSUDKey.profileImage)
                            }
                            sharedDelegate.moveToProfileScreen()
                        }else{
                            Toast.show(message: errorText.InsertUserdidfailed, controller: self)
                            self.hideIndicator()
                        }
                    })
                }
            })
        }
    }
}

extension SignUpViewController {
    func openGallery()
    {
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.mediaTypes = ["public.image"]
        self.present(picker, animated: true, completion: nil)
    }
    func openCamera(){
        picker.sourceType = UIImagePickerController.SourceType.camera
        self.present(picker, animated: true, completion: nil)
    }
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied,.restricted,.notDetermined:
            showAlert(title: errorText.enableCameraaccess, message: errorText.camerainfo)

        case .authorized:
            openCamera()
        
        default:
            break
        }
    }
    
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
        }else if txtConfirmPassword.text == ""{
            Toast.show(message: errorText.enterconfirmpassword, controller: self)
            return false
        }else if txtPassword.text != txtConfirmPassword.text{
            Toast.show(message: errorText.confirmpasswordnotmatch, controller: self)
            return false
        }else if txtUserName.text == ""{
            Toast.show(message: errorText.enterusername, controller: self)
            return false
        }else if txtBio.text == ""{
            Toast.show(message: errorText.enterbio, controller: self)
            return false
        }
        return true
    }
    
}
extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.editedImage] as? UIImage {
            self.imgProfile.image = image
            return
        }
        
        if let image = info[.originalImage] as? UIImage {
            self.imgProfile.image = image
        }

    }
    
}
extension SignUpViewController {
    func showAlert(title:String, message:String) {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)
            
        let okAction = UIAlertAction(title: str.ok, style: .cancel, handler: nil)
            alert.addAction(okAction)
            
        let settingsAction = UIAlertAction(title: str.Settings, style: .default, handler: { _ in
                // Take the user to Settings app to possibly change permission.
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            // Finished opening URL
                        })
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            })
            alert.addAction(settingsAction)
            
            self.present(alert, animated: true, completion: nil)
        }
}
          
