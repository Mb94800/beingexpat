//
//  UserInfosController.swift
//  beingexpat
//
//  Created by Mohamed Said Boubaker on 28/04/2017.
//  Copyright © 2017 Mohamed Said Boubaker. All rights reserved.
//

import Foundation

class UserInfosController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var line: UIView!
   
    @IBOutlet weak var changePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
         let tap = UITapGestureRecognizer(target: self, action: #selector(UserInfosController.optionsMenuChoosePicture))
        changePicture.addGestureRecognizer(tap)
        changePicture.isUserInteractionEnabled = true
        changePicture.makeCircle()
        changePicture.layer.borderWidth = 2

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
        
        // image is our desired image
        
        picker.dismiss(animated: true, completion: nil)
        //self.openPanel()
    }
}
