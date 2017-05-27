//
//  SearchCountryViewController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 26/03/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation

class SearchCountryViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource,  UISearchBarDelegate
{
    
    @IBOutlet weak var tableCountries: UITableView!
    @IBOutlet weak var countrySearchBar: UISearchBar!
    
    @IBOutlet weak var imagetest: UIImageView!
    
    var searchActive : Bool = false
   
    var filtered:[String] = []
    var codeCountry: String?
    var user:User!
    var listCountries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
            /* Setup delegates */
            self.tableCountries.delegate = self
            self.tableCountries.dataSource = self
            self.countrySearchBar.delegate = self
            var timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: "update", userInfo: nil, repeats: true)
            
            RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)        
      
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func update() {
        
      
      
            self.tableCountries.reloadData()
            
        print("called")
        
    }

    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        tableCountries.reloadData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

        
        if segue.identifier == "infosCountry" {
            
        
            let barViewControllers = segue.destination as! UITabBarController
            
            if let destination = barViewControllers.viewControllers?[0] as? InfosCountryController {
                let news = barViewControllers.viewControllers?[1] as? NewsCountryController
                
                let path = tableCountries.indexPathForSelectedRow
                let cell = tableCountries.cellForRow(at: path!)
                news?.countryName = (cell?.textLabel?.text!)!
                destination.countryCode = codeCountry!
                destination.countryName = (cell?.textLabel?.text!)!
            }
            
            
            

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCountries.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var alertView = UIAlertView()
        alertView.addButton(withTitle: "Ok")
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let country = self.listCountries[indexPath.row]
        codeCountry = country.getCodeCountry()
      
        
        super.performSegue(withIdentifier: "infosCountry", sender: cell)
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
        let country = self.listCountries[indexPath.row]
        cell.textLabel?.text = country.getNameCountry()
        cell.layer.backgroundColor = UIColor.clear.cgColor
        self.tableCountries.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
}
