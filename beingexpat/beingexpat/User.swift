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
    var favoritesCountries: Array<Country>
    
    
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
    
    public func getFCUser() -> Array<Country>{
        return self.favoritesCountries
    }
    
    public func isFavouriteCountry(Country: Country) -> Bool{
        return false;
    }


    
}
