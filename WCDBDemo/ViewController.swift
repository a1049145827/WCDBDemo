//
//  ViewController.swift
//  WCDBDemo
//
//  Created by Bruce on 2018/3/1.
//  Copyright © 2018年 snailvr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(NSHomeDirectory())
//        print(Date())
        
        print("insertData")
        DatabaseManager.shared.insertData()
        
        print("updateData")
        DatabaseManager.shared.updateData()
        
        print("getData")
        let _ = DatabaseManager.shared.getData()
        
        print("deleteData")
        DatabaseManager.shared.deleteData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

