//
//  InfosCountryController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 10/04/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation
import GoogleMaps
class InfosCountryController: UIViewController{
    @IBOutlet weak var countryLabelName: UILabel!
    var countryName = ""
    var countryCode = ""
  

    @IBOutlet weak var countryFlag: UIImageView!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var addFavCountry: UIImageView!
    @IBOutlet weak var labelCountry: UILabel!
    
    @IBOutlet weak var populationCountry: UILabel!
    
    @IBOutlet weak var capitalCountry: UILabel!
    
    
    @IBOutlet weak var french2015: UILabel!
    @IBOutlet weak var french2016: UILabel!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.countryLabelName.text = countryName
        var country = Country(nameCountry:countryName)
        print("Pays choisi: \(country.getNameCountry())")
        labelCountry.updateConstraints()
        let tap = UITapGestureRecognizer(target: self, action: #selector(InfosCountryController.tappedMe))
        addFavCountry.addGestureRecognizer(tap)
        addFavCountry.isUserInteractionEnabled = true
       
        lineDraw(lineView:lineView)
        getInfosCountry(country: country)
        getNbFrenchAbroad(country: country)
        setInfosCountryUI(country:country)
        loadGMView(country:country)
    }
    
    @IBOutlet weak var countryView: GMSMapView!
    func loadGMView(country: Country){
        let camera = GMSCameraPosition.camera(withLatitude: -10, longitude: 151.20, zoom: 4.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
       
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -10, longitude: 151.20)
        marker.title = country.getCapitalCountry()
        marker.snippet = country.getNameCountry()
        marker.map = mapView
        self.countryView = mapView
    }
    func lineDraw(lineView:UIView)
    {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: view.frame.size.height - width, width:  lineView.frame.size.width, height: lineView.frame.size.height)
        border.borderWidth = width
        lineView.layer.addSublayer(border)
        lineView.layer.masksToBounds = true
    }
    
    func tappedMe(){
        let refreshAlert = UIAlertController(title: "Ajouter un pays en favori", message: "Souhaitez-vous ajouter ce pays dans vos favoris ?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    public func setInfosCountryUI(country: Country){
        self.labelCountry.text?.uppercased()
        self.populationCountry.text = String((country.getPopulationCountry()) + " habitants")
        self.capitalCountry.text = country.getCapitalCountry()
        self.french2015.text = ((country.getNbFrench2015()) + " français en 2015")
        self.french2016.text = ((country.getNbFrench2016()) + " français en 2016")
        print(country.getNbFrench2015())
        print(country.getNbFrench2016())
        
    }
    
    private func getNbFrenchAbroad(country: Country){
        print("we both know")
        print("we both know")
        print(Constants.URLDatabase.infosCountries)
        var request = URLRequest(url:Constants.URLDatabase.infosCountries!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        let postParameters = "country="+(country.getNameCountry().uppercased())
        request.httpBody = postParameters.data(using: .utf8)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                do{
                    let json =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //parsing the json
                    if let parseJSON = json {
                        
                        var nbFR2015 : String!
                        var nbFR2016 : String!
                        
                        nbFR2015 = parseJSON["nbFR2015"]! as! String
                        nbFR2016 = parseJSON["nbFR2016"]! as! String
                        
                        country.setNbFrench2015(nb2015: nbFR2015)
                        country.setNbFrench2016(nb2016: nbFR2016)
        
                    }

                }catch{
                     print("Error with Json: \(error)")
                }
                
            }else{
                print("Error")
            }
        }
        
        task.resume();

    }
    
    private func getInfosCountry(country: Country){
        let url = URL(string: "\(Constants.RestCountries.APIBaseURL)\(countryCode)")!
        let request = URLRequest(url:url)
        let session = URLSession.shared
  
        
        let task = session.dataTask(with:url) { (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
           
           
            if (statusCode == 200) {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!,  options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                    let capital = json["capital"]! as! String
                    let flagurl = json["flag"]! as! String
                    let population = json["population"] as! Int
                    //let currencyCode = currency[code] as? [String:Any]
                    country.setCapitalCountry(capital: capital)
                    let stringImageURL = "http://flags.fmcdn.net/data/flags/w580/\(self.countryCode).png"
                    let imageURL = URL(string: stringImageURL)!
                    
                    let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                        
                        if error == nil {
                            let downloadImage = UIImage(data: data!)
                            
                            DispatchQueue.main.async {
                               self.countryFlag.image = downloadImage
                               self.setInfosCountryUI(country: country)
                             
                            }
                            
                        }
                    }
                    
                    task.resume()
              
                    country.setFlagCountry(flagCountry: flagurl)
                    country.setCapitalCountry(capital: capital)
                    country.setPopulationCountry(populationCountry: population)
                    //country.setCurrency(currency: currency)
                    
                    
                }catch {
                    print("Error with Json: \(error)")
                }
            
            }
        
           
            
        }
        
        
        
        
        
        
        task.resume()
        

    }
    
    
    
}
