//
//  ViewController.swift
//  4-Easy Browser with WKWebView
//
//  Created by apple2 on 16/2/25.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit
import Social
import Accounts

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSURLSession.sharedSession()
        
    }
    
    //不能放header
    func request(){
        let req = SLRequest(forServiceType: SLServiceTypeSinaWeibo, requestMethod: .POST, URL: NSURL(string: "http://apis.baidu.com/apistore/currencyservice/type"), parameters: nil)
        req.performRequestWithHandler { (data, resp, err) -> Void in
            if let data = data {
                let object = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                print(object)
            }
            if let resp = resp {
                print("resp:\(resp)")
            }
            if let err = err {
                print(err.localizedDescription)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

