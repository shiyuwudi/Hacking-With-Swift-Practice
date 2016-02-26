//
//  ViewController.swift
//  Project2
//
//  Created by apple2 on 16/2/25.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//
import GameplayKit
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        let buttons = [button1, button2, button3]
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
        askQuestion()
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        var title : String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        let alertBody = "Your score is \(score)"
//        alertScore(title, alertBody: alertBody)
        labelScore(alertBody)
    }
    
    func labelScore(alertBody:String){
        self.label.text = alertBody
        askQuestion()
    }
    
    func alertScore(title:String, alertBody:String){
        
        let ac = UIAlertController(title: title, message: alertBody, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: askQuestion))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func askQuestion(action:UIAlertAction! = nil) {
        countries = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(countries) as! [String]
        button1.setImage(UIImage(named: countries[0]), forState: .Normal)
        button2.setImage(UIImage(named: countries[1]), forState: .Normal)
        button3.setImage(UIImage(named: countries[2]), forState: .Normal)
        //生成小于3的随机数
        correctAnswer = GKRandomSource.sharedRandom().nextIntWithUpperBound(3)
        title = countries[correctAnswer].uppercaseString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

