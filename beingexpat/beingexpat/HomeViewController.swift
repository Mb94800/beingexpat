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
    
    var ref: FIRDatabaseReference!
    var codeCountry: String?
    var dataArray = [String]()
    var FCArray = [String]()
    var filteredArray = [String]()
    var speciesSearchResults:Array<Country>?
    var shouldShowSearchResults = false
    var user = User(name:"",email:"")
    var listCountries = [
        ["name" : "AUSTRALIE", "code" : "au"],
        ["name" : "ALGÉRIE","code" : "dz"],
        ["name" : "ALLEMAGNE", "code" : "de"],
        ["name" : "CHINE", "code" : "cn"],
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
        self.navigationItem.setHidesBackButton(true, animated:true);
        view.addSubview(loginButton!)
        favCountries.delegate = self
        favCountries.dataSource = self
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
                    
                    self.user.setEmailUser(email: responseDictionary["email"] as! String)
                    self.user.setNameUser(name: name as! String)
                    self.loadUserView(user: self.user)
                    //self.loadFavCountries(user: self.user)
                    //self.createUserInDB(user:self.user)
                }
            }
        
        }
        

        
        ref.child("nom").setValue("mohamed")
        loginButton?.delegate = self
        
        if (FBSDKAccessToken.current()) != nil {
            
            
            
        }
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
    }
    

    
    @IBAction func buttonPressed(sender: AnyObject) {
        self.performSegue(withIdentifier: "searchcountry", sender: sender)
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchcountry" {
            let destinationController = segue.destination as!   SearchCountryViewController
        
            destinationController.user = self.user
            destinationController.listCountries = self.listCountries
            
            
            
        }else if segue.identifier == "infosCountry" {
            let barViewControllers = segue.destination as! UITabBarController
        
        
            if let destination = barViewControllers.viewControllers?[0] as? InfosCountryController {
            
                let path = favCountries.indexPathForSelectedRow
                let cell = favCountries.cellForRow(at: path!)
                destination.countryCode = codeCountry!
                destination.countryName = (cell?.textLabel?.text!)!
            }
        }
    
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
        
        var request = URLRequest(url:Constants.URLDatabase.favCountries!)
        request.httpMethod = "POST"
        let postParameters = "email="+user.getEmailUser()
        request.httpBody = postParameters.data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with:request) { (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse

            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do{
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    let countriesJSON = myJSON?["message"]
                    DispatchQueue.main.async(execute: {
                        for anItem in countriesJSON as! [Dictionary<String, Any>] {
                            user.addFavouriteCountry(countryName:anItem["namecountry"] as! String, countrycode:anItem["codeCountry"] as! String)
                    
                        }
                        self.FCArray = user.getFCUser()
                        dump(self.FCArray)
                        dump(user.getFCUser())
                        self.favCountries.reloadData()
                        DispatchQueue.main.async(execute: {
                            self.favCountries.reloadData()
                        })
                    })
                  //  if(user.favoritesCountries.isEmpty){
                  //      self.favCountries.text = "Aucun pays favori"
                  //  }else{
                  //      self.favCountries.numberOfLines = user.getFCUser().count
                  //      self.favCountries.text = 
                  // (user.getFCUser().joined(separator: "\n"))
                  //  }
                }catch{
                    
                }
             

            }
            
            
        }
        
        task.resume()
        
        
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
                 
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
        
        
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
