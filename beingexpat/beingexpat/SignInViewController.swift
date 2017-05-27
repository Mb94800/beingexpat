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

import Firebase

import SystemConfiguration

// Match the ObjC symbol name inside Main.storyboard.
@objc(SignInViewController)
// [START viewcontroller_interfaces]
class SignInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var ref: FIRDatabaseReference!
    var user: User!
    
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
       

    }

    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if Reachability.isConnectedToNetwork() != true {
             networkUnreacheable();
        }
        self.ref = FIRDatabase.database().reference()
        loginButton?.delegate = self
        self.navigationController?.popToRootViewController(animated: true)
        self.facebookLogin(sender:loginButton!)
    
        
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
    
    }
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
          
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
     
            self.getFBUserInfo()
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                // Present the main view
               
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewControllerID") as! HomeViewController
                
                print("------- SIGNINVIEWCONTROLLER")
                dump(user)
                print("------- SIGNINVIEWCONTROLLER")
                vc.user = self.user
                self.show(vc, sender: self)
                
            })
            
        }   
    }
   

    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var loginButton: FBSDKLoginButton? = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email","public_profile","user_photos","user_birthday"]
        return button
    }()

    

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
        DispatchQueue.main.async{
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewControllerID")
            self.show(vc, sender: self)
        }
    
    }
    
    func getFBUserInfo() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name,photos,birthday"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        request.start { (response, result) in
            switch result {
            case .success(let value):
                let id = value.dictionaryValue!["id"] as! String
                let name = value.dictionaryValue!["name"]
                let email = value.dictionaryValue!["email"]
                let birthday = value.dictionaryValue!["birthday"]
                self.user = User(id: id)
                self.user.setNameUser(name: name as! String)
                self.user.setEmailUser(email: email as! String)
                self.user.setBirthday(birthday: birthday as! String)
                self.ref.child("users/\(id)/").setValue(value.dictionaryValue)
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy"
                let result = formatter.string(from: date)
                self.user.setCreationDate(creationDate: result)
                self.requestProfilePicture(idProfile: id, typeLogin: "fb")
            case .failed(let error):
                print(error)
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
        
        
    }
    
    
    func requestProfilePicture( idProfile : String, typeLogin : String){
        var url: URL!
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let picturesRef = storageRef.child("profilePictures/\(idProfile).png")
        if(typeLogin == "fb"){
            url = URL(string: "https://graph.facebook.com/\(idProfile)/picture?type=normal")
        }
        
     

        print(idProfile)
        print("-------- ID PROFILE")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
         
    
                    let downloadImage = UIImage(data: data!)
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpg"
                
                    let uploadTask = picturesRef.put(data!, metadata: nil) { (metadata, error) in
                        guard let metadata = metadata else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata.downloadURL
                    }
                
                    
            
            
        }

        task.resume()
        
        
    }
}
