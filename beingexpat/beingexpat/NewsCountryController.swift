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
    

    @IBOutlet weak var headNews: UIView!
    var newsArray = [AnyObject]()
    var countryName = ""
    var countryCode = ""
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newsCountry.delegate = self
        self.newsCountry.dataSource = self
        self.newsCountry.isHidden = true
        
        
        let feedURL = "https://api.rss2json.com/v1/api.json?rss_url=http%3A%2F%2Fwww.lemonde.fr%2F\(self.countryName.folding(options: .diacriticInsensitive, locale: .current).lowercased())%2Frss_full.xml&api_key=lvggltdumxzjxsohj7h9raemainxsqf9qxmmknyp"
    
     
        let request = URLRequest(url: URL(string: feedURL)!)
        NSURLConnection.sendAsynchronousRequest(request,queue: OperationQueue.main) { response, data, error in
        let jsonData = data
            let feed = (try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)) as? [String: Any]
     
   
            if let items = feed?["items"] as? [[String:Any]]{
            
                
                    for item in items{
                        dump(item)
                        self.newsArray.append((item as? AnyObject)!)
                        
                    
                    }
                
                
                
            }
            
            self.newsCountry.isHidden = false
            self.loadingMessage.isHidden = true
            self.loadingIndicator.isHidden = true
            self.newsCountry.reloadData()
            
        //let artist = feed?.value(forKeyPath: "feed.entry.im:artist.label") as? String
        
        
        }
     
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArray.count
    }
   
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(indexPath.row == 0){
            return 260
        }else{
            return 100
        }
    }

 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let news = self.newsArray[indexPath.row]
        let enclosure = news["enclosure"] as! [String:Any]
        var identifer: String
        
        if (indexPath.row  == 0){
           identifer = "bigNews"
        }else{
           identifer = "cell"
        }
        
         let cell = tableView.dequeueReusableCell(withIdentifier: identifer) as! NewsCountryCell
        cell.newsTitle.text = news["title"] as! String
        let urlimage = enclosure["link"] as! String
        let imageURL = URL(string: urlimage)!
        print(urlimage)
        print(imageURL)
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            
            if error == nil {
                let downloadImage = UIImage(data: data!)
                
                DispatchQueue.main.async{
                   cell.newsImage.image = downloadImage

                    
                }
                
            }
        }
        
        task.resume()
        cell.layer.backgroundColor = UIColor.clear.cgColor
        self.newsCountry.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.newsImage.setBorder(sizeBorder: 0.1, color: UIColor.gray.cgColor)
        cell.newsImage.layer.cornerRadius = 3
        cell.newsImage.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let news = self.newsArray[indexPath.row]
        let link = news["link"] as! String
        UIApplication.shared.openURL(URL(string: link)!)
    }
    
}
