//
//  Country.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 25/03/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation


class Country{
    
    var nameCountry: String
    var capitalCountry: String
    var populationCountry: Int
    var currencyCountry: String
    var flagCountry: String
    
    init(nameCountry:String){
        self.nameCountry = nameCountry
        self.populationCountry = 0;
        self.currencyCountry = ""
        self.flagCountry = ""
        self.capitalCountry = ""
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
    
    public func setCurrency(currency: String){
        self.currencyCountry  = currency
    }
    
    public func setCapitalCountry(capital: String){
        self.capitalCountry = capital
    }
    
    public func setFlagCountry(flagCountry: String){
        self.flagCountry = flagCountry
    }
}
