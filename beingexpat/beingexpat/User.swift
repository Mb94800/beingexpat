//
//  User.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 25/03/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation

class User{
    
    var id: String
    var name: String?
    var birthday: String?
    var email: String?
    var creationDate: String?
    var favoritesCountries: Array<String>
    
    
    init(id:String){
        self.id = id
        self.favoritesCountries = []
        
    }
    
    public func getCreationDate() -> String{
        return self.creationDate!
    }
    public func getNameUser() -> String{
        return self.name!
    }
    
    public func getEmailUser() -> String{
        return self.email!
    }
    
    public func getUserID() -> String{
        return self.id
    }
    
    public func getBirthday() -> String{
        return self.birthday!
    }
    
    public func getFCUser() -> Array<String>{
        return self.favoritesCountries
    }
    
    public func setBirthday(birthday:String){
        self.birthday = birthday
    }
    
    public func setCreationDate(creationDate:String){
        self.creationDate = creationDate
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
