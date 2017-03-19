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
        print("Loggé avec succès")
    }

    
  
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()

    
    override func viewDidLoad() {
  

        super.viewDidLoad()
     
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        if let token = FBSDKAccessToken.current() {
            fetchProfile()
        }
    } 
    
    func fetchProfile(){
        print(" ----- fetch profile ------ ")
    
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
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
