//
//  PostPictureViewController.swift
//  sns
//
//  Created by REO HARADA on 2017/10/29.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit

class PostPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var objectId = ""
    var imgPC = UIImagePickerController()
    var loadingManager = LoadingViewManager()
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgPC.delegate = self
        self.imgPC.allowsEditing = true
    }

    @IBAction func tapSelectFromPicture(_ sender: Any) {
        self.imgPC.sourceType = .photoLibrary
        self.present(imgPC, animated: true, completion: nil)
    }
    
    @IBAction func tapSelectFromCamera(_ sender: Any) {
        self.imgPC.sourceType = .camera
        self.present(imgPC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerEditedImage] as! UIImage
        selectedImageView.image = img
        self.imgPC.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapPostCompleteButton(_ sender: Any) {
        if self.selectedImageView.image == nil {
            self.notificationLabel.isHidden = false
            return
        }
        let data = UIImagePNGRepresentation(self.selectedImageView.image!)
        let file = NCMBFile.file(withName: objectId, data: data) as? NCMBFile
        loadingManager.show()
        file?.saveInBackground({ (error) in
            self.loadingManager.hide()
            if error == nil {
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
}
