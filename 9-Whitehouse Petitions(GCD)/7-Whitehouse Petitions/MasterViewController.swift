//
//  MasterViewController.swift
//  7-Whitehouse Petitions
//
//  Created by apple2 on 16/2/28.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit
import PKHUD

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
//    var objects = [String]()
    var objects = [[String: String]]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var urlString : String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=10"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=10"
        }
        guard let url = NSURL(string: urlString) else {
            return
        }
        HUD.show(HUDContentType.Progress)
        NSURLSession.sharedSession().dataTaskWithURL(url) {
            guard let data = $0.0 else {
                return
            }
//            let json = JSON(data)
//            print(data)
//            print(json)
            let dict = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            if let dict = dict {
                let json = JSON(dict)
                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                    // we're OK to parse!
                    self.parseJSON(json)
                }
            }
            
            
        }.resume()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
//        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self]() -> Void in
//            self.detailViewController
//        }
    }
    
    func parseJSON(json:JSON){
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            objects.append(["title":title, "body":body, "sigs":sigs])
        }
        HUD.flash(.Success, withDelay: 1.0)
        tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
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
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["sigs"]
        return cell
    }


}

