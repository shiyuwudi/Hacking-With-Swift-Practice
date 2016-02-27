//
//  ViewController.swift
//  Easy Browser with WKWebView
//
//  Created by shiyuwudi on 16/2/26.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView : WKWebView! //from iOS 8.0
    lazy var progressView = UIProgressView(progressViewStyle: .Default) //监控网页加载进度
    var allowedWebsites = ["apple.com", "baidu.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL(string: "https://" + allowedWebsites[0])!
        webView.loadRequest(NSURLRequest(URL: url))
        
        //MARK:- 允许手势左右滑动导航
        webView.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .Plain, target: self, action: "openTapped")
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        //MARK:- 直接发消息给webView!!
        let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: webView, action: "reload")
        
        progressView.sizeToFit()
        let progressBar = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressBar, space, refresh]
        
        //MARK:- 直接使用默认自带的toolbar~~
        navigationController?.toolbarHidden = false
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .ActionSheet)
        for site in allowedWebsites {
            ac.addAction(UIAlertAction(title: site, style: .Default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func openPage(action:UIAlertAction! = nil) {
        let url = NSURL(string: "https://" + action.title!)!
        webView.loadRequest(NSURLRequest(URL: url))
    }
    
    //MARK:- Web View Delegate
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        guard let urlStr = navigationAction.request.URL?.absoluteString else{
            return
        }
        let site = urlStr.stringByReplacingOccurrencesOfString("https://", withString: "")
        
        for allowedSite in allowedWebsites {
            let range = site.rangeOfString(allowedSite)
            if range != nil {
                decisionHandler(.Allow)
                return
            }
        }
        
        decisionHandler(.Cancel)
    }
    
    
    
    
    
    

}

