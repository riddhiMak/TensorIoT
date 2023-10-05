//
//  AppDelegate.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var navController: UINavigationController!
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        return true
    }

    func moveToLoginScreen(){
        let loginVC = UIStoryboard.login.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

        navController = UINavigationController.init(rootViewController: loginVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
    func moveToProfileScreen(){
        let profileVC = UIStoryboard.profile.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController

        navController = UINavigationController.init(rootViewController: profileVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

}

