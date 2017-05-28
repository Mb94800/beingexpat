//
//  ChatCountryViewController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 28/05/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation
import Firebase
import ObjectiveC
import JSQSystemSoundPlayer
import JSQMessagesViewController

final class ChatCountryViewController: JSQMessagesViewController{
  
    private var channelRefHandle: FIRDatabaseHandle?
    var channelRef: FIRDatabaseReference?
    var channel: String = ""
      
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = FIRAuth.auth()?.currentUser?.uid
    }
    

    

    
}
