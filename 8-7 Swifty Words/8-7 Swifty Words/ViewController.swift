//
//  ViewController.swift
//  8-7 Swifty Words
//
//  Created by apple2 on 16/2/28.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    
    var letterButtons = [UIButton]()//所有按钮
    var activatedButtons = [UIButton]()//已经被选择的按钮
    var solutions = [String]()//所有单词
    
    var score = 0
    var level = 1//当前关卡
    
    //MARK:- touch event
    
    func letterTapped(button:UIButton) {
        currentAnswer.text = currentAnswer.text! + button.titleForState(.Normal)!
        activatedButtons.append(button)
        button.hidden = true
    }
    
    @IBAction func submitTapped(sender: AnyObject) {
        guard let index = solutions.indexOf(currentAnswer.text!) else {
            clearTapped()
            return
        }
        //猜到正确答案了
        activatedButtons.removeAll()
        var letterNumbers = answersLabel.text!.componentsSeparatedByString("\n")
        letterNumbers[index] = currentAnswer.text!
        answersLabel.text = letterNumbers.joinWithSeparator("\n")
        currentAnswer.text = ""
        score += 1
        scoreLabel.text = "Score: \(score)"
        if score % 7 == 0 && score != 0 {
            showCongrats()
        }
    }
    
    @IBAction func clearTapped(sender: AnyObject! = nil) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.hidden = false
        }
        activatedButtons.removeAll()
    }
    
    //MARK:- other game logic
    
    func showCongrats(){
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Let's go!", style: .Default, handler: levelUp))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func levelUp(action:UIAlertAction! = nil){
        //进入下一关
        level += 1
        loadLevel()
    }
    
    //MARK:- life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addButtonToArray()
        loadLevel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- level init
    
    func addButtonToArray () {
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: "letterTapped:", forControlEvents: .TouchUpInside)
        }
    }

    func loadLevel () {
        
        for letterButton in letterButtons {
            letterButton.hidden = false
        }
        
        var clueString = "" //提示 eg:Ghosts in residence
        var solutionString = ""//字符数 eg:7 letters
        var letterBits = [String]()//被打散的单词 eg: HAUNTED -> HA,UNT,ED
        
        let levelName = "level\(level)"
        guard let path = NSBundle.mainBundle().pathForResource(levelName, ofType: "txt") else {
            return
        }
        guard let contents = try? String(contentsOfFile: path) else {
            return
        }
        var lines = contents.componentsSeparatedByString("\n")
        lines = shuffle(lines) as! [String]
        
        for (index,line) in lines.enumerate(){
            let hint = line.componentsSeparatedByString(":")[1]
            clueString += "\(index + 1) \(hint)\n"
            let left = line.componentsSeparatedByString(":")[0]
            let pieces = left.componentsSeparatedByString("|")
            let word = left.stringByReplacingOccurrencesOfString("|", withString: "")
            let count = word.characters.count
            solutionString += "\(count) letters \n"
            letterBits += pieces
            solutions.append(word)
        }
        
        //设置UI
        cluesLabel.text = clueString
        answersLabel.text = solutionString
        
        letterBits = shuffle(letterBits) as! [String]
        letterButtons = shuffle(letterButtons) as! [UIButton]
        
        if letterBits.count == letterButtons.count {
            for i in 0..<letterButtons.count {
                let btn = letterButtons[i]
                let bit = letterBits[i]
                btn.setTitle(bit, forState: .Normal)
            }
        }

    }
    
    func shuffle(array:[AnyObject]) -> [AnyObject] {
        return GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(array)
    }
    

}

