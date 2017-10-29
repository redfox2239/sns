//
//  TimeLineViewController.swift
//  sns
//
//  Created by REO HARADA on 2017/10/29.
//  Copyright © 2017年 reo harada. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = [NCMBObject]()
    var loadingManager = LoadingViewManager()
    var imgCache = [String:UIImage]()
    
    var refresh = UIRefreshControl()
    
    @IBOutlet weak var snsTableView: UITableView!
    
    override func viewDidLoad() {
        self.snsTableView.delegate = self
        self.snsTableView.dataSource = self
        
        let xib = UINib(nibName: "TimeLineTableViewCell", bundle: nil)
        self.snsTableView.register(xib, forCellReuseIdentifier: "TimeLineTableViewCell")
        
        self.refresh.addTarget(self, action: #selector(TimeLineViewController.reloadData), for: UIControlEvents.valueChanged)
        self.snsTableView.addSubview(refresh)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let query = NCMBQuery(className: "timeLine")
        query?.order(byDescending: "createDate")
        loadingManager.show()
        query?.findObjectsInBackground({ (values, error) in
            self.loadingManager.hide()
            if error == nil {
                self.data = values as! [NCMBObject]
                self.snsTableView.reloadData()
            }
        })
    }
    
    @objc func reloadData() {
        let query = NCMBQuery(className: "timeLine")
        query?.order(byDescending: "createDate")
        loadingManager.show()
        query?.findObjectsInBackground({ (values, error) in
            self.refresh.endRefreshing()
            self.imgCache = [String:UIImage]()
            self.data = [NCMBObject]()
            self.loadingManager.hide()
            if error == nil {
                self.data = values as! [NCMBObject]
                self.snsTableView.reloadData()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.snsTableView.dequeueReusableCell(withIdentifier: "TimeLineTableViewCell", for: indexPath) as! TimeLineTableViewCell
        cell.timeLineLabel.text = self.data[indexPath.row].object(forKey: "timeLineMessage") as? String
        cell.timeLineImageView.image = nil
        let objectId = self.data[indexPath.row].objectId
        if self.imgCache[objectId!] == nil {
            let file = NCMBFile.file(withName: self.data[indexPath.row].objectId, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error == nil {
                    cell.timeLineImageView.image = UIImage(data: data!)
                    self.imgCache[self.data[indexPath.row].objectId] = UIImage(data: data!)
                }
            }
        } else {
            cell.timeLineImageView.image = self.imgCache[objectId!]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
