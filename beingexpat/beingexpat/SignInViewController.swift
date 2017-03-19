//
//  SignInViewController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 19/03/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import UIKit
import GoogleSignIn


import FacebookCore
import FacebookLogin

// Match the ObjC symbol name inside Main.storyboard.
@objc(SignInViewController)
// [START viewcontroller_interfaces]
class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!

    
    override func viewDidLoad() {
  
        if AccessToken.current != nil {
            self.performSegue(withIdentifier: "ouaiouai", sender: nil)
        }
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
