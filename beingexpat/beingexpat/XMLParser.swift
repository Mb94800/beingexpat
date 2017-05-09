//
//  XMLParser.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 22/04/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation



class XMLParser: NSObject, XMLParserDelegate{
    
    var arrParsedData = [Dictionary<String, String>]()
    
    var currentDataDictionary = Dictionary<String, String>()
    
    var currentElement = ""
    
    var foundCharacters = ""
    
    
    var delegate : XMLParserDelegate?

}
