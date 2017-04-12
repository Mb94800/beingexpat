//
//  InfosCountryController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 10/04/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation

class InfosCountryController: UIViewController{
    @IBOutlet weak var countryLabelName: UILabel!
    var countryName = ""
    var countryCode = ""
  

    @IBOutlet weak var countryFlag: UIImageView!
    
    @IBOutlet weak var labelCountry: UILabel!
    override func viewDidLoad() {

        super.viewDidLoad()
        self.countryLabelName.text = countryName
        var country = Country(nameCountry:countryName)
        print("Pays choisi: \(country.getNameCountry())")
        labelCountry.updateConstraints()
        getInfosCountry(country: country)
    }
    
    private func getInfosCountry(country: Country){
        let url = URL(string: "\(Constants.RestCountries.APIBaseURL)\(countryCode)")!
        let request = URLRequest(url:url)
        let session = URLSession.shared
  
        
        let task = session.dataTask(with:url) { (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            print(statusCode)
            print(url)
           
            if (statusCode == 200) {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!,  options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                    print("Everyone is fine, file downloaded successfully.")
                    let capital = json["capital"]! as! String
                    let flagurl = json["flag"]! as! String
                    //let currencyCode = currency[code] as? [String:Any]
                    country.setCapitalCountry(capital: capital)
                    let stringImageURL = "http://flags.fmcdn.net/data/flags/w580/\(self.countryCode).png"
                    let imageURL = URL(string: stringImageURL)!
                    
                    let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                        
                        if error == nil {
                            let downloadImage = UIImage(data: data!)
                            
                            DispatchQueue.main.async {
                                self.labelCountry.text?.uppercased()
                                self.countryFlag.image = downloadImage
                            }
                            
                            print(imageURL)
                            
                            
                        }
                    }
                    
                    task.resume()
              
                    country.setFlagCountry(flagCountry: flagurl)
                    
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            
            }
        
           
            
        }
        
        
        
        
        
        
        task.resume()
        

    }
    
    
    
}
