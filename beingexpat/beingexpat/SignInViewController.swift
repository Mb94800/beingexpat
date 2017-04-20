//
//  SignInViewController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 19/03/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import UIKit
import GoogleSignIn


import FacebookShare
import FacebookCore
import FacebookLogin

import FBSDKCoreKit
import FBSDKLoginKit

import SystemConfiguration

// Match the ObjC symbol name inside Main.storyboard.
@objc(SignInViewController)
// [START viewcontroller_interfaces]
class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
   
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    
        if error != nil{
            print("Un problème a été rencontré. ")
            return
        }
        
        fetchProfile();
        print("Loggé avec succès")
    }

    
    private func getImageFromFlickr() {
        
        let url = URL(string: "\(Constants.Flickr.APIBaseURL)?\(Constants.FlickrParameterKeys.Method)=\(Constants.FlickrParameterValues.GalleryPhotosMethod)&\(Constants.FlickrParameterKeys.APIKey)=\(Constants.FlickrParameterValues.APIKey)&\(Constants.FlickrParameterKeys.GalleryID)=\(Constants.FlickrParameterValues.GalleryID)&\(Constants.FlickrParameterKeys.Extras)=\(Constants.FlickrParameterValues.MediumURL)&\(Constants.FlickrParameterKeys.Format)=\(Constants.FlickrParameterValues.ResponseFormat)&\(Constants.FlickrParameterKeys.NoJSONCallback)=\(Constants.FlickrParameterValues.DisableJSONCallback)")!
        
        print(url)
    }
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var loginButton: FBSDKLoginButton? = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email","public_profile","user_photos","user_birthday"]
        return button
    }()

    
    override func viewDidLoad() {
  
        super.viewDidLoad()

        
        if(!isConnectedToNetwork()){
            networkUnreacheable();
        }
        loginButton?.delegate = self

        self.navigationController?.popToRootViewController(animated: true)
        if (FBSDKAccessToken.current()) != nil {
           
            fetchProfile();
            
        }
    }
    
    func networkUnreacheable(){
         let refreshAlert = UIAlertController(title: "Aucune connexion", message: "Aucune connexion disponible. Cette application nécessite une connexion Internet.", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Quitter", style: .default, handler: { (action: UIAlertAction!) in
            exit(0)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
    
    func fetchProfile(){
        print(" ----- fetch profile ------ ")
        DispatchQueue.main.async{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewControllerID")
            self.show(vc, sender: self)
        }
    
    }
    
    func getFBUserInfo() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        request.start { (response, result) in
            switch result {
            case .success(let value):
                print(value.dictionaryValue)
             
            case .failed(let error):
                print(error)
            }
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        getFBUserInfo()
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")

        
    }
    
    

 
    
    // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                self.performSegue(withIdentifier: "ouaiouai", sender: nil)
                print("Logged in!")
            }
        }
        
        
    }}
