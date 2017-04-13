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
@objc(HomeViewController)
// [START viewcontroller_interfaces]
class HomeViewController: UIViewController, FBSDKLoginButtonDelegate {
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
   
     */
    
    
    @IBOutlet weak var IMAGETEST: UIImageView!
    
    var dataArray = [String]()
    
    var filteredArray = [String]()
    var speciesSearchResults:Array<Country>?
    var shouldShowSearchResults = false

    
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("---------------- LOGGED OUT ------------")
        DispatchQueue.main.async{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewControllerID")
            self.show(vc, sender: self)
        }
    }
    

    func loadListOfCountries() {
    
    }
    



    
    @IBOutlet weak var loginButton: FBSDKLoginButton? = {
            let button = FBSDKLoginButton()
            button.readPermissions = ["email"]
            return button
      
    }()
 
    
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
        
        
        print("Loggé avec succès in HomeView")
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.addSubview(loginButton!)
        
        let params = ["fields" : "email, name"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    
                    var name = responseDictionary["name"]
                    
                    var user = User(name:name as! String,email:responseDictionary["email"] as! String);
                   
                    self.loadUserView(user: user)
                    self.loadFavCountries(user: user)
                    self.createUserInDB(user:user)
                }
            }
        }
        
       

        loginButton?.delegate = self
        
        if (FBSDKAccessToken.current()) != nil {
            
         
            
        }
        
         self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
    }
    
    @IBOutlet weak var BienvenueUser: UILabel!
    func loadUserView(user: User){
        var name = user.name
        self.BienvenueUser.text = "Bienvenue, \(name)  !"
    }
    
    @IBOutlet weak var favCountries: UILabel!
    func loadFavCountries(user: User){
        if(user.favoritesCountries.isEmpty){
            self.favCountries.text = "Aucun pays favori"
        }else{
            self.favCountries.text = "OK"
        }
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
    
    func createUserInDB(user:User){
        
        var request = URLRequest(url:Constants.URLDatabase.createUser!)
        request.httpMethod = "POST"
        let postParameters = "name="+user.getNameUser()+"&email="+user.getEmailUser()
        request.httpBody = postParameters.data(using: .utf8)
        //creating a task to send the post request
        print("juste avant")
        print(user.getEmailUser())
        print(user.getNameUser())
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("error is \(String(describing: error))")
                return;
            }
            
            
            //parsing the response
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var msg : String!
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print("Ah frère y a une erreur là")
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
        
        
    }
}
