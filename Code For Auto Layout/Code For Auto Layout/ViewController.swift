//
//  ViewController.swift
//  Code For Auto Layout
//
//  Created by apple2 on 16/2/26.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    let label4 = UILabel()
    let label5 = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.redColor()
        label1.text = "THESE"
        
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyanColor()
        label2.text = "ARE"
        
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellowColor()
        label3.text = "SOME"
        
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.greenColor()
        label4.text = "AWESOME"
        
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orangeColor()
        label5.text = "LABELS"
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
//        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
        let viewsDictionary = dictForViews([label1,label2,label3,label4,label5])
        
        for label in viewsDictionary.keys {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
        }
        
        //999优先级:很重要，但是不是必须
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==10)-[label1(h@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=20)-|", options: [], metrics: ["h":88], views: viewsDictionary))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func dictForViews(views:[UIView]) -> [String : UIView] {
        var count:UInt32 = 0
        var dict = [String : UIView]()
        //self.classForCoder:控制器类名
        //class_copyIvarList:取得类对应实例变量(指针)的数组
        let ivars = class_copyIvarList(self.classForCoder, &count)
        for var i = 0; i < Int(count); ++i{
            //object_getIvar:取得实例变量
            let ivar = ivars[i]
            let obj = object_getIvar(self, ivar)
            guard let view = obj as? UIView, name = String.fromCString(ivar_getName(ivar)) else {
                break
            }
            //过滤其他变量
            if views.contains(view) {
                dict[name] = view
            }
        }
        free(ivars)
        return dict
    }

}

