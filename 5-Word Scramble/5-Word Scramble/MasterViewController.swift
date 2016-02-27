//
//  MasterViewController.swift
//  5-Word Scramble
//
//  Created by shiyuwudi on 16/2/26.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit
import GameKit

class MasterViewController: UITableViewController {

    var objects = [String]()//用来保存回答记录
    var allWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")
        guard let path = NSBundle.mainBundle().pathForResource("start", ofType: "txt") else {
            return
        }
        let str = try? String(contentsOfFile: path)
        if let strArray = str?.componentsSeparatedByString("\n") {
            allWords = strArray
        }
        
        startGame()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startGame(){
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
        title = allWords[0]
        objects.removeAll(keepCapacity: true)
        tableView.reloadData()
    }
    
    func promptForAnswer(){
        let ac = UIAlertController(title: "输入答案", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        let aa = UIAlertAction(title: "OK", style: .Default) { [unowned self, ac] (action:UIAlertAction) -> Void in
            guard let text = ac.textFields?.first?.text else {
                return
            }
            self.submitAnswer(text)
        }
        ac.addAction(aa)
        presentViewController(ac, animated: true, completion: nil)
    }
    
    //MARK:- 字符串校验
    
    //字符取自原词且只用了一次
    func wordIsPossible(word: String) -> Bool {
        guard let title = title?.lowercaseString else {
            return false
        }

        var c1s = title.characters
        for c2 in word.characters {
            if c1s.contains(c2){
                let index = c1s.indexOf(c2)!
                c1s.removeAtIndex(index)
            } else {
                return false
            }
        }
        return true
    }
    
    //重复答案
    func wordIsOriginal(word: String) -> Bool {
        return !objects.contains(word)
    }
    
    //取自词库
    func wordIsReal(word: String) -> Bool {
        return allWords.contains(word)
    }
    
    //MARK:- 提交答案
    
    func submitAnswer(var answer:String){
        //先转换成小写字母
        answer = answer.lowercaseString
        print(answer)
        //检查:1.是否为重新排列的单词,2.是否在词库
        if wordIsPossible(answer) && wordIsOriginal(answer) && wordIsReal(answer) {
            objects.insert(answer, atIndex: 0)
            let firstRow = NSIndexPath(forRow: 0, inSection: 0)
            tableView.insertRowsAtIndexPaths([firstRow], withRowAnimation: .Fade)
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }
    

}

