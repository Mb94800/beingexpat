//
//  UserInfosController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 28/04/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//
import Firebase
import Foundation

class UserInfosController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var line: UIView!
   
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var changePicture: UIImageView!
    @IBOutlet weak var emailAssociated: UILabel!
    @IBOutlet weak var birthday: UILabel!
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
 
         let tap = UITapGestureRecognizer(target: self, action: #selector(UserInfosController.optionsMenuChoosePicture))
        changePicture.addGestureRecognizer(tap)
        changePicture.isUserInteractionEnabled = true
        changePicture.makeCircle()
        changePicture.layer.borderWidth = 0.5 
        setUserInfosUI()
        

    }
    
    func setUserInfosUI(){
        profileName.text = user.getNameUser()
        birthday.text = user.getBirthday()
        emailAssociated.text = user.getEmailUser()
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        
        let picturesRef = storageRef.child("profilePictures/\(user.getUserID()).png")
        
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        picturesRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.profilePicture.image = image
            }
        }
    }
    
    
    
  
    func optionsMenuChoosePicture() {
        let camera = DSCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Prendre une photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Choisir depuis la bibliothèque", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.profilePicture.image = image
        
        // image is our desired image
        
        picker.dismiss(animated: true, completion: nil)
        //self.openPanel()
    }
}
