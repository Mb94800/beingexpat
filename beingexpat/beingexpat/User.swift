//
//  User.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 25/03/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation

class User{
    
    var name: String
    var email: String
    var favoritesCountries: Array<String>
    
    
    init(name:String,email:String){
        self.name = name
        self.email = email
        self.favoritesCountries = []
        
    }
    
    public func getNameUser() -> String{
        return self.name
    }
    
    public func getEmailUser() -> String{
        return self.email
    }
    
    public func getFCUser() -> Array<String>{
        return self.favoritesCountries
    }
    
    public func setNameUser(name:String){
        self.name = name
    }

    
    public func setEmailUser(email:String){
        self.email = email
    }
    public func isFavouriteCountry(Country: Country) -> Bool{
        return false;
    }
    
    public func addFavouriteCountry(countryName: String,countrycode:String){
        self.favoritesCountries.append(countryName)
    }

    
}
