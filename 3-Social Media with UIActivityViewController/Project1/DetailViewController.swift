//
//  DetailViewController.swift
//  Project1
//
//  Created by apple2 on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!


    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        guard let detail = self.detailItem, imageView = self.detailImageView else {
            return
        }
        
        imageView.image = UIImage(named: detail)
        title = detail
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareTapped")
    }
    
    func shareTapped () {
//        quickShare()
        easyShare()
    }
    
    //图片，文字，URL
    func easyShare() {
        let cvc = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        cvc.setInitialText("测试图片分享，请无视")
        cvc.addImage(UIImage(named: "chitoge"))
        cvc.addURL(NSURL(string: "https://www.baidu.com"))
        presentViewController(cvc, animated: true, completion: nil)
    }
    
    //分享图片，文字
    func quickShare(){
        let a1 = MyActivity()
        let a2 = MyActivity()
        let avc = UIActivityViewController(activityItems: [detailImageView.image!], applicationActivities: [a1, a2])
        presentViewController(avc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

class MyActivity: UIActivity {
    
    //服务ID，不会展示给用户
    override func activityType() -> String? {
        return "My Service"
    }
    
    //服务标题
    override func activityTitle() -> String? {
        return "特殊服务"
    }
    
    //服务图标?
    override func activityImage() -> UIImage? {
        return UIImage(named: "special_service")
    }
    
    //服务对象
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        print(activityItems)
        return false
    }
    
}

