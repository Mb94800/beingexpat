//
//  ViewController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 19/03/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn

@objc(SignInViewController)
class SignInViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var signInButton: GIDSignInButton!
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if user != nil {
                MeasurementHelper.sendLoginEvent()
                dump(user)
                self.performSegue(withIdentifier: Constants.Segues.SignInToBe, sender: nil)
            }
        }
    }
    
    deinit {
        if let handle = handle {
            FIRAuth.auth()?.removeStateDidChangeListener(handle)
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
}


