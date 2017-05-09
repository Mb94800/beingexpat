//
//  NewsCountryController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 22/04/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation

class NewsCountryController: UIViewController,  UITableViewDelegate, UITableViewDataSource,  UISearchBarDelegate{

    @IBOutlet weak var newsCountry: UITableView!
    
    var newsArray = [String]()
    var countryName = ""
    var countryCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newsCountry.delegate = self
        self.newsCountry.dataSource = self
        print(" i wont allow you to do so")
        print(self.countryName)
        let feedURL = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.google.com%2Fnews%3Fcf%3Dall%26hl%3Dfr%26pz%3D1%26ned%3Dfr%26q%3D\(self.countryName.folding(options: .diacriticInsensitive, locale: .current))%26output%3Drss"
        let request = URLRequest(url: URL(string: feedURL)!)
        NSURLConnection.sendAsynchronousRequest(request,queue: OperationQueue.main) { response, data, error in
        let jsonData = data
            let feed = (try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)) as? [String: Any]
            if let items = feed?["items"] as? [[String:Any]] {
                for item in items{
                    
                    self.newsArray.append(item["title"] as! String)
                        
                    
                }
            }
            
            print(self.newsArray)
            print(self.newsArray.count)
            print(self.countryName)
            self.newsCountry.reloadData()
            
        //let artist = feed?.value(forKeyPath: "feed.entry.im:artist.label") as? String
        
        
        }
     
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
        let news = self.newsArray[indexPath.row]
        cell.textLabel?.text = news
        cell.layer.backgroundColor = UIColor.clear.cgColor
        self.newsCountry.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
}
