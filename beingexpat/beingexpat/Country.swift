//
//  Country.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 25/03/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation
struct Number {
    static let formatterWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Integer {
    var stringFormattedWithSeparator: String {
        return Number.formatterWithSeparator.string(for: self) ?? ""
    }
}

class Country{
    
    var nameCountry: String
    var capitalCountry: String
    var populationCountry: Int
    var currencyCountry: String
    var flagCountry: String
    var nbFrench2015: String
    var nbFrench2016: String
    
   
    init(nameCountry:String){
        self.nameCountry = nameCountry
        self.populationCountry = 0;
        self.currencyCountry = ""
        self.flagCountry = ""
        self.capitalCountry = ""
        self.nbFrench2015 = ""
        self.nbFrench2016 = ""
    }
    
    
    
    public func getNameCountry() -> String{
        return self.nameCountry
    }
    
    public func getFlagCountry()-> String{
        return self.flagCountry
    }
    
    public func getCapitalCountry() -> String{
        return self.capitalCountry
    }
    
    public func getCurrencyCountry()-> String{
        return self.currencyCountry
    }
    
    public func getNbFrench2015()-> String{
        return self.nbFrench2015
    }
    
    public func getNbFrench2016()-> String{
        return self.nbFrench2016
    }
    
    public func getPopulationCountry() -> String{
       return NumberFormatter.localizedString(from: NSNumber(value: self.populationCountry), number: NumberFormatter.Style.decimal)
        
    }
    
    public func setNbFrench2015(nb2015:String){
        self.nbFrench2015 = nb2015
    }
    
    public func setNbFrench2016(nb2016:String){
        self.nbFrench2016 = nb2016
    }
    public func setCurrency(currency: String){
        self.currencyCountry  = currency
    }
    
    public func setCapitalCountry(capital: String){
        self.capitalCountry = capital
    }
    
    public func setFlagCountry(flagCountry: String){
        self.flagCountry = flagCountry
    }
    
    public func setPopulationCountry(populationCountry: Int){
        self.populationCountry = populationCountry
    }
    
}
