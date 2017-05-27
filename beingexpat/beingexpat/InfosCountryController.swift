//
//  InfosCountryController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 10/04/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit
import Firebase


class InfosCountryController: UIViewController{
    @IBOutlet weak var countryLabelName: UILabel!
    var countryName = ""
    var countryCode = ""
    var ref: FIRDatabaseReference!

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
        self.ref = FIRDatabase.database().reference()
        self.countryLabelName.text = countryName
        var country = Country(nameCountry:countryName)
       
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
    
    @IBOutlet weak var countryView: MKMapView!
    func loadGMView(country: Country){
        print("debut loadgmview")
        var countryname = country.getNameCountry()
        countryname = countryname.removingWhitespaces()
        var stringurl = "http://maps.googleapis.com/maps/api/geocode/json?address=\(countryname.folding(options: .diacriticInsensitive, locale: .current))"
        
        
        let url = URL(string:stringurl)
        
        let request = URLRequest(url:url!)
        let session = URLSession.shared
        
        let task = session.dataTask(with:url!) { (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            dump(statusCode)
            
            if let error = error {
                print("problem")
            }
            if (statusCode == 200) {
                do{
                    
                    if let dataGAPI = data{
                        
                        let json = try JSONSerialization.jsonObject(with: dataGAPI, options: .allowFragments) as? [String: Any]
                    
       
                        if let results = json?["results"] as? [[String:Any]]{
                            if let geometry = results.first? ["geometry"] as? [String:Any]{
                                if let location = geometry["location"] as? [String:Any]{
                                    let lat = location["lat"] as! Double
                                    let lng = location["lng"] as! Double
                                    var latDelta:CLLocationDegrees = 5
                                    var longDelta:CLLocationDegrees = 5
                                    
                                    var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
                                    var pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,lng)
                                    var region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
                                    self.countryView.setRegion(region,animated: true)
                                    var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat,lng)
                                    var objectAnnotation = MKPointAnnotation()
                                    objectAnnotation.coordinate = pinLocation
                                    objectAnnotation.title = country.getNameCountry()
                                    self.countryView.addAnnotation(objectAnnotation)
                                }
                            }
                    
                       
                        }
                    
                }
   
                   
                    
                    
                
                
                
                
            }catch{
                
            }
            
            }
        
        
        }
        
        task.resume();
        print("fin loadgmview")
    
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
        
        
        
    }
    
    private func getNbFrenchAbroad(country: Country){

  
       
        self.ref.child("countries").child(country.getNameCountry() as String).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String:Any]{
                dump(value)
                var nbFR2015 = value["nbFR2015"]
                var nbFR2016 = value["nbFR2016"]
            
              
                country.setNbFrench2015(nb2015: "\(nbFR2015!)")
                country.setNbFrench2016(nb2016: "\(nbFR2016!)")
                print(nbFR2015)
                self.french2015.text = ((country.getNbFrench2015()) + " en 2015")
                self.french2016.text = ((country.getNbFrench2016()) + " en 2016")
            }
            
        })


    }
    
    private func getInfosCountry(country: Country){
        let url = URL(string: "\(Constants.RestCountries.APIBaseURL)\(self.countryCode)")!
        
        let request = URLRequest(url:url)
        let session = URLSession.shared
  
  
        let task = session.dataTask(with:url) { (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
           
           
            if (statusCode == 200) {
                print(statusCode)
             
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
            
            }else{
              
            }
        
           
            
        }
        
    
        
        
        
        
        
        task.resume()
        

    }

    
    
}
