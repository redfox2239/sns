//
//  LoadingViewController.swift
//  sns
//
//  Created by REO HARADA on 2017/10/29.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit

class LoadingViewManager {

    var loadingWindow: UIWindow!
    
    func show() {
        loadingWindow = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loadingVC = storyboard.instantiateViewController(withIdentifier: "LoadingViewController")
        loadingWindow.rootViewController = loadingVC
        loadingWindow.makeKeyAndVisible()
    }
    
    func hide() {
        UIApplication.shared.windows.forEach { (win) in
            if win != loadingWindow {
                win.makeKeyAndVisible()
            }
            else {
                loadingWindow = nil
            }
        }
    }
}
