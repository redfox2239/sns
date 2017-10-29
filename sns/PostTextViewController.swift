//
//  PostTextViewController.swift
//  sns
//
//  Created by REO HARADA on 2017/10/29.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit

class PostTextViewController: UIViewController {
    @IBOutlet weak var postTextView: UITextView!
    var loadingManager = LoadingViewManager()
    
    @IBAction func tapNextButton(_ sender: Any) {
        let timeLineMessage = self.postTextView.text
        let object = NCMBObject(className: "timeLine")
        object?.setObject(timeLineMessage, forKey: "timeLineMessage")
        loadingManager.show()
        object?.saveInBackground({ (error) in
            self.loadingManager.hide()
            if error == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostPictureViewController") as! PostPictureViewController
                vc.objectId = object!.objectId
                self.show(vc, sender: nil)
            }
        })
    }
    
}
