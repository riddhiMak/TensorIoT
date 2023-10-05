//
//  Text.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import Foundation
var str = Text()
var errorText = ErrorText()

struct Text {
    var Login = "Login"
    var Register = "Register"
    var Logging = "Lodding"
    var searchCity = "Search City"
    var WeatherDetails = "Weather Details"
    var ChooseImage = "Choose Image"
    var gallary = "Gallary"
    var camera = "Camera"
    var Cancel = "Cancel"
    var Settings = "Settings"
    var ok = "Ok"
}

struct ErrorText {
    var emailExits = "Email Exists"
    var enableCameraaccess = "Unable to access the Camera"
    var camerainfo = "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app"
    var InsertUserdidfailed = "Insert User did failed"
    var enterEmail = "Enter Email"
    var enterValidEmail = "Enter Valid Email"
    var enterpassword = "Enter Password"
    var enterconfirmpassword = "Enter Confirm Password"
    var confirmpasswordnotmatch = "Password and Confirm password should be same"
    var enterusername = "Enter Username"
    var enterbio = "Enter a short bio"
    var failedtologin = "Fail to login with email"
}
