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
    var data = [
        ["name" : "AUSTRALIE", "code" : "au"],
        ["name" : "ALLEMAGNE", "code" : "de"],
        ["name" : "CHINE", "code" : "cn"],
        ["name" : "ESPAGNE", "code" : "es"],
        ["name" : "ÉTATS-UNIS", "code" : "us"],
        ["name" : "ROYAUME-UNI", "code" : "gb"]
    ]
    var filtered:[String] = []
    var codeCountry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableCountries.delegate = self
        tableCountries.dataSource = self
        countrySearchBar.delegate = self
     
        
        
         self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print("preparing")
        if segue.identifier == "infosCountry" {
            if let destination = segue.destination as? InfosCountryController {
                
                let path = tableCountries.indexPathForSelectedRow
                let cell = tableCountries.cellForRow(at: path!)
                destination.countryCode = codeCountry!
                destination.countryName = (cell?.textLabel?.text!)!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var alertView = UIAlertView()
        alertView.addButton(withTitle: "Ok")
        
        let cell = tableView.cellForRow(at: indexPath)
        
       let country = self.data[indexPath.row]
        codeCountry = country["code"]
        alertView.title = "Pays selectionné"
        alertView.message = country["name"]
        alertView.show()
        
        super.performSegue(withIdentifier: "infosCountry", sender: cell)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
          let country = self.data[indexPath.row]
        cell.textLabel?.text = country["name"]
        cell.layer.backgroundColor = UIColor.clear.cgColor
        self.tableCountries.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
}
