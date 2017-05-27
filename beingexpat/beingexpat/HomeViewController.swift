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
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


// Match the ObjC symbol name inside Main.storyboard.
@objc(HomeViewController)
// [START viewcontroller_interfaces]
class HomeViewController: UIViewController, FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource {
   

    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
   
     */
    
   
    @IBOutlet weak var goToProfile: UIButton!
    
    @IBOutlet weak var logout: FBSDKLoginButton!
    var ref: FIRDatabaseReference!
    var codeCountry: String?
    var dataArray = [String]()
    var FCArray = [String]()
    var filteredArray = [String]()
    var speciesSearchResults:Array<Country>?
    var shouldShowSearchResults = false
    var user: User!
    var listAllCountries = [Country]()
    var listCountries = [
        ["name" : "AUSTRALIE", "code" : "au"],
        ["name" : "ALGÉRIE","code" : "dz"],
        ["name" : "ALLEMAGNE", "code" : "de"],
        ["name" : "BRÉSIL", "code" : "br"],
        ["name" : "CANADA","code":"ca"],
        ["name" : "CHINE", "code" : "cn"],
        ["name" : "COREE DU SUD", "code" : "kr"],
        ["name" : "ESPAGNE", "code" : "es"],
        ["name" : "ÉTATS-UNIS", "code" : "us"],
        ["name" : "IRAN", "code" : "ir"],
        ["name" : "IRLANDE", "code" : "ie"],
        ["name" : "ITALIE", "code" : "it"],
        ["name" : "JAPON", "code" : "jp"],
        ["name" : "MAROC", "code" : "ma"],
        ["name" : "NOUVELLE-ZÉLANDE", "code" : "nz"],
        ["name" : "ROYAUME-UNI", "code" : "gb"],
        ["name" : "SUISSE", "code" : "ch"]
        
    ]
    
    
    @IBOutlet weak var searchcountry: UIButton!
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FCArray.count
    }
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.loadAllCountries()
        self.navigationItem.setHidesBackButton(true, animated:true);
        view.addSubview(loginButton!)
        //favCountries.delegate = self
        //favCountries.dataSource = self
        let params = ["fields" : "email, name"]
        self.loadUserView(user: self.user)
        //self.loadFavCountries(user: self.user)
     
      
        
        
        
        loginButton?.delegate = self
        
        if (FBSDKAccessToken.current()) != nil {
            
            
            
        }
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
        print("------- HOMEINVIEWCONTROLLER")
        dump(user)
        print("------- HOMEINVIEWCONTROLLER")
    }
    

    
    @IBAction func buttonPressed(sender: AnyObject) {
       
       
        self.performSegue(withIdentifier: "searchcountry", sender: sender)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchcountry" {
          
            
         
                let destinationController = segue.destination as!   SearchCountryViewController
                
                destinationController.user = self.user
                destinationController.listCountries = self.listAllCountries
                
            
            
            
        }else if segue.identifier == "infosCountry" {
            let barViewControllers = segue.destination as! UITabBarController
        
        
            if let destination = barViewControllers.viewControllers?[0] as? InfosCountryController {
            
                let path = favCountries.indexPathForSelectedRow
                let cell = favCountries.cellForRow(at: path!)
                destination.countryCode = codeCountry!
                destination.countryName = (cell?.textLabel?.text!)!
            }
        }else if segue.identifier == "goToProfile" {
            let destinationController = segue.destination as!   UserInfosController
            destinationController.user = self.user
        }
    
    }
    
    public func loadAllCountries(){
        ref.child("countries").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
           
                for rest in (snapshot.children.allObjects as? [FIRDataSnapshot])!{
                    if let namecountry = rest.childSnapshot(forPath: "nameCountry").value as? String{
                        var country = Country(nameCountry:namecountry)
                        if let codecountry = rest.childSnapshot(forPath: "codeCountry").value as? String{
                            country.setCodeCountry(code: codecountry)
                        }
                        if let nbFR2015 = rest.childSnapshot(forPath: "nbFR2015").value as? String{
                            country.setNbFrench2015(nb2015: nbFR2015)
                        }
                        if let nbFR2016 = rest.childSnapshot(forPath: "nbFR2016").value as? String{
                            country.setNbFrench2016(nb2016: nbFR2016)
                        }
                        
                        self.listAllCountries.append(country)
                    }
                    
                   // var country = Country(nameCountry: (rest.childSnapshot(forPath: "nameCountry").value as? String)!)
                    
          
                     //country.setCodeCountry(code: (rest.childSnapshot(forPath:"codeCountry").value as? String)!)
                    // country.setNbFrench2015(nb2015: rest.childSnapshot(forPath: "nbFR2015").value as! NSNumber)
                    // country.setNbFrench2016(nb2016: rest.childSnapshot(forPath: "nbFR2016").value as! NSNumber)
                    //self.listAllCountries.append(country)
                }
  
        })
    }
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("---------------- LOGGED OUT ------------")
        DispatchQueue.main.async{
            //let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //  let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewControllerID")
            //self.show(vc, sender: self)
        }
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
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
    }
    
    @IBOutlet weak var BienvenueUser: UILabel!
    func loadUserView(user: User){
        var name = user.name
       // self.BienvenueUser.text = "Bienvenue, \(name)  !"
    }
    

    
    @IBOutlet weak var favCountries: UITableView!
    func loadFavCountries(user: User){
        
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
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
        let favcountry = self.FCArray[indexPath.row]
        cell.textLabel?.text = favcountry
        cell.layer.backgroundColor = UIColor.clear.cgColor
        self.favCountries.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var alertView = UIAlertView()
        alertView.addButton(withTitle: "Ok")
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let favcountries = self.user.getFCUser()
        let country = favcountries[indexPath.row]
        
        
        
        super.performSegue(withIdentifier: "infosCountry", sender: cell)
    }
}
