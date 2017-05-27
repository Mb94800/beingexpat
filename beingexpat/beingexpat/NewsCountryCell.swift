//
//  NewsCountryCell.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 10/05/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation

class NewsCountryCell: UITableViewCell{
    
    @IBOutlet weak var newsTitle: UILabel!
    
    @IBOutlet weak var newsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
